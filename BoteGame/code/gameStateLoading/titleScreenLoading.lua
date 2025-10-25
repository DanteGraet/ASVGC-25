local toLoad = {

    --Scripts/Code
    {"code/titleScreen/titleScreenButtons.lua"},

    --settings menu stuff is also here :D
    {"code/menu/settingsMenu.lua"},


    {"image/titleScreen/title.png", "blur"},

    -- load the save
    {"code/player/playerLoadSaveData.lua", "run"},

    -- generation suff
    {"code/river/river.lua"},
    {"code/river/generator/riverGenerator.lua"},
    {"code/river/generator/obstacleSpawner.lua"},

    {"obstacle/obstacle.lua", "run"},


    -- in a function so we don't unload it
    function()

        if not assets.save then assets.save = {} end
        if love.filesystem.getInfo("save/highscore.lua") then
            assets.save.highscore = love.filesystem.load("save/highscore.lua")()
        else
            assets.save.highscore = {}
            dialouge.schedule("image/levelSelect/dialouge/dialouge1.png", 10)
        end

        if not assets.audio then assets.audio = {} end
        if not assets.audio.ui then assets.audio.ui = {} end
        assets.audio.ui.click = love.audio.newSource("audio/ui/click.ogg", "static")
    end,

    function()
        love.resize()
    end

}

table.insert(toLoad, function()
    riverName = "titleScreenRiver"
end)

local rn = "titleScreenRiver"

local riverZones = love.filesystem.load("code/river/riverData/" .. rn .. "/zone.lua")()
-- load this file in a more permenant position.
table.insert(toLoad, {"code/river/riverData/" .. rn .. "/zone.lua"})
table.insert(toLoad, {"code/river/riverData/" .. rn .. "/music.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. rn .. "/ambiance.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. rn .. "/obstacle.lua", "run"})

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
    riverFileDirectory = assets.code.river.riverData[rn]
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks( beginContact, endContact, preSolve, postSolve )
    --camera = assets.code.camera():New(0, 0, 960, 900)
    love.resize()

    --ambiance = love.filesystem.load("code/river/effects/ambient.lua")()
    riverGenerator = {}
    river = {}

    
    river = assets.code.river.river():New()

    print("generator river")

    riverGenerator = assets.code.river.generator.riverGenerator():New(rn)

    print("generator finishedLoading")

end)

table.insert(toLoad, function()

    obstacles = {}
    local zoneObsitcalList = {}
    local riverZones = riverFileDirectory.zone()
    for key, z in pairs(riverZones) do
        zoneObsitcalList[z.zone] = assets.code.river.zone[z.zone].obsticals()
    end
    obstacleSpawner = assets.code.river.generator.obstacleSpawner():New(zoneObsitcalList, 1000)

    zones = riverGenerator:GetZone(0, true)
    obstacleSpawner:Update()

    world:update(0)

    --music.load()

    -- remove colliding rocks
    local contacts = world:getContacts()
    for _, contact in ipairs(contacts) do
        if contact:isTouching() then
            local fixtureA, fixtureB = contact:getFixtures()  -- Get the two fixtures involved
            local dataA = fixtureA:getUserData()
            local dataB = fixtureB:getUserData()
            if dataA.first then
                dataA.remove = true
                fixtureA:setUserData(dataA)
            elseif dataB.first then
                dataB.remove = true
                fixtureB:setUserData(dataB)
            else
                -- remove B by deefault, one of them has to go
                dataB.first = false
                dataB.remove = true
                fixtureB:setUserData(dataB)
            end    
        end
    end

    for i = #obstacles,1, -1 do
        obstacles[i]:Update(i, 0)
    end

    particles.loadParticles()

    music.load(love.filesystem.load("code/river/riverData/titleScreenRiver/music.lua")())


end)


return toLoad