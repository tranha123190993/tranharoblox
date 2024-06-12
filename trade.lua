local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local promptGui = player.PlayerGui.PromptGui
local waitTime = 0.5
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
    local centerX, centerY = x + absSize.X / 2 - 20, y + absSize.Y / 2 + 20
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
                    ClickAtPosition(centerX, centerY)
                    wait(3)
                    local promptScreenGui = player.PlayerGui:FindFirstChild("PromptGui")
                    if promptScreenGui then
                        local promptDefault = promptScreenGui:FindFirstChild("PromptDefault")
                        if promptDefault then
                            local buyButton = promptDefault.Holder.Options:FindFirstChild("Buy")
                            if buyButton and buyButton.Name == "Buy" then
                                if not isbought then
                                    local X, Y = GetCenterPosition(buyButton)
                                    ClickAtPosition(X, Y)
                                    wait(5)
                                    game:GetService("ReplicatedStorage"):WaitForChild("TradeRemotes"):WaitForChild("SendTradeRequest"):InvokeServer(game:GetService("Players"):WaitForChild(characterName), false, true)
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
                        ClickAtPosition(X, Y)
                        wait(2)
                        local textBox = game:GetService("Players").LocalPlayer.PlayerGui.PromptGui.PromptDefault.Holder.Friend.TextBoxHolder.TextBox
                        textBox.Text = characterName
                        wait(0.5)
                        ClickAtPosition(X, Y)
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
    game:GetService("CoreGui").ExperienceChat.appLayout.Visible = false
    game:GetService("CoreGui").PlayerList.PlayerListMaster.Visible = false
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
end
