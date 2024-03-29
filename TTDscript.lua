getgenv().Key = "k22daee5b4ee65e007acf49a"
loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()
local player = game.Players.LocalPlayer
function checkMoneyValue()
    if player and player.leaderstats and player.leaderstats:FindFirstChild("Money") then
        return 1
    else
        return 0
    end
end

setfpscap(15)
spawn(function()
    while true do 
        local data = {}
        data['Basic Data'] = {}
        data['Basic Data']['Level'] = 2550
        data['Basic Data']['Beli'] = checkMoneyValue()
        data['Basic Data']['Fragments'] = 1
        data['Basic Data']['DevilFruit'] = 0
        data['Basic Data']['Race'] = "TTD"
        data['Basic Data']['Fighting Style'] = "TTD"

        data['Items Inventory'] = {""}
        data['Fruits Inventory'] = {""}

        -- Write file
        local a,b = pcall(function()
            writefile(string.format("%sData.json", player.Name), game:GetService("HttpService"):JSONEncode(data))
        end)

        if a then
            print(string.format("The file with name %sData.json has been written", player.Name))
        else
            warn("got error:",b)
        end

        wait(35)
    end
end)
