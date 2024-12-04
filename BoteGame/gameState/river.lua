local smoothPause = true
local gameSpeed = 1

local scale 
local sox
local soy = 0


local function resize()
    scale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 < scale then
        scale = love.graphics.getHeight()/1080
    end

    sox = ((love.graphics.getWidth()/scale) - 1920) /2
    --soy = ((love.graphics.getHeight()/scale) - 1080) /2
end

local function load()
    DynamicLoading:New("code/gameStateLoading/riverLoading.lua", 
    {
        {"image/titleScreen/parallax/1.png", 0},
        {"image/titleScreen/parallax/2.png", .1},
        {"image/titleScreen/parallax/3.png", .2},
    }, true)

    player = assets.code.player.playerBoat():New()
    camera = assets.code.camera():New(0, 0, 960, 900)
    if keybindSaveLocation then
        inputManager = assets.code.inputManager():New( keybindSaveLocation )
    else
        print("Loading default keybinds")
        inputManager = assets.code.inputManager():New( assets.code.settingsMenu.keybinds() )

    end

    resize()
end

local function update(dt)
    local inputs = inputManager:GetInput()

    local gs = tweens.sineInOut(gameSpeed)

    player:Update(dt*gs, inputs)

    if settingsMenu.isOpen then
        local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
        local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    
        settingsMenu:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)

        gameSpeed = math.max(gameSpeed - dt*5, 0)
    else
        gameSpeed = math.min(gameSpeed + dt*5, 1)
    end
    print(gameSpeed)
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
end


local function draw()
    love.graphics.scale(scale)
    love.graphics.translate(sox, soy)

    camera:TranslateCanvas()

    player:Draw()



    love.graphics.reset()
    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    love.graphics.translate(sox, soy)

    if settingsMenu.isOpen then
        settingsMenu:Draw()
    end
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