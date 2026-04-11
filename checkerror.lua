local coreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local hasWrittenError = false 

local function UltimateKeyboardClick(btn)
    pcall(function()
        local GuiService = game:GetService("GuiService")
        local VIM = game:GetService("VirtualInputManager")
        GuiService.SelectedCoreObject = btn
        task.wait(0.1)
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        GuiService.SelectedCoreObject = nil
    end)
end

local function HandleErrorPrompt()
    local promptOverlay = coreGui:FindFirstChild("RobloxPromptGui")
    if promptOverlay then promptOverlay = promptOverlay:FindFirstChild("promptOverlay") end
    if not promptOverlay or not promptOverlay:FindFirstChild("ErrorPrompt") then return false end

    local errPrompt = promptOverlay.ErrorPrompt
    local fullText = ""
    local reconnectBtnObj = nil
    local leaveBtnObj = nil

    for _, desc in ipairs(errPrompt:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Visible and desc.Text then
            fullText = fullText .. " " .. desc.Text:lower()
        end

        if desc:IsA("GuiButton") and desc.Visible then
            if desc.Name:match("Reconnect") then
                reconnectBtnObj = desc
            end

            local hasText = pcall(function()
                return desc.Text
            end)

            if hasText and desc.Text and desc.Text:lower():match("leave") then
                leaveBtnObj = desc
            end
        end
    end

    local codeNum = fullText:match("error code: (%d+)")
    if not codeNum then
        local codeBracket = fullText:match("%(([^%)]+%d+)%)")
        if codeBracket then codeNum = codeBracket:match("(%d+)") end
    end

    local errorState = nil

    if fullText:match("ban ") or fullText:match("banned") or fullText:match("permanent") or codeNum == "273" or fullText:match("same account") then
        errorState = "banned"
    end

    if errorState then
        if not hasWrittenError then
            local player = Players.LocalPlayer
            if player then
                pcall(function()
                    writefile(string.format("%sError.json", player.Name), HttpService:JSONEncode({ State = errorState }))
                end)
                hasWrittenError = true 
            end
        end
        return true
    end

    if reconnectBtnObj then
        UltimateKeyboardClick(reconnectBtnObj)
        return true 
    end

    if leaveBtnObj then
        UltimateKeyboardClick(leaveBtnObj)
        return true
    end
    
    return false
end

task.spawn(function()
    while true do
        HandleErrorPrompt()
        task.wait(30)
    end
end)

task.spawn(function()
    pcall(function()
        local promptOverlay = coreGui:WaitForChild("RobloxPromptGui", 10):WaitForChild("promptOverlay", 10)
        if promptOverlay then
            promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    task.wait(1.5)
                    HandleErrorPrompt()
                end
            end)
        end
    end)
end)
