local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getInventoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetInventory")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local gameID = 17017769292
local player = Players.LocalPlayer
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui") and game:GetService("CoreGui").RobloxPromptGui:FindFirstChild("promptOverlay")
local connection

if promptOverlay then
    connection = promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(gameID)
            connection:Disconnect()
        end
    end)
end

local data = {}
local function checkMoneyValue()
    local mapBorders = workspace:FindFirstChild("MapBorders")
    if mapBorders then
        return 1
    elseif workspace:FindFirstChild("Lobby") then
        return 0
    elseif workspace:FindFirstChild("TradingLobby") then
        return 0
    else
        return -1
    end
end
local function printSpecificValues(key, val)
    local specificKeys = {
        ["Trait Crystal"] = true,
        ["Energy Crystal"] = true,
        ["Star Rift (Red)"] = true,
        ["Star Rift (Blue)"] = true,
        ["Star Rift (Yellow)"] = true,
        ["Star Rift (Green)"] = true,
        ["Frost Bind"] = true,
        ["Risky Dice"] = true,
        ["Level"] = true,
        ["Gold"] = true,
        ["Gems"] = true,
        ["Type"] = true
    }

    if specificKeys[key] then
        if key == "Level" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Level"] = val
        elseif key == "Gold" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Fragments"] = val
        elseif key == "Gems" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Beli"] = val
        elseif key == "Type" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Fighting Style"] = val
        elseif key == "Trait Crystal" or key == "Energy Crystal" or key == "Frost Bind" or key == "Risky Dice" or
               key == "Star Rift (Red)" or key == "Star Rift (Blue)" or key == "Star Rift (Yellow)" or key == "Star Rift (Green)" then
            data["Items Inventory"] = data["Items Inventory"] or {}
            data["Items Inventory"][key] = val
        end
    end
end
local function writeDataToFile()
    local jsonData = HttpService:JSONEncode(data)
    local beliValue = checkMoneyValue()
    data["Basic Data"]["Race"] = beliValue
    if not data["Items Inventory"] then
        data["Items Inventory"] = {""}
    end
    data["Fruits Inventory"] = {""}

    local success, errorMessage = pcall(function()
        writefile(string.format("%sData.json", player.Name), jsonData)
    end)

    if success then
        print(string.format("The file with name %sData.json has been written", player.Name))
    else
        warn("got error:", errorMessage)
    end
end

local function printTable(tbl)
    for key, val in pairs(tbl) do
        if type(val) == "table" then
            if key == "Level" or key == "Currencies" or key == "Items" or key == "Units" then
                printTable(val)
            else
                printSpecificValues(key, val)
            end
        else
            printSpecificValues(key, val)
        end
    end
end
spawn(function()
    while true do
        local moneyValue = checkMoneyValue()
        local level = data["Basic Data"] and data["Basic Data"]["Level"] or 0
        print("Checking conditions... MoneyValue:", moneyValue, "Level:", level) 
        if moneyValue == 0 and level > 8 then
            local codes = {
                "MEMBEREREBREWRERES",
                "sorry4delay",
                "raidsarecool",
                "thanks400k",
                "dayum100m",
                "wsindach4ht",
                "200kholymoly",
                "adontop",
                "subcool",
                "sub2toadboigaming",
                "sub2mozking",
                "sub2karizmaqt",
                "sub2jonaslyz",
                "sub2riktime",
                "sub2nagblox",
                "release2024"
            }

            local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
            local useCodeRemote = remotesFolder:WaitForChild("UseCode", 5)

            for _, code in ipairs(codes) do
                spawn(function()
                    local success, result = pcall(function()
                        return useCodeRemote:InvokeServer(code)
                    end)
                    if success then
                        print("Successfully redeemed code:", code, "Result:", result)
                    else
                        warn("Error while redeeming code:", code, result)
                    end
                end)
            end
        end
        wait(20)
    end
end)
spawn(function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeSetting"):FireServer("Skills Enabled", false)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeSetting"):FireServer("Low Quality", true)

    while true do
        local success, value = pcall(function() return getInventoryRemote:InvokeServer() end)
        if success then
            printTable(value)
            writeDataToFile()
        else
            warn("Không thể nhận giá trị từ server: " .. tostring(value))
        end
        wait(10)
    end
end)
