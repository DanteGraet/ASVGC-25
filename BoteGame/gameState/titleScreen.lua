local background
local backgroundScale
local hasMouseFocus

local titleScreenUI
local titleScreenButtons

local settingsTimer = 0

local y = 0

local function resize()
    backgroundScale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 > backgroundScale then
        backgroundScale = love.graphics.getHeight()/1080
    end

    if titleScreenUI ~= nil then
        titleScreenButtons.CreateButtons(titleScreenUI)
    end
end

local function load()
    love.physics.setMeter(100)
    resize()

    fontBlack32 = love.graphics.newFont("font/fontBlack.ttf",32)

    DynamicLoading:New("code/gameStateLoading/titleScreenLoading.lua", true)
end

local function unload()
    love.thread.getChannel("background_closeThread"):push(true)
    --while not love.thread.getChannel("background_closeThreadReceived"):pop() do
      --  print("waiting")
    --end
    music.unload()
    end

local function extraLoad()

    --Create the buttons for the titleScreen
    titleScreenUI = GraetUi:New()
    titleScreenButtons = assets.code.titleScreen.titleScreenButtons()
    titleScreenButtons.CreateButtons(titleScreenUI)

    local tempMenu = assets.code.menu.settingsMenu()
    settingsMenu = SettingsMenu:New()

    music.load()
end


local function mousefocus(f)
    hasMouseFocus = f
end


local function update(dt)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    y = y-100*dt

    riverGenerator:Update(-y)

    if river:HasPoints() then
        zones = riverGenerator:GetZone(y, true)
        local gs = 1

        particles.updateParticles(dt*gs)

        --spawnSnow(dt*gs)
        ambiance.update(dt*gs, -y)



        riverBorders.up =    y
        riverBorders.down =  y + love.graphics.getHeight()/screenScale

        -- update the river after the player so we can generate based on the players position.

        river:Update(-y)
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
                end    
            end
        end

        for i = #obstacles,1, -1 do
            obstacles[i]:Update(i, dt)
        end

    else      
        river:checkNextSegment()

        if river:HasPoints() then
            player:moveToCenter()

        end
    end

    if settingsMenu.isOpen == false then
        titleScreenUI:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

        settingsTimer = math.max(settingsTimer - dt*2, 0)
    else
        -- Use math.huge so it will never be hovering over a button right?
        titleScreenUI:Update(dt, math.huge, math.huge)

        settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

        settingsTimer = math.min(settingsTimer + dt*2, 1)
    end

    if music.manager then music.manager(dt) end
end

local function mousepressed(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if settingsMenu then
        if settingsMenu.isOpen == false then
            titleScreenUI:Click(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
        else
            settingsMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
        end
    end
end

local function mousereleased(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2


    if settingsMenu then
        if settingsMenu.isOpen == false then
            titleScreenUI:Release(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
        else
            settingsMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)        
        end
    end
end


local function keyreleased(key)
    if settingsMenu and settingsMenu.isOpen == true then
        settingsMenu:KeyRelased(key)
    end
end


local function draw()
    love.graphics.reset()
    love.graphics.scale(screenScale)

    --love.graphics.translate(sox, soy)
    local width = love.graphics.getWidth()/screenScale
    local height = love.graphics.getHeight()/screenScale

    love.graphics.push()

    love.graphics.setColor(1,1,1)


    -- Draw River Here
    local s = (width*0.6 > 1920) and width*0.6 / 1920 or 1

    love.graphics.translate(width*0.7,0)

    love.graphics.scale(s)
    love.graphics.translate(0, -y)



    if river:HasPoints() then
        river:Draw()
        for i = 1,#obstacles do
            obstacles[i]:Draw(i)
        end

        particles.drawParticles("bottom")
        particles.drawParticles("top")
    end




    love.graphics.pop()

    love.graphics.setLineWidth(10)
    love.graphics.setColor(quindoc.hexcode("743f30"))
    love.graphics.rectangle("fill", 0, 0, width*0.4, height)

    love.graphics.setColor(quindoc.hexcode("33201a"))
    love.graphics.line(width*0.4, 0, width*0.4, height)

    if titleScreenUI then
        titleScreenUI:Draw()
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assets.image.titleScreen.title,50,50,0,0.75,0.75)
    love.graphics.setFont(fontBlack32)
    love.graphics.print("Alpha Demo 2???",350,350)

    if settingsMenu then
        settingsMenu:Draw(tweens.sineInOut(settingsTimer))
    end
end


return {
    load = load,
    extraLoad = extraLoad,
    unload = unload, 
    resize = resize,
    mousefocus = mousefocus,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,

    isFirst = true,
    noTransform = true,
}