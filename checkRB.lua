spawn(function()
local RunService = game:GetService("RunService")
RunService:Set3dRenderingEnabled(false)
setfpscap(30)
getgenv().Key = "MARU-0AJ31-SYEEG-WD28-AQ1ET-509B"
getgenv().id = "513996919622860832"
getgenv().Script_Mode = "Kaitun_Script"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
end)
spawn(function()
    wait(50)
    if not game.CoreGui:FindFirstChild('NINONOOB') then
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end)
spawn(function()
        repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/cangyeunhaudau/ditmemaychominhtriet/main/mankefarm.lua"))()
        end)
spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chimnguu/ngu/master/bululachip.lua"))()
end)
