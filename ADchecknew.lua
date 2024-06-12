local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getInventoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetInventory")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local gameID = 17017769292
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
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
local function ClickAtPosition(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    wait(0.2) 
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local function SendCtrlKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
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
        ["Gems"] = true
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
    local viewportFrame = player.PlayerGui.HUD.Toolbar.UnitBar.UnitHolder.UnitGridPrefab.Button.ViewportFrame
    local worldModel = viewportFrame:WaitForChild("WorldModel")

    if worldModel and worldModel:IsA("Model") and #worldModel:GetChildren() > 0 then
        -- Lấy con đầu tiên trong WorldModel
        local firstChild = worldModel:GetChildren()[1]
    
        data["Basic Data"]["Fighting Style"] = firstChild.Name
        data["Basic Data"]["Cost"] = player.PlayerGui.HUD.Toolbar.UnitBar.UnitHolder.UnitGridPrefab.Button.TowerCostFrame.CostLabel.Text
    else
        print("Không tìm thấy WorldModel hoặc không có con nào trong đó.")
    end

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
    local oldUTC = os.time(os.date("!*t"))
    while true do
        local moneyValue = checkMoneyValue()
        local level = data["Basic Data"] and data["Basic Data"]["Level"] or 0
        print("Checking conditions... MoneyValue:", moneyValue, "Level:", level)  -- Thêm dòng này để debug
        if moneyValue == 0 and level >= 8 then
            local codes = {
                "MEMBEREREBREWRERES",
                "sorry4delay",
                "raidsarecool",
                "thanks400k",
                "thanks500k",
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
        
        if os.time(os.date("!*t")) - oldUTC >= 5000 then
            game:GetService("TeleportService"):Teleport(gameID)
        end
        wait(20)
    end
end)
spawn(function()
    local promptGui = player.PlayerGui:WaitForChild("PromptGui", 10)
    local promptDefault = promptGui and promptGui:WaitForChild("PromptDefault", 10) or nil
    local button = promptDefault and promptDefault.Holder.Options:WaitForChild("Summon!", 3) and promptDefault.Holder.Options["Summon!"].TextLabel or nil

    if promptGui and promptDefault and button then
        -- Nếu tất cả đối tượng đều được tìm thấy, thực hiện các hành động nhấn nút
        local absolutePosition = button.AbsolutePosition
        local x, y = absolutePosition.X, absolutePosition.Y
        local absoluteSize = button.AbsoluteSize
        local centerX, centerY = x + absoluteSize.X / 2, y + absoluteSize.Y / 2 + 20
        ClickAtPosition(centerX, centerY)
        wait(10)
        SendCtrlKey()
        wait(1)
        ClickAtPosition(1, 1)
    else
        if not promptGui then
            warn("Không thể tìm thấy PromptGui trong PlayerGui")
        elseif not promptDefault then
            warn("Không thể tìm thấy PromptDefault trong PromptGui")
        elseif not button then
            warn("Không thể tìm thấy đối tượng button trong GUI")
        end
    end
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeSetting"):FireServer("Skills Enabled", false)
    repeat wait() until game:IsLoaded()
    wait(5)
        if isfolder('Luarmor') then delfolder('Luarmor') end
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Xenon-Trash/Loader/main/Loader.lua')){255966457793}
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
