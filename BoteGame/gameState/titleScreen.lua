local background
local backgroundScale
local hasMouseFocus

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
end

local function mousefocus(f)
    hasMouseFocus = f
end

local function update(dt)
    if not hasMouseFocus then
        background:Update(dt, math.huge, math.huge)
    else
        background:Update(dt, love.mouse.getX()/backgroundScale, love.mouse.getY()/backgroundScale)
    end
end

local function draw()
    love.graphics.scale(backgroundScale)
    
    local sox = ((love.graphics.getWidth()/backgroundScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/backgroundScale) - 1080) /2

    background:Draw(sox, soy, love.mouse.getX()/backgroundScale, love.mouse.getY()/backgroundScale)
end


return {
    load = load,
    resize = resize,
    mousefocus = mousefocus,
    update = update,
    draw = draw,

    isFirst = true,
    noTransform = true,
}