local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local promptGui = player.PlayerGui.PromptGui
local waitTime = 1
local characterName = getgenv().characterName
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
local function ClickAddItemsAndFindRiskyDice()
    local TradeTransactionUI = game.Players.LocalPlayer.PlayerGui.UI.TradeTransactionUI
    
    -- Click vào nút AddItemsButton
    local AddItemsButton = TradeTransactionUI.AddItemsButton
    local X, Y = GetCenterPosition(AddItemsButton)
                    ClickAtPosition(X - 20, Y + 40)
    
    -- Lấy PromptGui
    local PromptGui = game.Players.LocalPlayer.PlayerGui.PromptGui
    
    -- Lặp qua các child của PromptGui để tìm ScrollingFrame "Risky Dice"
    for _, child in ipairs(PromptGui:GetChildren()) do
        local scrollingFrame = child.ScrollingFrame
        if scrollingFrame and scrollingFrame.Name == "Risky Dice" then
            local X, Y = GetCenterPosition(scrollingFrame)
                    ClickAtPosition(X - 20, Y + 40)
            local count = child.FocusDisplay.InfoHolder.Count
            if count then
                local layoutOrder = count.LayoutOrder
                -- Lưu layoutOrder vào biến của bạn
                print("LayoutOrder của Count:", layoutOrder)
                -- Ví dụ: Lưu vào biến global hoặc local
                -- local myVariable = layoutOrder
            end
        end
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

local moneyValue = checkMoneyValue()

if moneyValue == 0 then
    teleportToTrading()
else
    game:GetService("CoreGui").PlayerList.PlayerListMaster.Visible = false
    local soluongGem = game:GetService("Players").LocalPlayer.leaderstats["\240\159\146\142 Gems"].Value
    local textBox = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
    textBox.Text = "/w " .. characterName
    wait(1)
    textBox.Text = "DG" .. soluongGem
    local sendButton = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.SendButton
    local centerX, centerY = GetCenterPosition(sendButton)
    ClickAtPosition(centerX - 20, centerY + 40)
    wait(1)
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
