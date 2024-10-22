local generator = {}
local river = {}
local camera = {}

local function mergeRiver(new)
    --print(river)

    for channel = 1,#new do
        if not river[channel] then
            river[channel] = {}
        end

        for side = 1,#new[channel] do
            if not river[channel][side] then
                river[channel][side] = {}
            end

            for point = 1,#new[channel][side], 2 do
                local data = {
                    x = new[channel][side][point],
                    y = new[channel][side][point + 1],
                }
                table.insert(river[channel][side], data)
            end
        end
    end
end

local function load()
    generator = require("code/generation/base")
    camera = require("code/camera")
    generator.Load()
    mergeRiver(generator.nextSegment())
end

local function keypressed(key)
    if DEV then
        if key == "r" then
            local last = nil
            if #river > 0 then
                last = {}
                for channel = 1,#river do
                    table.insert(last, {})
                    for side = 1,#river[channel] do
                        local s = river[channel][side]
                        --add the sides
                        table.insert(last[channel], {})

                        last[channel][side].x = s[#s].x
                        last[channel][side].y = s[#s].y


                    end
                end
            end
            
            mergeRiver(generator.nextSegment(last))
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