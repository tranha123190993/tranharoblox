local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getInventoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetInventory")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local promptGui = player.PlayerGui.PromptGui
local VirtualInputManager = game:GetService("VirtualInputManager")
local accClone = ""
local soluongGem = ""
local gameID = 17017769292
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
-- Hàm để click vào vị trí xác định
local function ClickAtPosition(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end
local function SendKey(key, delay)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(delay)
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
-- Hàm để lấy vị trí trung tâm của một GUI Element
local function GetCenterPosition(guiElement)
    local absPos = guiElement.AbsolutePosition
    local absSize = guiElement.AbsoluteSize
    local centerX = absPos.X + absSize.X / 2
    local centerY = absPos.Y + absSize.Y / 2
    return centerX, centerY
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
local function ClickFirstItemButtonAndConfirm()
    local PromptGui = game.Players.LocalPlayer.PlayerGui.PromptGui
    local foundMatchingChild = false

    for _, child in ipairs(PromptGui:GetChildren()) do
        local scrollingFrame = child:FindFirstChild("ScrollingFrame")
        if scrollingFrame then
            for _, subChild in ipairs(scrollingFrame:GetChildren()) do
                if subChild.Name == "UnitGridPrefab" and subChild.LayoutOrder == 1 then
                    local centerX, centerY = GetCenterPosition(subChild)
                    ClickAtPosition(centerX - 10, centerY + 30)
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
	wait(2)
    local promptScreenGui = player.PlayerGui:FindFirstChild("PromptGui")
    if promptScreenGui then
        local promptDefault = promptScreenGui:FindFirstChild("PromptDefault")
        if promptDefault then
	    game:GetService("Players").LocalPlayer.PlayerGui.PromptGui.PromptDefault.Holder.SellTextBox.TextBoxHolder.TextBox.Text = soluongGem
            local backButton = promptDefault.Holder.Options:FindFirstChild("Sell")
            if backButton and backButton.Name == "Sell" then
                local X, Y = GetCenterPosition(backButton)
                    ClickAtPosition(X - 10, Y + 35)
                    print("Đã click vào nút Sell")
            end
        end
    end
end

local function MoveCharacterToFakeBooth()
    local fxFolder = workspace.FX
    local fxModels = fxFolder:GetChildren()
    local fakeBoothModel = nil
    for _, model in ipairs(fxModels) do
        if model.Name == "FakeBooth" then
            fakeBoothModel = model
            break
        end
    end
    local rootPart = fakeBoothModel:FindFirstChild("Root")
    if not rootPart or not rootPart:IsA("BasePart") then
        print("Không tìm thấy phần Root hợp lệ trong model FakeBooth")
        return
    end
    
    local targetCFrame = rootPart.CFrame
    
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    character:SetPrimaryPartCFrame(targetCFrame)
    wait(1)
    SendKey(Enum.KeyCode.E, 2)
    wait(1)
    SendKey(Enum.KeyCode.E, 0.2)
    wait(1)
    local button = game:GetService("Players").LocalPlayer.PlayerGui.PAGES.PlayerBoothUI.AddButtons.AddUnitsButton
    if button then
    local X, Y = GetCenterPosition(button)
            ClickAtPosition(X - 10, Y + 30)
    wait(0.5)
    ClickFirstItemButtonAndConfirm()
else
    print("Không tìm thấy button trong PlayerBoothUI.BottomHolder.ModeHolder.ResponseHolder")
end
end
local function CheckAndClickLockButton()
    local TradeTransactionUI = game.Players.LocalPlayer.PlayerGui.UI.TradeTransactionUI
    local ReceiveContents = TradeTransactionUI.ReceiveContents
    
    if ReceiveContents.Locked.Enabled then
        local LockButton = TradeTransactionUI.Lock
        if LockButton then
            local X, Y = GetCenterPosition(LockButton)
            ClickAtPosition(X - 10, Y + 30)
            return true
        end
    end
    return false 
end
-- nhận tin nhắn tên clone và lưu số lượng gem ra
local function CheckAndPrintSender()
    local RCTScrollContentView = game:GetService("CoreGui").ExperienceChat.appLayout.chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView.RCTScrollContentView
    for i = #RCTScrollContentView:GetChildren(), 1, -1 do
        local child = RCTScrollContentView:GetChildren()[i]
        if child:IsA("Frame") and child.TextLabel and child.TextLabel.TextMessage then
            local messageText = child.TextLabel.TextMessage.Text
            local sender, message = messageText:match("%[From (.-)%].-</font>%s*..(.+)")
            if sender and message and sender ~= "" and message ~= "" then
                accClone = sender
                soluongGem = message
                MoveCharacterToFakeBooth()
                child.TextLabel.TextMessage.Text = ""
                break
            end
        end
    end
end
-- Hàm kiểm tra và click vào nút ResponseYes nếu có thông báo
local function CheckAndClickResponseYes()
    local notificationsHolder = player.PlayerGui:FindFirstChild("UI"):FindFirstChild("NotificationsHolder")
    if notificationsHolder then
        for _, notification in pairs(notificationsHolder:GetChildren()) do
            if notification:IsA("Frame") and notification:FindFirstChild("PromptWindow") then
                local promptWindow = notification.PromptWindow
                if promptWindow:FindFirstChild("Responses") and promptWindow.Responses:FindFirstChild("ResponseYes") then
                  local checkSender = PromptWindow.PromptMessage.Text:match("^([%a%d_]+)%s+wants")
                    if not isYes and accClone ~= "" and checkSender ~= accClone then
                        local responseYesButton = promptWindow.Responses.ResponseYes
                        local centerX, centerY = GetCenterPosition(responseYesButton)
                        ClickAtPosition(centerX - 20, centerY + 40)
                        print("Đã click vào nút ResponseYes")
			accClone = ""
                        return
                    end
                end
            end
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
                    print("Đã click vào nút Back")
            end
        end
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
    game:GetService("TeleportService"):Teleport(17490500437)
else
    game:GetService("CoreGui").ExperienceChat.appLayout.Visible = false
    game:GetService("CoreGui").PlayerList.PlayerListMaster.Visible = false
    spawn(function()
  while true do
      CheckAndPrintSender()
      wait(3)
  end
end)
spawn(function()
  while true do
    CheckAndClickResponseYes()
    wait(1)
  end
end)
spawn(function()
  while true do
    ClickButtonBack()
    wait(1)
  end
end)
end
spawn(function()
    while true do
        CheckAndClickLockButton()
        wait(2) 
    end
end)
