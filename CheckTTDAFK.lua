local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local dataRemoteEvent
local networkingContainer = ReplicatedStorage:FindFirstChild("NetworkingContainer")
if networkingContainer then
    dataRemoteEvent = networkingContainer:FindFirstChild("DataRemote")
end
if not dataRemoteEvent then
    dataRemoteEvent = ReplicatedStorage:FindFirstChild("dataRemoteEvent")
end

local data = {}
local fragmentsValue, raceValue = nil, nil
local gameID = 13775256536
local flags = {
    Coins = false,
    Gems = false
}

local function ClickAtPosition(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- Hàm ghi dữ liệu vào file
local function writeDataToFile()
    local success, errorMessage = pcall(function()
        writefile(string.format("%sData.json", player.Name), HttpService:JSONEncode(data))
    end)

    if success then
        print(string.format("The file with name %sData.json has been written", player.Name))
    else
        warn("Got error:", errorMessage)
    end
end

-- Hàm xử lý dữ liệu nhận được
local function handleData(tbl)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            if next(v) ~= nil then
                handleData(v)
            end
        elseif type(k) == "string" and (k == "Coins" or k == "Gems") and v ~= nil then
            data['Basic Data'] = data['Basic Data'] or {}
            if k == "Coins" then
                data['Basic Data']['Fragments'] = tostring(v)
                fragmentsValue = tostring(v)
                flags.Coins = true
            elseif k == "Gems" then
                data['Basic Data']['Race'] = tostring(v)
                raceValue = tostring(v)
                flags.Gems = true
            end
        end
    end

    -- Ghi dữ liệu khi có đủ cả Coins và Gems
    if flags.Coins and flags.Gems then
        writeDataToFile()
        flags.Coins = false
        flags.Gems = false
    end
end

dataRemoteEvent.OnClientEvent:Connect(handleData)

local function checkMoneyValue()
    local lobby = player.PlayerGui:FindFirstChild("Lobby") and player.PlayerGui.Lobby:FindFirstChild("CurrenciesFrame")
    if not lobby then
        return 1
    else
        local updateLog = lobbyGui and lobbyGui:FindFirstChild("UpdateLog")
        if updateLog and updateLog:IsA("GuiObject") then
            if updateLog.Visible then
                updateLog.Visible = false
            end
        end
        wait(1)
        local lifts = workspace.Lifts:GetChildren()
        local targetValue = "TheVoid"

        for i, lift in ipairs(lifts) do
            if lift:GetAttribute("Map") == targetValue then
                local statusGui = lift:FindFirstChild("BasePart") 
                                and lift.BasePart:FindFirstChild("StatusGui") 
                                and lift.BasePart.StatusGui:FindFirstChild("PlayersCount")

                if statusGui and statusGui:IsA("TextLabel") and statusGui.Text == "0/5" then
                    local player = game.Players.LocalPlayer
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        humanoidRootPart.CFrame = lift.BasePart.CFrame
                        break
                    else
                        print("Cannot teleport: HumanoidRootPart not found.")
                    end
                end
            end
        end
        wait(2)
        local buttonPosition = player.PlayerGui:WaitForChild("Lobby"):WaitForChild("readyButton").AbsolutePosition
        local buttonSize = player.PlayerGui:WaitForChild("Lobby"):WaitForChild("readyButton").AbsoluteSize
        local centerX = buttonPosition.X + (buttonSize.X / 2)
        local centerY = buttonPosition.Y + (buttonSize.Y / 2) + 35
        ClickAtPosition(centerX, centerY)
        return 0
    end
end

local function teleportIfPlayAgainInvisible()
    local matchFinishGui = player.PlayerGui:FindFirstChild("Match") and player.PlayerGui.Match:FindFirstChild("MatchFinish")

    if matchFinishGui and matchFinishGui:FindFirstChild("MatchFinishFrame") then
        local playAgainFrame = matchFinishGui.MatchFinishFrame:FindFirstChild("EndOptions") and matchFinishGui.MatchFinishFrame.EndOptions:FindFirstChild("PlayAgain")
        if playAgainFrame and not playAgainFrame.Visible then
            TeleportService:Teleport(gameID)
        else
            print("MatchFinish không hiển thị.")
        end
    else
        print("MatchFinish không tồn tại.")
    end
end

local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
local connection

if promptOverlay then
    connection = promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            TeleportService:Teleport(gameID)
            connection:Disconnect()
        end
    end)
end

setfpscap(15)
spawn(function()
    while true do 
        teleportIfPlayAgainInvisible()
        local getCoins, getGems = "0", "0"
        local lobbyGui = player.PlayerGui:FindFirstChild("Lobby") and player.PlayerGui.Lobby:FindFirstChild("CurrenciesFrame")

        if lobbyGui then
            local coinAmount = lobbyGui:FindFirstChild("CoinAmount") and lobbyGui.CoinAmount:FindFirstChild("CurrencyLayout") and lobbyGui.CoinAmount.CurrencyLayout:FindFirstChild("AmountLabel")
            local gemAmount = lobbyGui:FindFirstChild("GemAmount") and lobbyGui.GemAmount:FindFirstChild("CurrencyLayout") and lobbyGui.GemAmount.CurrencyLayout:FindFirstChild("AmountLabel")
            
            getCoins = coinAmount and coinAmount.Text or "0"
            getGems = gemAmount and gemAmount.Text or "0"
        end

        -- Cập nhật lại dữ liệu 'Basic Data'
        data['Basic Data'] = {
            Level = 2550,
            Beli = checkMoneyValue(),
            Fragments = fragmentsValue or getCoins,
            Race = raceValue or getGems,
            DevilFruit = "TTD",
            ['Fighting Style'] = "TTD"
        }

        -- Cập nhật dữ liệu 'Items Inventory' và 'Fruits Inventory'
        data['Items Inventory'] = {""}
        data['Fruits Inventory'] = {""}

        -- Ghi lại dữ liệu vào file
        writeDataToFile()

        wait(35)
    end
end)
