local generator = {}
local river = {}
local camera = {}

local function load()
    generator = require("code/generation/base")
    camera = require("code/camera")
    generator.Load()
    river = generator.nextSegment()
end

local function keypressed(key)
    if DEV then
        if key == "r" then
            river = generator.nextSegment()
        end

    end
end

local function update(dt)
    if cameraUnlocked then
        camera.update(dt)
    end
end

local function drawPoints()
    --loop though each channel
    if river and #river > 0 then
        for channel = 1,#river do
            --loop though each side
            for side = 1,#river[channel] do
                for i = 1,#river[channel][side] do
                    local point = river[channel][side][i]
                    love.graphics.circle("fill", point.x, point.y, 10)
                end
            end
        end
    end

    if curveLeft then
        love.graphics.line(curveLeft:render())
    end
    if curveRight then
        love.graphics.line(curveRight:render())
    end
end

local function draw()
    love.graphics.translate(camera.x, camera.y)
    drawPoints()
end

return {
    load = load,
    keypressed = keypressed,
    update = update,
    draw = draw,
}