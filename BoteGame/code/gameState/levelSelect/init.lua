local uiFade = 0
local selectedMenu = ""
local levels = {}

local unlockTimer = 0

local sine = 0



local function load()
    local img = "image/loading/" .. riverName .. ".png"
    -- bootleg fix
    if string.sub(riverName, #riverName - 4, #riverName) == "Storm" then
        img = "image/loading/" .. "storm" .. ".png"
    end
    if previousGameState == "titleScreen" then
        img = "image/loading/title.png"
    end

    --DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", true, img)
end


local function unload()

end


local function extraLoad()
    ambiance = love.filesystem.load("code/river/effects/ambient.lua")()

    isStorm = false

    uiFade = 0

    
    dialouge.next()
end

local function resize()

end

local function update(dt)
    local screenScale = screen.getScale()

    ambiance.update(dt, nil, nil, {audio = {bird = 0.1, water = 1}})

    dialouge.update(dt)

    sine = sine + dt

    if menuManager.isMenuOpen() then
        menuManager.update(dt)
    else
        userInterface:checkHover("")
    end

    userInterface:update(dt)
end

local function mousepressed(x, y, button)
    local screenScale = screen.getScale()

    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousepressed(mx, my, button) then
        return
    end

    userInterface:toggleClick(true, "")
end

local function mousereleased(x, y, button)
    local screenScale = screen.getScale()
    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousereleased(mx, my, button) then
        return
    end

    userInterface:toggleClick(false, "")
end


local function keyreleased(key)
    if menuManager.keyreleased and menuManager.keyreleased(key) then
        return true
    end
    if key == "escape" then
        gameStateManager.setGameState("responsiveLoading", nil, "titleScreen")
    end
end


local function draw()
    love.graphics.setColor(1,1,1)
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    for x = -10, love.graphics.getWidth()/screenScale + 10, 500 do
        for y = -10, love.graphics.getHeight()/screenScale + 10, 500 do
            love.graphics.draw(assets.image.levelSelect.wood, x - sox, y - soy)
        end
    end

    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 1920/5120, 1080/2880)

    love.graphics.setColor(1,1,1)

    dialouge.draw()


    --last so graphics.reset() dont change it
    love.graphics.setBackgroundColor(.5,.5,.5)

    userInterface:draw()
end


local function drawMenu(targetWidth, targetHeight, offsetX, offsetY)
    menuManager.draw(targetWidth, targetHeight, offsetX, offsetY)
end

return {
    load = load,
    extraLoad = extraLoad,
    unload = unload,

    resize = resize,
    
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
    drawMenu = drawMenu,
}