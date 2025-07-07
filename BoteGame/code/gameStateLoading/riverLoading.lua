-- load this locally, to b removed later :D
local riverZones = love.filesystem.load("code/river/riverData/" .. riverName .. "/zone.lua")()

local toLoad = {
    -- player skins
    {"image/player/default.png"},

    -- actual player code
    {"code/player/playerBoat.lua"},
    {"code/player/playerUi.lua"},




    -- generation suff
    {"code/river/river.lua"},
    {"code/river/generator/riverGenerator.lua"},
    {"code/river/generator/obstacleSpawner.lua"},

    {"code/camera.lua"},
    {"code/inputManager.lua"},
    {"code/menu/keybinds.lua"},
    {"code/menu/pauseMenu.lua", "run"},
    {"code/menu/gameOverMenu.lua", "run"},


    -- add this obstacle here, all others need it to be already loaded
    {"obstacle/obstacle.lua", "run"},

    -- images
    {"image/ui/viginette.png", "blur"},
    {"image/ui/needle.png", "blur"},
    {"image/ui/speedometer.png", "blur"},
    {"image/ui/speedometerFront.png", "blur"},
    {"image/ui/speedometerFrontDamage.png", "blur"},
    {"image/ui/speedometerFrontVeryDamage.png", "blur"},
    {"image/ui/currentBar.png", "blur"},
    {"image/ui/current.png", "blur"},
    {"image/ui/ouchGlow.png", "blur"},

    {"code/player/playerData.lua", "run"},

    -- audio
    {"audio/player/Motor-Motor.mp3", "stream"},
    {"audio/player/Motor-Noise.mp3", "static"},
    {"audio/player/Motor-Quindoc.mp3", "static"},

}


--[[
                    current[string.sub(file, 1, #file-4)] = love.filesystem.load(original[1])

                if original[2] == "addObstacles" then
                    local c = current[string.sub(file, 1, #file-4)]()
                    for i = 1,#c do
                        for name, _ in pairs(c[i].data) do
                            table.insert(self.loadList, #self.loadList+1, {"obstacle/" .. name .. ".lua", "run"})
                        end
                    end
                end
]]

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





-- load this file in a more permenant position.
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/zone.lua"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/music.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/ambiance.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/obstacle.lua", "run"})

table.insert(toLoad, function()
    riverFileDirectory = assets.code.river.riverData[riverName]

    scrapImages = {}
    for i = 1, 5 do
        scrapImages[i] = love.graphics.newImage("image/player/scrap/scrap"..i..".png")
        scrapImages[i]:setFilter("nearest")
    end --this has to go here because of how constrained the dynamic loading system is :/

    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks( beginContact, endContact, preSolve, postSolve )



    player = assets.code.player.playerBoat():New()
    ui = assets.code.player.playerUi()
    camera = assets.code.camera():New(0, 0, 960, 900)

    love.resize()

    ambiance = love.filesystem.load("code/river/effects/ambient.lua")()

    river = assets.code.river.river():New()
    riverGenerator = assets.code.river.generator.riverGenerator():New(riverName)

    obstacles = {}
    frontObstacles = {}
    
    local zoneObsitcalList = {}
    local riverZones = riverFileDirectory.zone()
    for key, z in pairs(riverZones) do
        zoneObsitcalList[z.zone] = assets.code.river.zone[z.zone].obsticals()
    end
    obstacleSpawner = assets.code.river.generator.obstacleSpawner():New(zoneObsitcalList, 1000)
    obstacleSpawner:Update()

    world:update(0)

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

    for i = #frontObstacles,1, -1 do
        frontObstacles[i]:Update(i, 0)
    end

    
    local keybinds = assets.code.menu.keybinds()
    for key, value in pairs(keybinds) do
        if settings.keybinds[key] then
            keybinds[key].keyboard = settings.keybinds[key].value
        end
    end

    inputManager = assets.code.inputManager():New( keybinds )

    particles.loadParticles()

    music.load()
end)

table.insert(toLoad, function()
    -- empty function to scam bote game into reseting dt 
end)

return toLoad