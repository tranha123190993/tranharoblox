local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getInventoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetInventory")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local gameID = 17017769292
local player = Players.LocalPlayer
local viewportFrame = player.PlayerGui.HUD.Toolbar.UnitBar.UnitHolder.UnitGridPrefab.Button.ViewportFrame
local worldModel = viewportFrame.WorldModel
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
    if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Yen") then
        return 1
    else
        return 0
    end
end

local function printSpecificValues(key, val)
    local specificKeys = {
        ["Trait Crystal"] = true,
        ["Energy Crystal"] = true,
        ["Meat"] = true,
        ["Risky Dice"] = true,
        ["Level"] = true,
        ["Gold"] = true,
        ["Gems"] = true
    }

    if specificKeys[key] then
        -- Thêm dữ liệu vào biến data
        if key == "Level" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Level"] = val
        elseif key == "Gold" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Fragments"] = val
        elseif key == "Gems" then
            data["Basic Data"] = data["Basic Data"] or {}
            data["Basic Data"]["Race"] = val
        elseif key == "Trait Crystal" or key == "Energy Crystal" or key == "Meat" or key == "Risky Dice" then
            data["Items Inventory"] = data["Items Inventory"] or {}
            data["Items Inventory"][key] = val
        end
    end
end

local function writeDataToFile()
    local jsonData = HttpService:JSONEncode(data)
    local beliValue = checkMoneyValue()
    if beliValue == 0 and worldModel and worldModel:IsA("Model") and #worldModel:GetChildren() > 0 then
    -- Lấy con đầu tiên trong WorldModel
    local firstChild = worldModel:GetChildren()[1]
    
        data["Basic Data"]["Fighting Style"] = firstChild.Name
    else
        print("Không tìm thấy WorldModel hoặc không có con nào trong đó.")
    end
    data["Basic Data"]["Beli"] = beliValue
    data["Fruits Inventory"] = {""}

    local success, errorMessage = pcall(function()
        writefile(string.format("%sData.json", player.Name), jsonData)
    end)

    if success then
        print(string.format("The file with name %sData.json has been written", player.Name))
        print(jsonData)
    else
        warn("got error:", errorMessage)
    end
end

local function printTable(tbl)
    for key, val in pairs(tbl) do
        if type(val) == "table" then
            if key == "Level" or key == "Currencies" or key == "Items" then
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
        local success, value = pcall(function() return getInventoryRemote:InvokeServer() end)
        if success then
            printTable(value)
            writeDataToFile()
        else
            warn("Không thể nhận giá trị từ server: " .. tostring(value))
        end
        wait(20)
    end
end)
