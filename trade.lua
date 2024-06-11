local VirtualInputManager = game:GetService("VirtualInputManager")
local function SendKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(0.2)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

while true do
    local folder = workspace.Folder
    local characterName = "Lucky7777"  -- Tên nhân vật bạn muốn tìm kiếm

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
                        return  -- Kết thúc vòng lặp khi tìm ra tên nhân vật
                    else
                        warn("Không tìm thấy nhân vật.")
                    end
                end
            end
        end
    end
    wait(1)  -- Đợi 1 giây trước khi lặp lại
end
