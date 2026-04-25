local coreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local hasWrittenError = false

local RECONNECT_KW = {"reconnect", "verbinden", "reconectar", "переподключиться", "kết nối lại"}
local LEAVE_KW = {"leave", "verlassen", "sair", "salir", "quitter", "выйти", "keluar", "thoát"}
local BAN_CODES = {["273"] = true, ["148"] = true, ["6"] = true}
local BAN_KEYWORDS = {
    "ban", "banned", "permanent", "suspended",
    "cấm", "khóa", "vĩnh viễn",
    "banido", "banimento", "suspenso",
    "baneado", "prohibido", "suspendido",
    "banni", "interdiction", "suspendu",
    "gesperrt", "verbannt", "dauerhaft",
    "заблокирован", "бан",
    "dilarang", "permanen"
}

local function matchAny(str, list)
    for _, kw in ipairs(list) do
        if str:find(kw, 1, true) then return true end
    end
    return false
end

local function UltimateKeyboardClick(btn)
    pcall(function()
        local GuiService = game:GetService("GuiService")
        local VIM = game:GetService("VirtualInputManager")
        GuiService.SelectedCoreObject = btn
        task.wait(0.1)
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        GuiService.SelectedCoreObject = nil
    end)
end

local function HandleErrorPrompt()
    local promptOverlay = coreGui:FindFirstChild("RobloxPromptGui")
    if promptOverlay then promptOverlay = promptOverlay:FindFirstChild("promptOverlay") end
    if not promptOverlay or not promptOverlay:FindFirstChild("ErrorPrompt") then return false end

    local errPrompt = promptOverlay.ErrorPrompt
    local fullText = ""
    local reconnectBtnObj = nil
    local leaveBtnObj = nil

    for _, desc in ipairs(errPrompt:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Visible and desc.Text then
            fullText = fullText .. " " .. desc.Text:lower()
        end
        if desc:IsA("GuiButton") and desc.Visible then
            local nameStr = desc.Name:lower()
            local textStr = ""
            if desc:IsA("TextButton") then
                textStr = desc.Text:lower()
            else
                local lbl = desc:FindFirstChildWhichIsA("TextLabel")
                if lbl then textStr = lbl.Text:lower() end
            end

            if matchAny(nameStr, RECONNECT_KW) or matchAny(textStr, RECONNECT_KW) then
                reconnectBtnObj = desc
            end
            if matchAny(nameStr, LEAVE_KW) or matchAny(textStr, LEAVE_KW) then
                leaveBtnObj = desc
            end
        end
    end

    local codeNum = fullText:match("error code: (%d+)")
                 or fullText:match("code: (%d+)")
                 or fullText:match("fehlercode: (%d+)")
                 or fullText:match("%((%d+)%)")

    local errorState = nil

    if codeNum and BAN_CODES[codeNum] then
        errorState = "banned"
    elseif matchAny(fullText, BAN_KEYWORDS) then
        errorState = "banned"
    end

    if errorState then
        if not hasWrittenError then
            local player = Players.LocalPlayer
            if player then
                pcall(function()
                    writefile(
                        string.format("%sError.json", player.Name),
                        HttpService:JSONEncode({ State = errorState, Code = codeNum or "unknown" })
                    )
                end)
                hasWrittenError = true
            end
        end
        return true
    end

    if reconnectBtnObj then
        UltimateKeyboardClick(reconnectBtnObj)
        return true
    end
    if leaveBtnObj then
        UltimateKeyboardClick(leaveBtnObj)
        return true
    end

    return false
end

task.spawn(function()
    while true do
        HandleErrorPrompt()
        task.wait(30)
    end
end)

task.spawn(function()
    pcall(function()
        local promptOverlay = coreGui:WaitForChild("RobloxPromptGui", 10):WaitForChild("promptOverlay", 10)
        if promptOverlay then
            promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    task.wait(1.5)
                    HandleErrorPrompt()
                end
            end)
        end
    end)
end)
