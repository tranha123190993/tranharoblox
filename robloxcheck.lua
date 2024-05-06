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
            [1] = "",
            [2] = ""
        }
    }
_G.Fruits_Settings = {  
    ['Main_Fruits'] = {""},
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
    ['TrueTripleKatana'] = false,
    ['CursedDualKatana'] = true
}
_G.GunSettings = {  
    ['Kabucha'] = true,
    ['SerpentBow'] = true,
    ['SoulGuitar'] = true
}
_G.FixBugLDArce = true
_G.SharkAnchor_Settings = {
    ["Enabled_Farm"] = true
}
getgenv().Key = "MARU-NC03-TVRRW-7ZFM-KBVH8-WRHR"
getgenv().id = "513996919622860832"
getgenv().Script_Mode = "Kaitun_Script"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chimnguu/ngu/master/bululachip.lua"))()
end)
