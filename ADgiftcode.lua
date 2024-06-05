local codes = {
    "MEMBEREREBREWRERES",
    "sorry4delay",
    "raidsarecool",
    "thanks400k",
    "dayum100m",
    "wsindach4ht",
    "200kholymoly",
    "adontop",
    "subcool",
    "sub2toadboigaming",
    "sub2mozking",
    "sub2karizmaqt",
    "sub2jonaslyz",
    "sub2riktime",
    "sub2nagblox",
    "release2024"
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = replicatedStorage:WaitForChild("Remotes")
local useCodeRemote = remotesFolder:WaitForChild("UseCode")

for _, code in ipairs(codes) do
    spawn(function()
        local success, result = pcall(function()
            return useCodeRemote:InvokeServer(code)
        end)
        if success then
            print("Successfully redeemed code:", code, "Result:", result)
        else
            warn("Error while redeeming code:", code, result)
        end
    end)
end
