spawn(function()
    repeat wait(.25)
until game:IsLoaded()

local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
repeat wait() until plr.Character:FindFirstChild("HumanoidRootPart")
repeat wait() until plr.Character:FindFirstChild("Humanoid")
repeat wait() until workspace:FindFirstChild("__THINGS")

local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)
local PlayerData = SaveModule:GetSaves()[plr]

local getTotalUnlockedMap = function()
    local totalUnlockedMapTable = {}
    for i,v in next, SaveModule.GetSaves()[plr].UnlockedZones do 
        if v then 
            table.insert(totalUnlockedMapTable,i)
        end
    end
    return #totalUnlockedMapTable
end

-- ! End Func

-- * Called Function
while true do 
    --'Level','Beli','Fragments','DevilFruit','Race'
    data = {}
    data['Basic Data'] = {}
    data['Basic Data']['Level'] = 1
    data['Basic Data']['Beli'] = getTotalUnlockedMap()
    data['Basic Data']['Fragments'] = 1
    data['Basic Data']['DevilFruit'] = 1
    data['Basic Data']['Race'] = "None"
    data['Basic Data']['Bounty/Honor'] = 0
    data['Basic Data']['Fighting Style'] = "Godhuman"

    data['Items Inventory'] = {""None""}
    data['Fruits Inventory'] = {""None""}


    -- ? Write file

    local a,b = pcall(function()
        writefile(string.format("%sData.json",game:GetService("Players").LocalPlayer.Name),game:GetService("HttpService"):JSONEncode(data))
    end)

    if a then
        print(string.format("The file with name %sData.json has been writed",game:GetService("Players").LocalPlayer.Name))
    else
        warn("got error:",b)
    end


    wait(30)
end
    local oldDiamond = game.Players.LocalPlayer.leaderstats["\240\159\146\142 Diamonds"].Value
    local oldUTC = os.time(os.date("!*t"))
    while wait(10) do 
          if os.time(os.date("!*t")) - oldUTC >= 300 then
             if game.Players.LocalPlayer.leaderstats["\240\159\146\142 Diamonds"].Value - oldDiamond == 0 then
                 game:Shutdown()
             end
          end
     end
  end)
getgenv().ScriptSettings=[[{"FarmCoin":false,"AutoDigsite":true,"ClaimRankReward":true,"CauCa":false,"TapPerTime":3,"DigsiteLevel":3,"AutoMerchant":false,"Atlantis":false,"DigsiteHopp":true,"MerchantTF":{"RegularMerchant":false,"GardenMerchant":false,"AdvancedMerchant":false},"SpawnObby":false,"AutoBuyPetSlot":false,"AutoClaimMail":false,"AutoClaimFreeReward":false,"IgnoreUpgrade":{"Magnet":false,"Drops":false,"LessGold":false,"Pet Speed":false,"Pet Damage":false,"LessRainbow":false,"Luck":false,"Walkspeed":false,"Coins":false,"Diamonds":false,"Tap Damage":false},"TNTRebirth":false,"TapTime":1,"AutoTap":false,"OpenGiftBag":false,"ListSendMail":[{"Enabled":true,"Item":"Diamonds","Category":"Currency","MinItem":5000000,"Username":"tamtoan3"},{"Enabled":true,"Item":"Bucket","Category":"Misc","MinItem":2000,"Username":"tamtoan3"},{"Enabled":true,"Item":"Bucket O' Magic","Category":"Misc","MinItem":200,"Username":"tamtoan3"},{"Username":"","MinItem":1,"Enabled":false,"Category":"Misc"}],"HiddenPresent":true,"AutoBuyUpdrage":false,"FarmingMode":"All","SelectBest":false,"DigsiteZone":"Advanced Digsite","Minefield":false,"MaxMap":99,"AutoRebirth":false,"AutoOpenMap":false,"RebirthTime":1}]]
UserSettings():GetService('UserGameSettings').MasterVolume = 0;
settings().Rendering.QualityLevel = 1;
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,false)
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)
game:GetService("Lighting").GlobalShadows = false
for key, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Part") or object:IsA("UnionOperation") or object:IsA("MeshPart") then
        object.Material = Enum.Material.SmoothPlastic
    elseif  (object:IsA("Texture") or object:IsA("Explosion") or object:IsA("ColorCorrectionEffect") or 
                object:IsA("Atmosphere") or object:IsA("SunRaysEffect") or object:IsA("BlurEffect") or 
                object:IsA("RainyStone") or object:IsA("Weather")  or object:IsA("BloomEffect")
                or object:IsA("Lighting") or object:IsA("FogEnd") or object:IsA("DepthOfFieldEffect")) then
        object:Destroy()
    end
end
loadstring(game:HttpGet("https://cdn.chimovo.com/private/nuoi-thu-cung/sechpet"))()
