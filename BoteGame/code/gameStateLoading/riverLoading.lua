-- load this locally, to b removed later :D
local riverZones = love.filesystem.load("code/river/riverData/" .. riverName .. ".lua")()

local toLoad = {
    -- player skins
    {"image/player/default.png"},

    -- actual player code
    {"code/player/playerBoat.lua"},
    {"code/player/playerUi.lua"},


    {"code/river/river.lua"},
    {"code/river/generator/riverGenerator.lua"},
    {"code/river/generator/riverCanvas.lua"},
    {"code/river/generator/obstacleSpawner.lua"},

    {"code/camera.lua"},
    {"code/inputManager.lua"},
    {"code/menu/keybinds.lua"},

    {"obstacle/obstacle.lua", "run"},


    {"image/ui/needle.png", "blur"},
    {"image/ui/speedometer.png", "blur"},
    {"image/ui/speedometerFront.png", "blur"},
    {"image/ui/currentBar.png", "blur"},



}

for i = 1,#riverZones do
    -- add a falg to tell the code to add the obsticals to the loaded list later :/
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/obsticals.lua", "addObstacles"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/pathGeneration.lua"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/backgroundGeneration.lua", "run", "GetColourAt"})

end

-- load this file in a more permenant position.
table.insert(toLoad, {"code/river/riverData/" .. riverName .. ".lua"})

return toLoad