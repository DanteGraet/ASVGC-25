local camera = {}

river = require("code.river")
local devMenu = require("code.builtInBackdoor")

require("code.obstacle.obstacle")
require("code.obstacle.rock")
require("code.obstacle.spawner")


obsticals = {}


local function load()
    love.physics.setMeter(100)
    world = love.physics.newWorld(0, 0, false)


    obstacleSpawner = ObstacleSpawner:New()
    obstacleSpawner:AddSpawner(rockObstical)

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

    obstacleSpawner:Update(getCamera().y)

    river.update(dt)

    if devMenu then
        devMenu.update()
    end
end


local function draw()
    love.graphics.setBackgroundColor(67/255, 78/255, 175/255)
    love.graphics.translate(camera.x, camera.y)
    
    river.draw()

    for i = 1,#obsticals do
        obsticals[i]:Draw()

        obsticals[i]:DrawHitbox()
    end


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