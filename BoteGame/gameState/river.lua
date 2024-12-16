local smoothPause = true
local gameSpeed = 1

local scale 
local sox
local soy = 0

local step = true
local steping = false

local loading

-- deefault values
riverBorders = {
    left = -960,
    right = 960,
    up = 0,
    down = 1080,
}

-- this should solve all our problems ☜(ﾟヮﾟ☜) 👍
local pain = false


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


local function load()
    loading = DynamicLoading:New("code/gameStateLoading/riverLoading.lua", 
    {
        {"image/titleScreen/parallax/1.png", 0},
        {"image/titleScreen/parallax/2.png", .1},
        {"image/titleScreen/parallax/3.png", .2},
    }, true)

    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks( beginContact, endContact, preSolve, postSolve )
    love.physics.setMeter(100)

    player = assets.code.player.playerBoat():New()
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
        inputManager = assets.code.inputManager():New( assets.code.settingsMenu.keybinds() )

    end

    resize()

    particles.loadParticles()

    --riverGenerator:NextSegment()
end

function GetRiverScale()
    return {scale, sox}
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

        -- update the camera and similar variables after the player so it doesn't lag behind slightly
        camera:SetPosition(0, player:GetPosition().y)

        riverBorders.up =    player.y - camera.oy
        riverBorders.down =  player.y - camera.oy + love.graphics.getHeight()/scale

        -- update the river after the player so we can generate based on the players position.
        river:Update()

        obstacleSpawner:Update()

        world:update(dt)

        local contacts = world:getContacts()

        for _, contact in ipairs(contacts) do
            local fixtureA, fixtureB = contact:getFixtures()  -- Get the two fixtures involved
            local dataA = fixtureA:getUserData()
            local dataB = fixtureB:getUserData()
            if  dataA.first then
                dataA.remove = true
                fixtureA:setUserData(dataA)
            elseif dataB.first then
                dataB.remove = true
                fixtureB:setUserData(dataB)
            end
        end

        for i = #obstacles,1, -1 do
            obstacles[i]:Update(i, dt)
        end

        if settingsMenu.isOpen then
            local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
            local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
        
            settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

            gameSpeed = math.max(gameSpeed - dt*2, 0)
        else
            gameSpeed = math.min(gameSpeed + dt*2, 1)
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

    if settingsMenu.isOpen == true then
        settingsMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    end
end

local function mousereleased(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if settingsMenu.isOpen == true then
        settingsMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)        
    end
end


local function keyreleased(key)
    local input = inputManager:Send("keyboard", key)

    if input == "pause" then
        settingsMenu.isOpen = not settingsMenu.isOpen
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

            --obstacles[i]:DrawHitbox()
        end

        particles.drawParticles("bottom")

        player:Draw()
      --  river:DrawPoints()

        particles.drawParticles("top")

        love.graphics.pop()
        love.graphics.draw(assets.image.ui["Sprite-0007"])

        love.graphics.reset()
        love.graphics.scale(screenScale)
    
        local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
        local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
        love.graphics.translate(sox, soy)
    
        local gs = tweens.sineInOut(gameSpeed)
        
        if 1-gs > 0 then
        --if settingsMenu.isOpen then
            
            settingsMenu:Draw(1-gs)
        end

        love.graphics.reset()
        love.graphics.setColor(0,0,0)
        love.graphics.print(love.timer.getFPS())
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



return {
    load = load,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    resize = resize,
    draw = draw,

    noTransform = true,
}