spawn(function()
local RunService = game:GetService("RunService")
RunService:Set3dRenderingEnabled(false)
setfpscap(15)
getgenv().Key = "MARU-0AJ31-SYEEG-WD28-AQ1ET-509B"
getgenv().id = "513996919622860832"
getgenv().Script_Mode = "Kaitun_Script"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
end)
spawn(function()
    getgenv().UserKey= "B601F0604AE6290B76DDC3EADBB02760"
loadstring(game:HttpGet('https://api.chimovo.com/v1/hanei/script'))()
end)
