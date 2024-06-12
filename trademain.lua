local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local accClone = ""
local soluongGem = ""
-- Hàm để click vào vị trí xác định
local function ClickAtPosition(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
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


-- nhận tin nhắn tên clone và lưu số lượng gem ra
local function CheckAndPrintSender()
    local RCTScrollContentView = game:GetService("CoreGui").ExperienceChat.appLayout.chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView.RCTScrollContentView
    for i = #RCTScrollContentView:GetChildren(), 1, -1 do
        local child = RCTScrollContentView:GetChildren()[i]
        if child:IsA("Frame") and child.TextLabel and child.TextLabel.TextMessage then
            local messageText = child.TextLabel.TextMessage.Text
            local sender, message = messageText:match("%[From (.-)%].-</font>  a(.+)")
            if sender and message and sender ~= "" and message ~= "" then
                accClone = sender
                soluongGem = message
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
