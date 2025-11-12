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

    if titleScreenUI ~= nil and titleScreenButtons then
        titleScreenButtons.CreateButtons(titleScreenUI)
    end

    riverBorders.up =    y
    riverBorders.down =  y + love.graphics.getHeight()/screen.getScale()
end

local function load()
    
    --y = 0
    resize()


    
    --DynamicLoading:New("code/gameStateLoading/titleScreenLoading.lua", true, (previousGameState == "splash" and "image/loading/clear.png") or "image/loading/title.png")
end

local function unload()
    love.thread.getChannel("background_closeThread"):push(true)
    if music then
        music.unload()
    end

    titleScreenUI = nil
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
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    y = y-100*dt
    if riverGenerator then
        riverGenerator:Update(-y)

        if river:HasPoints() then
            zones = riverGenerator:GetZone(y, true)

            particles.updateParticles(dt)
            --ambiance.update(dt, -y)

            riverBorders.up =    y
            riverBorders.down =  y + love.graphics.getHeight()/screenScale

            river:Update(-y)
            obstacleSpawner:Update()
            world:update(dt)

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
        else      
            river:checkNextSegment()

            if river:HasPoints() then
                player:moveToCenter()

            end
        end

        if settingsMenu then
            if settingsMenu.isOpen == false then
                titleScreenUI:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
                settingsTimer = math.max(settingsTimer - dt*2, 0)
            else
                -- Use math.huge so it will never be hovering over a button right?
                titleScreenUI:Update(dt, math.huge, math.huge)
                settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
                settingsTimer = math.min(settingsTimer + dt*2, 1)
            end
        end

        if music and music.manager then music.manager(dt) end
    end

    if menuManager.isMenuOpen() then
        menuManager.update(dt)
    else
        userInterface:update(dt)
        userInterface:checkHover("UI")
    end
end

local function mousepressed(x, y, button)
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousepressed(mx, my, button) then
        return
    end

    if settingsMenu and titleScreenUI then
        if settingsMenu.isOpen == false then
            if titleScreenUI then
                titleScreenUI:Click(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
            end
        else
            settingsMenu:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
        end
    end

    userInterface:toggleClick(true, "UI")
end

local function mousereleased(x, y, button)

    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousereleased(mx, my, button) then
        return
    end

    if settingsMenu then
        if settingsMenu.isOpen == false then
            if titleScreenUI then
                titleScreenUI:Release(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
            end
        else
            settingsMenu:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)        
        end
    end

    userInterface:toggleClick(false, "UI")
end


local function keyreleased(key)
    if menuManager.keyreleased and menuManager.keyreleased(key) then
        return true
    end
    if settingsMenu and settingsMenu.isOpen == true then
        settingsMenu:KeyRelased(key)
    end
end


local function draw()
    local screenScale = screen.getScale()
    love.graphics.reset()
    love.graphics.scale(screenScale)

    local width = love.graphics.getWidth()/screenScale
    local height = love.graphics.getHeight()/screenScale

    love.graphics.push()

    -- Draw River Here
    local s = width/1920--(width*0.6 > 1920) and width*0.6 / 1920 or 1
    love.graphics.translate(width*0.5,0)
    love.graphics.scale(s)
    love.graphics.translate(0, -y)


    love.graphics.setColor(1,1,1)
    if river then
        if river:HasPoints() then
            river:Draw()
            for i = 1,#obstacles do
                obstacles[i]:Draw(i)
            end

            particles.drawParticles("bottom")
            particles.drawParticles("top")
        end
    end


    love.graphics.pop()

    if titleScreenUI then
        titleScreenUI:Draw()
    end

    if assets.image and assets.image.titleScreen and assets.image.titleScreen.title then 
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(assets.image.titleScreen.title,width*0.3 - 2.5 - 50,0,0,0.75,0.75, assets.image.titleScreen.title:getWidth()/2, 0)
        --font.setFont("black", 32)
        --love.graphics.print("Alpha Demo 2???",350,350)
    end

    if settingsMenu then
        settingsMenu:Draw(tweens.sineInOut(settingsTimer))
    end

end

local function drawUI()
    userInterface.drawDebug = settings.dev.drawHitboxes.value
    userInterface:draw("UI")
end

local function drawMenu(targetWidth, targetHeight, offsetX, offsetY)
    menuManager.draw(targetWidth, targetHeight, offsetX, offsetY)
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
    drawUI = drawUI,
    drawMenu = drawMenu,
    --isFirst = DEV,
    noTransform = true,
}