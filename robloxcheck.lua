task.spawn(function()
_G.Team = "Pirate"
_G.KAITUN_SCRIPT = true
_G.LogsDes = {
    ["Enabled"] = false, 
    ["SendAlias"] = false, 
    ["SendDescription"] = false,  
    ["DelaySend"] = 5  
}
_G.WebHook = {
    ["Enabled"] = false,  
    ["Url"] = "",  
    ["Delay"] = 60  
}
_G.MainSettings = {
        ["EnabledHOP"] = true,  
        ['FPSBOOST'] = true,  
        ["FPSLOCKAMOUNT"] = 60, 
        ['WhiteScreen'] = true,  
        ['CloseUI'] = true,
        ["NotifycationExPRemove"] = true,  
        ['AFKCheck'] = 150, 
        ["LockFragments"] = 200000000,  
        ["LockFruitsRaid"] = { 
        }
    }
_G.Fruits_Settings = {  
    ['Main_Fruits'] = {Flame-Flame", "Ice-Ice", "Quake-Quake", "Light-Light", "Dark-Dark", "Spider-Spider", "Rumble-Rumble", "Magma-Magma", "Buddha-Buddha"},
    ['Select_Fruits'] = {"Flame-Flame", "Ice-Ice", "Quake-Quake", "Light-Light", "Dark-Dark", "Spider-Spider", "Rumble-Rumble", "Magma-Magma", "Buddha-Buddha"} 
}
_G.Quests_Settings = {  
    ['Rainbow_Haki'] = true,
    ["MusketeerHat"] = false,
    ["PullLever"] = false,
    ['DoughQuests_Mirror'] = {
        ['Enabled'] = true,
        ['UseFruits'] = true
    }        
}
_G.Races_Settings = {  
    ['Race'] = {
        ['EnabledEvo'] = true,
        ["v2"] = true,
        ["v3"] = true,
        ["Races_Lock"] = {
            ["Races"] = { 
                ["Mink"] = true,
                ["Human"] = true,
                ["Fishman"] = true
            },
            ["RerollsWhenFragments"] = 20000 
        }
    }
}
_G.Settings_Melee = {  
    ['Superhuman'] = true,
    ['DeathStep'] = true,
    ['SharkmanKarate'] = true,
    ['ElectricClaw'] = true,
    ['DragonTalon'] = true,
    ['Godhuman'] = true
}
_G.FarmMastery_Settings = {
    ['Melee'] = true,
    ['Sword'] = true,
    ['DevilFruits'] = true,
    ['Select_Swords'] = {
        ["AutoSettings"] = true,  
        ["ManualSettings"] = {  
            "Saber",
            "Buddy Sword"
        }
    }
}
_G.SwordSettings = { 
    ['Saber'] = false,
    ["Pole"] = false,
    ['MidnightBlade'] = false,
    ['Shisui'] = false,
    ['Saddi'] = false,
    ['Wando'] = false,
    ['Yama'] = true,
    ['Rengoku'] = false,
    ['Canvander'] = false,
    ['BuddySword'] = false,
    ['TwinHooks'] = false,
    ['HallowScryte'] = false,
    ['TrueTripleKatana'] = true,
    ['CursedDualKatana'] = true
}
_G.GunSettings = {  
    ['Kabucha'] = true,
    ['SerpentBow'] = true,
    ['SoulGuitar'] = true
}
getgenv().Key = "MARU-0AJ31-SYEEG-WD28-AQ1ET-509B"
getgenv().id = "513996919622860832"
getgenv().Script_Mode = "Kaitun_Script"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
        end)
task.spawn(function()
        -- Variable to enable frame rate optimization features
FrameRateBoost = true

-- Function to lower texture quality and modify properties for performance optimization
function TextureLow()
    if not game:IsLoaded() then repeat wait() until game:IsLoaded() end
    if hookfunction and setreadonly then
        local mt = getrawmetatable(game)
        local old = mt.__newindex
        setreadonly(mt, false)
        local sda
        sda = hookfunction(old, function(t, k, v)
            -- Modify material properties for performance
            if k == "Material" then
                if v ~= Enum.Material.Neon and v ~= Enum.Material.Plastic and v ~= Enum.Material.ForceField then v = Enum.Material.Plastic end
            elseif k == "TopSurface" then v = "Smooth"
            elseif k == "Reflectance" or k == "WaterWaveSize" or k == "WaterWaveSpeed" or k == "WaterReflectance" then v = 0
            elseif k == "WaterTransparency" then v = 1
            elseif k == "GlobalShadows" then v = false end
            return sda(t, k, v)
        end)
        setreadonly(mt, true)
    end

    -- Apply changes to the existing environment
    local g = game
    local w = g.Workspace
    local l = g:GetService"Lighting"
    local t = w:WaitForChild"Terrain"
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 1
    l.GlobalShadows = false

    -- Function to change object properties
    function change(v)
        pcall(function()
            if v.Material ~= Enum.Material.Neon and v.Material ~= Enum.Material.Plastic and v.Material ~= Enum.Material.ForceField then
                pcall(function() v.Reflectance = 0 end)
                pcall(function() v.Material = Enum.Material.Plastic end)
                pcall(function() v.TopSurface = "Smooth" end)
            end
        end)
    end

    -- Apply changes to new objects added to the game
    game.DescendantAdded:Connect(function(v)
        pcall(function()
            if v:IsA"Part" then change(v)
            elseif v:IsA"MeshPart" then change(v)
            elseif v:IsA"TrussPart" then change(v)
            elseif v:IsA"UnionOperation" then change(v)
            elseif v:IsA"CornerWedgePart" then change(v)
            elseif v:IsA"WedgePart" then change(v) end
        end)
    end)

    -- Apply changes to all existing descendants
    for i, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA"Part" then change(v)
            elseif v:IsA"MeshPart" then change(v)
            elseif v:IsA"TrussPart" then change(v)
            elseif v:IsA"UnionOperation" then change(v)
            elseif v:IsA"CornerWedgePart" then change(v)
            elseif v:IsA"WedgePart" then change(v) end
        end)
    end
end

-- Function to remove water objects from the workspace
function WaterRemove()
    for i,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name,"Water") then
            v:Destroy()
        end
    end
end

-- Function to remove specific objects like trees and houses
function ObjectRemove()
    for i,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name,"Tree") or string.find(v.Name,"House") then
            v:Destroy()
        end
    end
end

-- Function to make non-essential objects invisible
function InvisibleObject()
    for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if (v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart")) and v.Transparency then
            v.Transparency = 1
        end
    end
end

-- Main block that executes the optimizations if EzFrameRate is true
if FrameRateBoost then
    game.Players.LocalPlayer.PlayerScripts.WaterCFrame.Disabled = true
    game:GetService("Lighting"):ClearAllChildren()
    TextureLow()
    WaterRemove()
    ObjectRemove()
    InvisibleObject()
end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chimnguu/ngu/master/bululachip.lua"))()
end)
