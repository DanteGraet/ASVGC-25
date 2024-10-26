local camera = {}

local river = require("code.river")
local devMenu = require("code.builtInBackdoor")




local function load()
    love.math.setRandomSeed(os.time(), love.timer.getTime())

    camera = require("code/camera")
    river.load()
end



local function keypressed(key)
    if DEV then
        devMenu.keypressed(key)
    end
end

local function mousepressed(x, y, button)
    if DEV then
        devMenu.mousepressd(x, y, button)
    end
end



local function update(dt)

    camera.update(dt)

    river.update(dt)

    if devMenu then
        devMenu.update()
    end
end


local function draw()
    love.graphics.setBackgroundColor(67/255, 78/255, 175/255)
    love.graphics.translate(camera.x, camera.y)
    
    river.draw()


    love.graphics.reset()

    if devMenu then
        devMenu.draw()
    end
end

return {
    load = load,
    keypressed = keypressed,
    mousepressed = mousepressed,
    update = update,
    draw = draw,
}