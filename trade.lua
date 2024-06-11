local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local playerBoothUI = player.PlayerGui.PAGES.PlayerBoothUI
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
    local centerX, centerY = x + absSize.X / 2 - 20, y + absSize.Y / 2
    return centerX, centerY
end

local function SendKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(0.2)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function CheckAndClickBuyButton()
    if playerBoothUI.Visible then
        local scrollingFrame = playerBoothUI.BoothUIScrollingFrame
        local children = scrollingFrame:GetChildren()

        for _, child in pairs(children) do
            if child:IsA("Frame") then
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
                            if buyButton then
                                local X, Y = GetCenterPosition(buyButton)
                                ClickAtPosition(X, Y)
                                wait(5)
                                game:GetService("ReplicatedStorage"):WaitForChild("TradeRemotes"):WaitForChild("SendTradeRequest"):InvokeServer(game:GetService("Players"):WaitForChild(characterName), false, true)
                                break
                            end
                        end
                    end
                    return
                end
            end
        end
    end
end

local function MoveCharacterToBooth()
    local folder = workspace.Folder
    local characterName = characterName

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
                        character:SetPrimaryPartCFrame(newCFrame)
                        print("Đã di chuyển nhân vật đến vị trí mới của thư mục cha.")
                        wait(2)
                        SendKey(Enum.KeyCode.E)
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

spawn(function()
    while true do
        MoveCharacterToBooth()
        wait(waitTime)
    end
end)

spawn(function()
    while true do
        CheckAndClickBuyButton()
        wait(waitTime)
    end
end)
