spawn(function()
getgenv().Key = "MARU-NC03-TVRRW-7ZFM-KBVH8-WRHR"
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
