local background
local backgroundScale
local hasMouseFocus

local titleScreenUI
local titleScreenButtons

local settingsTimer = 0

local function resize()
    backgroundScale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 > backgroundScale then
        backgroundScale = love.graphics.getHeight()/1080
    end
end

local function load()
    resize()

    DynamicLoading:New("code/gameStateLoading/titleScreenLoading.lua", 
        {
            {"image/titleScreen/parallax/1.png", .03125},
            {"image/titleScreen/parallax/2.png", .0625},
            {"image/titleScreen/parallax/3.png", .09375},
            {"image/titleScreen/parallax/4.png", .125},
            {"image/titleScreen/parallax/5.png", .15625},
            {"image/titleScreen/parallax/6.png", .1875},
            {"image/titleScreen/parallax/7.png", .21875},
        }, true)

    
    background = ParallaxImage:New(1920, 1080, {
        {assets.image.titleScreen.parallax["1"], .03125},
        {assets.image.titleScreen.parallax["2"], .0625},
        {assets.image.titleScreen.parallax["3"], .09375},
        {assets.image.titleScreen.parallax["4"], .125},
        {assets.image.titleScreen.parallax["5"], .15625},
        {assets.image.titleScreen.parallax["6"], .1875},
        {assets.image.titleScreen.parallax["7"], .21875},
    })
    background.hovering = 1

    --Create the buttons for the titleScreen
    titleScreenUI = GraetUi:New()
    titleScreenButtons = assets.code.titleScreen.titleScreenButtons()
    titleScreenButtons.CreateButtons(titleScreenUI)

    settingsMenu = SettingsMenu:New()
end


local function mousefocus(f)
    hasMouseFocus = f
end


local function update(dt)
    if not hasMouseFocus then
        background:Update(dt, -math.huge, math.huge)
    else
        background:Update(dt, love.mouse.getX()/backgroundScale, love.mouse.getY()/backgroundScale, backgroundScale)
    end

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if settingsMenu.isOpen == false then
        titleScreenUI:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

        settingsTimer = math.max(settingsTimer - dt*2, 0)
    else
        -- Use math.huge so it will never be hovering over a button right?
        titleScreenUI:Update(dt, math.huge, math.huge)

        settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

        settingsTimer = math.min(settingsTimer + dt*2, 1)
    end
end

local function mousepressed(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if settingsMenu then
        if settingsMenu.isOpen == false then
            titleScreenUI:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
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
            titleScreenUI:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
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
    love.graphics.scale(backgroundScale)
    
    local sox = ((love.graphics.getWidth()/backgroundScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/backgroundScale) - 1080) /2

    background:Draw(sox, soy, love.mouse.getX()/backgroundScale, love.mouse.getY()/backgroundScale)

    love.graphics.reset()
    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    love.graphics.translate(sox, soy)

    titleScreenUI:Draw()

    settingsMenu:Draw(tweens.sineInOut(settingsTimer))
end


return {
    load = load,
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