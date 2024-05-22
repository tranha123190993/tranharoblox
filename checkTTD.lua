local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataRemoteEvent = ReplicatedStorage:WaitForChild("dataRemoteEvent")
local player = game.Players.LocalPlayer
local data = {}
local fragmentsValue, raceValue = nil, nil
local flags = {
    Coins = false,
    Gems = false
}

local function writeDataToFile()
    local success, errorMessage = pcall(function()
        writefile(string.format("%sData.json", player.Name), game:GetService("HttpService"):JSONEncode(data))
    end)

    if success then
        print(string.format("The file with name %sData.json has been written", player.Name))
    else
        warn("got error:", errorMessage)
    end
end
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

    if flags.Coins and flags.Gems then
    writeDataToFile()
    flags.Coins = false
    flags.Gems = false
end
end



dataRemoteEvent.OnClientEvent:Connect(handleData)

local function checkMoneyValue()
    if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
        return 1
    else
        return 0
    end
end

local function isGuiObjectVisible(guiObject)
    return guiObject and guiObject:IsA("GuiObject") and guiObject.Visible or false
end

local function teleportIfPlayAgainInvisible()
    local matchFinishGui = player.PlayerGui:FindFirstChild("Match") and player.PlayerGui.Match:FindFirstChild("MatchFinish")

    if matchFinishGui then
        if isGuiObjectVisible(matchFinishGui) then
            local playAgainFrame = matchFinishGui:FindFirstChild("MatchFinishFrame") and matchFinishGui.MatchFinishFrame:FindFirstChild("EndOptions") and matchFinishGui.MatchFinishFrame.EndOptions:FindFirstChild("PlayAgain")
            if playAgainFrame and not isGuiObjectVisible(playAgainFrame) then
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end
        else
            print("MatchFinish không hiển thị.")
        end
    else
        print("MatchFinish không tồn tại.")
    end
end

local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui") and game:GetService("CoreGui").RobloxPromptGui:FindFirstChild("promptOverlay")
local connection

if promptOverlay then
    connection = promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(game.PlaceId)
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

        data['Basic Data'] = {
            Level = 2550,
            Beli = checkMoneyValue(),
            Fragments = fragmentsValue or getCoins,
            DevilFruit = "TTD"
            Race = raceValue or getGems,
            ['Fighting Style'] = "TTD"
        }

        data['Items Inventory'] = {""}
        data['Fruits Inventory'] = {""}

        writeDataToFile()

        wait(35)
    end
end)
