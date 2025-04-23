local toLoad = {
    --Images
    {"image/titleScreen/parallax/1.png"},
    {"image/titleScreen/parallax/2.png"},
    {"image/titleScreen/parallax/3.png"},
    {"image/titleScreen/parallax/4.png"},
    {"image/titleScreen/parallax/5.png"},
    {"image/titleScreen/parallax/6.png"},
    {"image/titleScreen/parallax/7.png"},

    --Scripts/Code
    {"code/titleScreen/titleScreenButtons.lua"},

    --settings menu stuff is also here :D




    {"code/menu/settingsMenu.lua"},

    --{"font/fontBlack.ttf",24},
    --{"font/fontBlack.ttf",32},
    --{"font/fontBlack.ttf",64},

    {"image/titleScreen/title.png", "blur"},

    -- load the save
    {"code/player/playerLoadSaveData.lua", "run"},



    -- generation suff
    {"code/river/river.lua"},
    {"code/river/generator/riverGenerator.lua"},
    {"code/river/generator/obstacleSpawner.lua"},


    {"obstacle/obstacle.lua", "run"},




    function()
        love.resize()
    end

}

riverName = "titleScreenRiver"

local riverZones = love.filesystem.load("code/river/riverData/" .. riverName .. "/zone.lua")()
-- load this file in a more permenant position.
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/zone.lua"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/music.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/ambiance.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/obstacle.lua", "run"})

for i , value in pairs(riverZones) do
    -- add a falg to tell the code to add the obsticals to the loaded list later :/
    local file = love.filesystem.load("code/river/zone/" .. riverZones[i].zone .. "/obsticals.lua")()
    for i = 1,#file do
        for name, _ in pairs(file[i].data) do
            table.insert(toLoad, {"obstacle/" .. name .. ".lua", "run"})
        end
    end
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/obsticals.lua"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/pathGeneration.lua"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/backgroundGeneration.lua", "run", "GetColourAt"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/backgroundGeneration.lua", "run", "GetColourAt"})
end

table.insert(toLoad, function()
    if not assets.image.ui then assets.image.ui = {} end
    if not assets.image.ui then assets.image.ui = {} end
    if not assets.image.ui.settings then assets.image.ui.settings = {} end
    assets.image.ui.settings.bar = love.graphics.newImage("image/ui/settings/bar.png")
    assets.image.ui.settings.indicator = love.graphics.newImage("image/ui/settings/indicator.png")
    assets.image.ui.settings.check = love.graphics.newImage("image/ui/settings/check.png")
    assets.image.ui.settings.empty = love.graphics.newImage("image/ui/settings/empty.png")
end)

table.insert(toLoad, function()
    riverFileDirectory = assets.code.river.riverData[riverName]
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks( beginContact, endContact, preSolve, postSolve )
    --camera = assets.code.camera():New(0, 0, 960, 900)
    love.resize()

    ambiance = love.filesystem.load("code/river/effects/ambient.lua")()

    river = assets.code.river.river():New()
    riverGenerator = assets.code.river.generator.riverGenerator():New(riverName)

    obstacles = {}
    local zoneObsitcalList = {}
    local riverZones = riverFileDirectory.zone()
    for key, z in pairs(riverZones) do
        zoneObsitcalList[z.zone] = assets.code.river.zone[z.zone].obsticals()
    end
    obstacleSpawner = assets.code.river.generator.obstacleSpawner():New(zoneObsitcalList)

    music.load()

    particles.loadParticles()
end)


return toLoad