_G.BRIDGE_LOCAL_INSTANCE = (_G.BRIDGE_LOCAL_INSTANCE or 0) + 1
local MY_INSTANCE = _G.BRIDGE_LOCAL_INSTANCE

local function isAlive()
    return _G.BRIDGE_LOCAL_INSTANCE == MY_INSTANCE
end

-- Close previous WS if exists
if _G.BRIDGE_LOCAL_WS_REF then
    pcall(function() _G.BRIDGE_LOCAL_WS_REF:Close() end)
    _G.BRIDGE_LOCAL_WS_REF = nil
end

local BRIDGE_PORT = getgenv().BRIDGE_PORT or 9993
local PROFILE_INDEX = getgenv().PROFILE_INDEX or 0
local BRIDGE_WS = "ws://localhost:" .. tostring(BRIDGE_PORT)
local BRIDGE_HTTP = "http://localhost:" .. tostring(BRIDGE_PORT)
local POLL_INTERVAL = 2

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer and LocalPlayer.Character

local httpRequest = (function()
    if syn and syn.request then return syn.request end
    if http_request then return http_request end
    if request then return request end
    if http and http.request then return http.request end
    if fluxus and fluxus.request then return fluxus.request end
    return nil
end)()

local function sendRequest(method, endpoint, body)
    local url = BRIDGE_HTTP .. endpoint
    local headers = { ["Content-Type"] = "application/json" }
    if httpRequest then
        local ok, response = pcall(function()
            return httpRequest({ Url = url, Method = method, Headers = headers, Body = body and HttpService:JSONEncode(body) or nil })
        end)
        if ok and response then
            local data = nil
            pcall(function() data = HttpService:JSONDecode(response.Body or response.body or "") end)
            return data, response.StatusCode or response.status_code
        end
        return nil, 0
    else
        if method == "GET" then
            local ok, result = pcall(function() return game:HttpGet(url) end)
            if ok then
                local data = nil
                pcall(function() data = HttpService:JSONDecode(result) end)
                return data, 200
            end
        elseif method == "POST" then
            local ok, result = pcall(function()
                return HttpService:PostAsync(url, HttpService:JSONEncode(body or {}), Enum.HttpContentType.ApplicationJson, false, headers)
            end)
            if ok then
                local data = nil
                pcall(function() data = HttpService:JSONDecode(result) end)
                return data, 200
            end
        end
        return nil, 0
    end
end

local function getExecutorName()
    if syn then return "Synapse X" end
    if is_sirhurt_closure then return "SirHurt" end
    if KRNL_LOADED then return "KRNL" end
    if fluxus then return "Fluxus" end
    if getexecutorname then
        local ok, name = pcall(getexecutorname)
        if ok then return name end
    end
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok then return name end
    end
    return "Unknown"
end

local deviceInfo = {
    player = LocalPlayer.Name,
    userId = tostring(LocalPlayer.UserId),
    game = tostring(game.PlaceId),
    gameName = "",
    executor = getExecutorName(),
}
pcall(function() deviceInfo.gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "" end)

local function executeScript(script)
    local wrappedScript = "local __bridge_fn = function()\n" .. script .. "\nend\nreturn __bridge_fn()"
    local fn, compileError = loadstring(wrappedScript)
    if not fn then return nil, "Compile Error: " .. tostring(compileError) end
    local ok, result = pcall(fn)
    if not ok then return nil, "Runtime Error: " .. tostring(result) end
    if result == nil then return "(nil)", nil
    elseif type(result) == "table" then
        local ok2, json = pcall(function() return HttpService:JSONEncode(result) end)
        if ok2 then return json, nil end
        return tostring(result), nil
    else
        return tostring(result), nil
    end
end

local isWsActive, wsSendFunc = false, nil

-- === WebSocket Mode ===
local function tryWebSocket()
    local WebSocket = nil
    if syn and syn.websocket then WebSocket = syn.websocket
    elseif getgenv().WebSocket then WebSocket = getgenv().WebSocket end

    local wsConnect = nil
    if WebSocket and WebSocket.connect then wsConnect = function(url) return WebSocket.connect(url) end
    elseif syn and syn.websocket and syn.websocket.connect then wsConnect = function(url) return syn.websocket.connect(url) end end

    if not wsConnect then return false end

    local wsUrl = BRIDGE_WS .. "?profileIndex=" .. tostring(PROFILE_INDEX)
    local ok, ws = pcall(wsConnect, wsUrl)
    if not ok or not ws then isWsActive = false return false end
    _G.BRIDGE_LOCAL_WS_REF = ws

    local function wsSend(data) pcall(function() ws:Send(HttpService:JSONEncode(data)) end) end

    wsSendFunc, isWsActive = wsSend, true
    wsSend({ type = "register", profileIndex = PROFILE_INDEX, info = deviceInfo })
    wsSend({ type = "log", message = "Bridge Local started WS. Player: " .. LocalPlayer.Name .. " | Profile: " .. tostring(PROFILE_INDEX) .. " | Executor: " .. getExecutorName() })

    ws.OnMessage:Connect(function(raw)
        if not isAlive() then pcall(function() ws:Close() end) return end
        local msgOk, msg = pcall(function() return HttpService:JSONDecode(raw) end)
        if not msgOk or not msg then return end

        if msg.type == "replaced" then
            isWsActive = false
            pcall(function() ws:Close() end)
            return
        elseif msg.type == "command" and msg.command then
            local cmd = msg.command
            wsSend({ type = "log", message = "Executing: " .. (cmd.id or "?"):sub(1, 8) .. "..." })
            local output, err = executeScript(cmd.script)
            wsSend({ type = "result", commandId = cmd.id, output = output or "", error = err })
            if err then
                wsSend({ type = "log", message = "ERROR: " .. err })
            else
                wsSend({ type = "log", message = "OK: " .. (cmd.id or "?"):sub(1, 8) })
            end
        elseif msg.type == "heartbeat-ack" then
            _G.lastLocalHeartbeatAck = tick()
        end
    end)

    ws.OnClose:Connect(function()
        if isWsActive then isWsActive = false end
    end)

    -- Heartbeat loop
    task.spawn(function()
        _G.lastLocalHeartbeatAck = tick()
        while isWsActive and isAlive() do
            pcall(function() wsSend({ type = "heartbeat" }) end)
            task.wait(10)
            if not isAlive() then
                isWsActive = false
                pcall(function() ws:Close() end)
                break
            end
            if isWsActive and (tick() - _G.lastLocalHeartbeatAck > 25) then
                isWsActive = false
                pcall(function() ws:Close() end)
                break
            end
        end
    end)

    while isWsActive and isAlive() do task.wait(1) end
    if not isAlive() then pcall(function() ws:Close() end) end
    return true
end

-- === HTTP Fallback Mode ===
local function httpPollLoop()
    local registered = false
    for i = 1, 5 do
        local data = sendRequest("POST", "/register", { profileIndex = PROFILE_INDEX, info = deviceInfo })
        if data then
            registered = true
            break
        end
        task.wait(2)
    end
    if not registered then return end
    sendRequest("POST", "/log", { profileIndex = PROFILE_INDEX, message = "Bridge Local HTTP poll. Player: " .. LocalPlayer.Name .. " | Profile: " .. tostring(PROFILE_INDEX) })

    while task.wait(POLL_INTERVAL) do
        if not isAlive() then return end
        local data, statusCode = sendRequest("GET", "/poll/" .. tostring(PROFILE_INDEX))
        if statusCode == 404 then return false end
        if data and data.command then
            local cmd = data.command
            local output, err = executeScript(cmd.script)
            sendRequest("POST", "/result", { profileIndex = PROFILE_INDEX, commandId = cmd.id, output = output or "", error = err })
            if err then
                sendRequest("POST", "/log", { profileIndex = PROFILE_INDEX, message = "Command " .. (cmd.id or "?"):sub(1, 8) .. " ERROR: " .. err })
            else
                sendRequest("POST", "/log", { profileIndex = PROFILE_INDEX, message = "Command " .. (cmd.id or "?"):sub(1, 8) .. " OK" })
            end
        end
    end
end

-- === Main Loop: WS first, HTTP fallback ===
task.spawn(function()
    while isAlive() do
        local success, wsSupported = pcall(tryWebSocket)
        if not isAlive() then break end
        if success and wsSupported then
            task.wait(3)
        else
            httpPollLoop()
            task.wait(3)
        end
    end
end)
