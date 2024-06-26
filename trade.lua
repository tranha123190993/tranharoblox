local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getInventoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetInventory")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local promptGui = player.PlayerGui.PromptGui
local waitTime = 1
local characterName = getgenv().characterName
local gameID = 17017769292
local Mouse = player:GetMouse()
local data = {}
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

local function GetCenterPosition(guiElement)
    local absPos = guiElement.AbsolutePosition
    local absSize = guiElement.AbsoluteSize
    local x, y = absPos.X, absPos.Y
    local centerX, centerY = x + absSize.X / 2, y + absSize.Y / 2
    return centerX, centerY
end

local function SendKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(0.2)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end
local function checkMoneyValue()
    local mapBorders = workspace:FindFirstChild("MapBorders")
    if mapBorders then
        return 1
    elseif workspace:FindFirstChild("Lobby") then
        return 0
    elseif workspace:FindFirstChild("TradingLobby") then
        return 2
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
                if val == 0 then
                    data["Basic Data"]["Beli"] = 3000000
                else
                    data["Basic Data"]["Beli"] = val
                end
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
local function ClickButtonBack()
    local promptScreenGui = player.PlayerGui:FindFirstChild("PromptGui")
    if promptScreenGui then
        local promptDefault = promptScreenGui:FindFirstChild("PromptDefault")
        if promptDefault then
            local backButton = promptDefault.Holder.Options:FindFirstChild("Back")
            if backButton and backButton.Name == "Back" then
                local X, Y = GetCenterPosition(backButton)
                    ClickAtPosition(X - 20, Y + 40)
            end
        end
    end
end
local function ClickUnitGridPrefabs()
    local TradeTransactionUI = game.Players.LocalPlayer.PlayerGui.UI.TradeTransactionUI
    local SendContents = TradeTransactionUI.SendContents
    
    for _, unitGridPrefab in ipairs(SendContents:GetChildren()) do
        if unitGridPrefab:IsA("Frame") and unitGridPrefab.Visible then
            local button = unitGridPrefab.Button
            if button then
                local X, Y = GetCenterPosition(button)
                    ClickAtPosition(X - 20, Y + 40)
            end
        end
    end
end
local function GetAbsoluteCellCount(gridLayout)
    return gridLayout.AbsoluteCellCount
end

local function ClickAddItemsAndFindRiskyDice()
    local maxAttempts = 3  
    local attemptCount = 0  

    while attemptCount < maxAttempts do
        local TradeTransactionUI = game.Players.LocalPlayer.PlayerGui.UI.TradeTransactionUI
        local AddItemsButton = TradeTransactionUI.AddItemsButton
        local X, Y = GetCenterPosition(AddItemsButton)
        ClickAtPosition(X - 20, Y + 30)
        wait(1)
        local PromptGui = game.Players.LocalPlayer.PlayerGui.PromptGui
        local foundMatchingChild = false 
        for _, child in ipairs(PromptGui:GetChildren()) do
            local scrollingFrame = child:FindFirstChild("ScrollingFrame")
            if scrollingFrame then
                local uiGridLayout = scrollingFrame.UIGridLayout
                local absCellCount = GetAbsoluteCellCount(uiGridLayout)
                maxAttempts = absCellCount.X
                
                for _, subChild in ipairs(scrollingFrame:GetChildren()) do
                    if subChild.Name == "Risky Dice" or
                       subChild.Name == "Trait Crystal" or
                       subChild.Name == "Energy Crystal" or
                       subChild.Name == "Frost Bind" or
                       subChild.Name == "Star Rift (Red)" or
                       subChild.Name == "Star Rift (Blue)" or
                       subChild.Name == "Star Rift (Yellow)" or
                       subChild.Name == "Star Rift (Green)" then
                        local centerX, centerY = GetCenterPosition(subChild)
                        ClickAtPosition(centerX - 10, centerY + 30)
                        wait(0.5)
                        local sliderFrame = child:FindFirstChild("SliderFrame")
                        if sliderFrame then
                            local sliderButton = sliderFrame:FindFirstChild("SliderButton")
                            if sliderButton then
                                local sliderVisual = sliderButton:FindFirstChild("SliderVisual")
                                if sliderVisual then
                                    local ballFrame = sliderVisual:FindFirstChild("BallFrame")
                                    if ballFrame then
                                        local ballCenterX, ballCenterY = GetCenterPosition(ballFrame)
                                        local offsetX = 135
                                        local offsetY = 35
                                        ClickAtPosition(ballCenterX + offsetX, ballCenterY + offsetY)
                                    end
                                end
                            end
                        end
                        wait(0.5)
                        local optionsHolder = child:FindFirstChild("OptionsHolder")
                        if optionsHolder then
                            local optionsCenterX, optionsCenterY = GetCenterPosition(optionsHolder)
                            ClickAtPosition(optionsCenterX - 10, optionsCenterY + 30)
                        end
                        
                        foundMatchingChild = true
                        break 
                    end
                end
                
                if foundMatchingChild then
                    break 
                end
            end
        end
        
        attemptCount = attemptCount + 1
        wait(1) 
    end
    local LockButton = game:GetService("Players").LocalPlayer.PlayerGui.UI.TradeTransactionUI.Lock
    if LockButton then
        local X, Y = GetCenterPosition(LockButton)
        ClickAtPosition(X - 10, Y + 30)
    end
end

local isbought = false
local function CheckAndClickBuyButton()
    local playerBoothUI = player.PlayerGui.PAGES.PlayerBoothUI
    if playerBoothUI.Visible then
        local scrollingFrame = playerBoothUI.BoothUIScrollingFrame
        local children = scrollingFrame:GetChildren()

        for _, child in pairs(children) do
            if child:IsA("Frame") and child.Visible then
                local button = child.Button
                if button then
                    game:GetService("RunService").Heartbeat:Wait()
                    local centerX, centerY = GetCenterPosition(button)
                    ClickAtPosition(centerX - 20, centerY + 40)
                    wait(3)
                    local promptScreenGui = player.PlayerGui:FindFirstChild("PromptGui")
                    if promptScreenGui then
                        local promptDefault = promptScreenGui:FindFirstChild("PromptDefault")
                        if promptDefault then
                            local buyButton = promptDefault.Holder.Options:FindFirstChild("Buy")
                            if buyButton and buyButton.Name == "Buy" then
                                if not isbought then
                                    local X, Y = GetCenterPosition(buyButton)
                                    ClickAtPosition(X - 20, Y + 40)
                                    wait(5)
                                    game:GetService("ReplicatedStorage"):WaitForChild("TradeRemotes"):WaitForChild("SendTradeRequest"):InvokeServer(game:GetService("Players"):WaitForChild(characterName), false, true)
                                    wait(5)
                                    ClickUnitGridPrefabs()
                                    wait(1)
                                    ClickAddItemsAndFindRiskyDice()
                                    isbought = true
                                    break
                                end
                            end
                        end
                    end
                    return
                end
            end
        end
    end
end
local teleported = false
local function MoveCharacterToBooth()
    local folder = workspace.Folder
    for _, defaultModel in pairs(folder:GetChildren()) do
        if defaultModel:IsA("Model") and defaultModel.Name == "Default" then
            local rootFolder = defaultModel.Root
            local surfaceGui = rootFolder.SurfaceGui
            if surfaceGui then
                local contentText = surfaceGui.PlayerName.Text
                if contentText == characterName .. "'s Booth" then
                    local parentModel = surfaceGui.Parent
                    local parentCFrame = parentModel.CFrame
                    local newCFrame = parentCFrame:ToWorldSpace(CFrame.new(0, 0, -5))
                    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    if character then
                        if not teleported then
                            local currentCFrame = character:GetPrimaryPartCFrame()
                            if currentCFrame == newCFrame then
                                teleported = true
                            else
                                character:SetPrimaryPartCFrame(newCFrame)
                                print("Đã di chuyển nhân vật đến vị trí shop.")
                                wait(2)
                                SendKey(Enum.KeyCode.E)
                                teleported = true
                            end
                        end
                        return
                    else
                        warn("Không tìm thấy nhân vật.")
                    end
                end
            end
        end
    end
    wait(1)
end
local function teleportToTrading()
    local tradingLocation = workspace:FindFirstChild("Lobby") and
                            workspace.Lobby:FindFirstChild("TeleportLocations") and
                            workspace.Lobby.TeleportLocations:FindFirstChild("Trading")
    if tradingLocation then
        local targetCFrame = tradingLocation.CFrame
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        if character and character.PrimaryPart then
            character:SetPrimaryPartCFrame(targetCFrame)
            print("Đã di chuyển nhân vật đến vị trí Trading.")
            wait(1)
            SendKey(Enum.KeyCode.E)
            wait(1)
            local promptScreenGui = player.PlayerGui:FindFirstChild("PromptGui")
            if promptScreenGui then
                local promptDefault = promptScreenGui:FindFirstChild("PromptDefault")
                if promptDefault then
                    local joinfrButton = promptDefault.Holder.Options:FindFirstChild("Join Friend")
                    if joinfrButton and joinfrButton.Name == "Join Friend" then
                        local X, Y = GetCenterPosition(joinfrButton)
                        ClickAtPosition(X - 20, Y + 40)
                        wait(2)
                        local textBox = game:GetService("Players").LocalPlayer.PlayerGui.PromptGui.PromptDefault.Holder.Friend.TextBoxHolder.TextBox
                        textBox.Text = characterName
                        wait(0.5)
                        ClickAtPosition(X - 20, Y + 40)
                    end
                end
            end
        else
            warn("Không tìm thấy nhân vật hoặc PrimaryPart.")
        end
    else
        warn("Không tìm thấy vị trí Trading.")
    end
end
repeat
    wait(2)
    local moneyValue = checkMoneyValue()
until moneyValue ~= -1
spawn(function()
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
local moneyValue = checkMoneyValue()

if moneyValue == 0 then
    while true do
        teleportToTrading()
        wait(waitTime)
    end
else
    game:GetService("CoreGui").PlayerList.PlayerListMaster.Visible = false
    local soluongGem = game:GetService("Players").LocalPlayer.leaderstats["\240\159\146\142 Gems"].Value
    local textBox = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
    textBox.Text = "/w " .. characterName
    wait(1)
    textBox.Text = "DG" .. soluongGem
    local sendButton = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.SendButton
    local centerX, centerY = GetCenterPosition(sendButton)
    game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.SendButton.SendIcon.ImageTransparency = 0
    wait(1)
    ClickAtPosition(centerX - 10, centerY + 40)
    wait(5)
    game:GetService("CoreGui").ExperienceChat.appLayout.Visible = false
    spawn(function()
        while true do
            if not teleported then
                MoveCharacterToBooth()
            else
                break
            end
            wait(waitTime)
        end
    end)
    spawn(function()
        while true do
            if not isbought then
                CheckAndClickBuyButton()
            else
                break
            end
            wait(waitTime)
        end
    end)
    spawn(function()
        while true do
        ClickButtonBack()
        wait(waitTime)
    end
end)
end
