local smoothPause = true
local gameSpeed = 1

local scale 
local sox
local soy = 0

local step = true
local steping = false

local loading

local pauseMenu
local gameOverMenu
local settingsTween

-- deefault values
riverBorders = {
    left = -960,
    right = 960,
    up = 0,
    down = 1080,
}

-- this should solve all our problems ☜(ﾟヮﾟ☜) 👍
local pain = false

function SetGameSpeed(speed)
    gameSpeed = speed
end


local function resize()
    scale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 < scale then
        scale = love.graphics.getHeight()/1080
    end

    sox = ((love.graphics.getWidth()/scale) - 1920) /2
    --soy = ((love.graphics.getHeight()/scale) - 1080) /2

    local oldWidth = riverBorders.width

    riverBorders = {
        left = -love.graphics.getWidth()/2 / scale,
        right = love.graphics.getWidth()/2 / scale,
        up =    player.y - camera.oy,
        down =  player.y - camera.oy + love.graphics.getHeight()/scale,
        width = love.graphics.getWidth() / scale,
        height= love.graphics.getHeight() / scale,
    }

    river:AddFakeCanvases()
end


local function unload()
    UpdateHighScore()
end


local function load()
    love.physics.setMeter(100)

    loading = DynamicLoading:New("code/gameStateLoading/riverLoading.lua", 
    {
        {"image/titleScreen/parallax/1.png", 0},
        {"image/titleScreen/parallax/2.png", .1},
        {"image/titleScreen/parallax/3.png", .2},
    }, true)

    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks( beginContact, endContact, preSolve, postSolve )

    pauseMenu = PauseMenu:New()--assets.code.menu.pauseMenu():New()
    gameOverMenu = GameOverMenu:New()

    player = assets.code.player.playerBoat():New()
    ui = assets.code.player.playerUi()
    camera = assets.code.camera():New(0, 0, 960, 900)
    river = assets.code.river.river():New()
    riverGenerator = assets.code.river.generator.riverGenerator():New(assets.code.river.riverData[riverName]())
    obstacles = {}
    local zoneObsitcalList = {}
    for i = 1,#riverGenerator.zones do
        local zone = riverGenerator.zones[i]
        zoneObsitcalList[zone.zone] = assets.code.river.zone[zone.zone].obsticals()
    end
    obstacleSpawner = assets.code.river.generator.obstacleSpawner():New(zoneObsitcalList)


    if keybindSaveLocation then
        inputManager = assets.code.inputManager():New( keybindSaveLocation )
    else
        print("Loading default keybinds")
        inputManager = assets.code.inputManager():New( assets.code.menu.keybinds() )

    end

    resize()

    particles.loadParticles()

    --riverGenerator:NextSegment()
end

function GetRiverScale()
    return {scale, sox}
end

local function focus(focus)
    if not player or player.health > 0 then
        pauseMenu.isOpen = true
    end
end

local function update(dt)
    step = true
    if steping then
        dt = 1/60
    end

    riverGenerator:Update()

    if river:HasPoints() then
        local inputs = inputManager:GetInput()

        local gs = tweens.sineInOut(gameSpeed)

        particles.updateParticles(dt*gs)

        spawnSnow(dt*gs)

        -- Update the player first, all other things rely on it basically
        player:Update(dt*gs, inputs)
        
        ui:Update(dt*gs)

        -- update the camera and similar variables after the player so it doesn't lag behind slightly
        camera:SetPosition(0, player:GetPosition().y)
        camera:Update(dt*gs)

        riverBorders.up =    player.y - camera.oy
        riverBorders.down =  player.y - camera.oy + love.graphics.getHeight()/scale

        -- update the river after the player so we can generate based on the players position.
        river:Update()

        obstacleSpawner:Update()

        world:update(dt*gs)

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
                elseif dataA.type == "player" or dataB.type == "player" then
                    local playerData
                    local collideData

                    if dataA.type == "player" then
                        playerData = dataA
                        collideData = dataB
                    else
                        playerData = dataB
                        collideData = dataA
                    end

                    if not collideData.hasCollided then
                        collideData.hasCollided = true
                        player:TakeDamage(1)
                    end
                end    
            end
        end

        for i = #obstacles,1, -1 do
            obstacles[i]:Update(i, dt)
        end

        if player.health <= 0 and player.deathTime >= 1 and not pauseMenu.isOpen then
            local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
            local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

            gameOverMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
        elseif pauseMenu.isOpen then
            local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
            local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
        
            pauseMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

            gameSpeed = math.max(gameSpeed - dt*2, 0)

            if pauseMenu.settingsTimer > 0 then
                settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
            end
        else
            if not player.wasBeached then
                gameSpeed = math.min(gameSpeed + dt*2, 1)
            else
                gameSpeed = math.min(gameSpeed + dt, 1)

                if gameSpeed == 1 then
                    player.wasBeached = nil
                end

            end
        end

    else        
        river:checkNextSegment()
    end

    if steping then
        local skull = 0
        while step do
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return "QUIT"
                        end
                    end
                    love.handlers[name](a,b,c,d,e,f)
                end
            end
        end
    end
end


local function mousepressed(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if player and player.health <= 0 and player.deathTime >= 1 and not pauseMenu.isOpen then
        gameOverMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    end

    if settingsMenu and settingsMenu.isOpen == true then
        settingsMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    elseif pauseMenu.isOpen == true then
        pauseMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    end
end

local function mousereleased(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if player and player.health <= 0 and player.deathTime >= 1 and not pauseMenu.isOpen then
        gameOverMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    end

    if settingsMenu and settingsMenu.isOpen == true then
        settingsMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)      
    elseif pauseMenu.isOpen == true then
        pauseMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)      
    end
end


local function keyreleased(key)
    local input = {}
    if inputManager then
        input = inputManager:Send("keyboard", key)
    end

    if input == "pause" then
        if settingsMenu.isOpen then settingsMenu.isOpen = false
        elseif player.health > 0 then pauseMenu.isOpen = not pauseMenu.isOpen end
    end

    if key == "k" and DEV then
        dante.printTable(assets.save.highscore)
    end

    if key == "return" and step then
        step = false

        if love.keyboard.isDown("lctrl") then
            steping = not steping
        end
    end
end


local function draw()
    if river:HasPoints() then
        love.graphics.scale(scale)
        love.graphics.setColor(1,1,1)

        love.graphics.translate(sox, soy)
        love.graphics.push()

        camera:TranslateCanvas()

        --Objects which exist within the game world are to be drawn here

        river:Draw(scale)
        for i = 1,#obstacles do
            obstacles[i]:Draw(i)
        end

        particles.drawParticles("bottom")

        player:Draw()
      --  

        particles.drawParticles("top")

        ---TEMPORARY (TM) placeholder (r) storm mode effect

        local stormIntensity = 0

        if zones and type(zones[1]) == "table" then --if we are in a storm

            local p = riverGenerator:GetPercentageThrough(player.y)
            stormIntensity = (quindoc.runIfFunc(zones[1].stormIntensity,p) or 0)*(1-zones[3]) + (quindoc.runIfFunc(zones[2].stormIntensity,0) or 0)*zones[3] 
    
        elseif zones then --just set the storm amount to what it needs to be
    
            local p = riverGenerator:GetPercentageThrough(player.y)
            stormIntensity = quindoc.runIfFunc(zones.stormIntensity,p) or 0 --current is a GLOBAL VALUE for a reason btw
    
        end    

        if stormIntensity then love.graphics.setColor(1,1,1,stormIntensity/1000) end
        love.graphics.draw(assets.image.ui.viginette, -riverBorders.width/2-100*riverBorders.width/1920, riverBorders.up-100*riverBorders.height/1080, 0, riverBorders.width/1920, riverBorders.height/1080)

        --LIGHTNING STRIKES
        --at maximum storm intensity, lighting will strike on average once per 10 seconds
        if stormIntensity > 500 and math.random(1,600/(stormIntensity/1000)) == 1 then
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.rectangle("fill",riverBorders.left-100*riverBorders.width/1920, riverBorders.up-100*riverBorders.height/1080, riverBorders.width+100*riverBorders.width/1920,riverBorders.height+100*riverBorders.height/1080)
            --TODO: Play lightning sound here (not sure you can play sounds in love.draw)
        end

        --draww hitboxes over everythingh
        if settings.dev.drawHitboxes.value then
            river:DrawPoints()

            for i = 1,#obstacles do
                obstacles[i]:DrawHitbox() --
            end
            
            player:DrawHitbox()
        end

        love.graphics.pop()
        --love.graphics.draw(assets.image.ui["Sprite-0007"])


        love.graphics.reset()
        love.graphics.scale(screenScale)
    
        local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
        local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
        local sx, sy = camera:GetShake()
        love.graphics.translate(sox + sx, soy + sy)

        ui:Draw()
    
        local gs = tweens.sineInOut(gameSpeed)
        
        if player.health <= 0 and player.deathTime >= 1 and not pauseMenu.isOpen then
            local tween = tweens.sineInOut(quindoc.clamp((player.deathTime-1)*2, 0, 1))
            gameOverMenu:Draw(tween)
        end


        if 1-gs > 0 and not player.wasBeached then
            pauseMenu:Draw(1-gs)

            if pauseMenu.settingsTimer > 0 then
                settingsMenu:Draw(tweens.sineInOut(pauseMenu.settingsTimer), true)
            end
        end

        love.graphics.reset()
        love.graphics.setColor(0,0,0)
        love.graphics.print(love.timer.getFPS())

        love.graphics.print("player = " .. dante.dataToString(player), 0, 20)

    else

        local screenScale = love.graphics.getWidth()/1920
        if love.graphics.getHeight()/1080 > screenScale then
            screenScale = love.graphics.getHeight()/1080
        end

        love.graphics.scale(screenScale)
        loading.image:Draw(love.graphics.getWidth()/screenScale/2 - 960, love.graphics.getHeight()/screenScale/2 - 540, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
    end

    love.graphics.reset()
end

function UpdateHighScore(newScore)
    if assets.save and assets.save.highscore and type(assets.save.highscore) == "table" then
    else
        if assets.save then
        else
            assets.save = {}
        end
        assets.save.highscore = {}
    end

    if newScore then
        table.insert(assets.save.highscore, newScore)
    end
    table.sort(assets.save.highscore, function(a, b) return a > b end)

    if assets.save.highscore then
        dante.save(assets.save.highscore, "save", "highscore")
    end

    -- only store 6 records
    if #assets.save.highscore > 6 then
        while #assets.save.highscore > 6 do
            table.remove(assets.save.highscore, #assets.save.highscore)
        end
    end
end


return {
    load = load,
    focus = focus,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    resize = resize,
    draw = draw,
    unload = unload,

    noTransform = true,
}