if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end

_G.Delay_Upload = 300
_G.Bypass_Tp = true

_G.Select_Fruit = {
    ['Main'] = {'Dough-Dough'},
    ['Select Fruit'] = {'Dark-Dark','Human-Human: Buddha','Sand-Sand','Magma-Magma'}
}
_G.Mastery_Farm = {
    ['Melee'] = true,
    ['Devil Fruit'] = true,
    ['Sword'] = true,
    ['Gun'] = true,
}
_G.Race_Evo = {
    ['Level'] = {1,2,3},
    ['Enabled'] = true
}
script_key="UPUXjqSkewmtoHSQzjwManHoPDEaPuAe";
loadstring(game:HttpGet("https://raw.githubusercontent.com/londnee/code/main/m.lua"))()
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chimnguu/ngu/master/bululachip.lua"))()
end)
