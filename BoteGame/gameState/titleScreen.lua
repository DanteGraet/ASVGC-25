local background
local backgroundScale
local hasMouseFocus

local titleScreenUI
local titleScreenButtons

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
            {"image/titleScreen/parallax/1.png", 0},
            {"image/titleScreen/parallax/2.png", .1},
            {"image/titleScreen/parallax/3.png", .2},
        }, true)

    
    background = ParallaxImage:New(1920, 1080, {
        {assets.image.titleScreen.parallax["1"], 0},
        {assets.image.titleScreen.parallax["2"], .1},
        {assets.image.titleScreen.parallax["3"], .2},
    })
    background.hovering = 1

    --Create the buttons for the titleScreen
    titleScreenUI = GraetUi:New()
    titleScreenButtons = assets.code.titleScreen.titleScreenButtons()
    titleScreenButtons.CreateButtons(titleScreenUI)
end


local function mousefocus(f)
    hasMouseFocus = f
end


local function update(dt)
    if not hasMouseFocus then
        background:Update(dt, -math.huge, math.huge)
    else
        background:Update(dt, love.mouse.getX()/backgroundScale, love.mouse.getY()/backgroundScale)
    end

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    titleScreenUI:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
end

local function mousepressed(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    titleScreenUI:Click(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
end

local function mousereleased(x, y, button)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    titleScreenUI:Release(love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
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

end


return {
    load = load,
    resize = resize,
    mousefocus = mousefocus,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    update = update,
    draw = draw,

    isFirst = true,
    noTransform = true,
}