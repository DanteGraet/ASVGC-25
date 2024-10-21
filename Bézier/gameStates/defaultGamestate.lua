local generator = {}

local river = {}

local function load()
    generator = require("code/generation/base")
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

end

local function drawPoints()
    --loop though each channel
    for channel = 1,#river do
        --loop though each side
        for side = 1,#river[channel] do
            for i = 1,#river[channel][side] do
                local point = river[channel][side][i]
                love.graphics.circle("fill", point.x, point.y, 10)
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
    drawPoints()
end

return {
    load = load,
    keypressed = keypressed,
    update = update,
    draw = draw,
}