local river = {}
local points = {}
local generator = {}



function river.mergePoints(new)
    --print(river)
    for channel = 1,#new do
        if not points[channel] then
            points[channel] = {}
        end

        for side = 1,#new[channel] do
            if not points[channel][side] then
                points[channel][side] = {}
            end

            for point = 1,#new[channel][side], 2 do
                local data = {
                    x = new[channel][side][point],
                    y = new[channel][side][point + 1],
                }
                table.insert(points[channel][side], data)
            end
        end
    end
end

local function generateNextRiver()
    local last = nil
    if #points > 0 then
        last = {}
        for channel = 1,#points do
            table.insert(last, {})
            for side = 1,#points[channel] do
                local s = points[channel][side]
                --add the sides
                table.insert(last[channel], {})

                last[channel][side].x = s[#s].x
                last[channel][side].y = s[#s].y

            end
        end
    end
    
    river.mergePoints(generator.nextSegment(last))
end



function river.load()
    generator = require("code/generation/base")

    generator.Load()
    river.mergePoints(generator.nextSegment())
end

function river.update(dt)
    local camera = getCamera()

    if points and #points > 0 then
        for channel = 1,#points do
            --loop though each side
            for side = 1,#points[channel] do
                for i = 1,#points[channel][side] do
                    local point = points[channel][side][2]

                    if point.y + camera.y > (love.graphics.getHeight() + 100) / screenScale then
                        table.remove(points[channel][side], 1)
                    else
                        break
                    end
                end
            end
        end

        if points[1][1][#points[1][1]].y > -camera.y - 1080 then
            generateNextRiver()
        end
    end
end


function river.drawRiverPoints()
    --loop though each channel
    if points and #points > 0 then
        for channel = 1,#points do
            --loop though each side
            for side = 1,#points[channel] do
                for i = 1,#points[channel][side] do
                    local point = points[channel][side][i]
                    love.graphics.circle("fill", point.x, point.y, 10)
                end
            end
        end
    end
end

function river.draw()
    river.drawRiverPoints()
end



function getRiverData()
    return points
end

return river