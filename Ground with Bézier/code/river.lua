local river = {}
local points = {}
local generator = {}

local canvases = {}
local canvasFillY = -2000
local pixlesPerPixle = 5

local noise1Div = 100
local noise2Div = 50


function river.insideBounds(x, y)
    local dist = math.huge
    local side = false

    for channel = 1,#points do
        local side1 = 0
        local side2 = 0

        local lowPoint = points[channel][1][#points[channel][1]]
        local hightPoint = points[channel][1][1]

        for point = 1,#points[channel][1] do
            if points[channel][1][point].y < y then
                lowPoint = points[channel][1][point]
                if point > 1 then
                    hightPoint = points[channel][1][point-1]
                end
                break
            end
        end

        local yPercentage = (y-lowPoint.y)/(hightPoint.y-lowPoint.y)

        side1 = lowPoint.x + (hightPoint.x - lowPoint.x)*yPercentage


        lowPoint = points[channel][2][#points[channel][2]]
        hightPoint = points[channel][2][1]

        for point = 1,#points[channel][2] do
            if points[channel][2][point].y < y then
                lowPoint = points[channel][2][point]
                if point > 1 then
                    hightPoint = points[channel][2][point-1]
                end
                break
            end
        end
        yPercentage = (y-lowPoint.y)/(hightPoint.y-lowPoint.y)

        side2 = lowPoint.x + (hightPoint.x - lowPoint.x)*yPercentage

        if x > side1 and x < side2 then
            return true, nil
        else 
            if x < side1 then
                if math.abs(side1-x) < dist then
                    side = true
                    dist = math.abs(side1-x)
                end
            else
                if math.abs(side2-x) < dist then
                    side = false
                    dist = math.abs(side2-x)
                end
            end


        end
    end

    return false, side, dist
end


function river.fillCanvasY(canvas, relativeY, y, canvasX)
    love.graphics.setCanvas(canvas)
    for x = 1,canvas:getWidth() do
        local inBounds, side = river.insideBounds(x*pixlesPerPixle + canvasX, y, canvasX)

        if not inBounds then
            --colour
            local noise1 = love.math.noise(x/noise1Div, y/noise1Div/pixlesPerPixle, love.math.getRandomSeed())
            local noise2 = love.math.noise(x/noise2Div, y/noise2Div/pixlesPerPixle, love.math.getRandomSeed() + 10)

            local sand = false
            if side then
                local inBounds, side, dist = river.insideBounds(x*pixlesPerPixle + canvasX + 100, y - 100, canvasX)

                if inBounds then
                    sand = true
                else

                    if math.random(1, 50) > dist then
                        sand = true
                    end
                end
            else
                local inBounds, side, dist = river.insideBounds(x*pixlesPerPixle + canvasX - 100, y + 100, canvasX)

                if inBounds then
                    sand = true
                else

                    if math.random(1, 50) > dist then
                        sand = true
                    end
                end
            end

            --middle range to be ground
            if sand then
                love.graphics.setColor(1,1,0)
            else
                if noise1 > 0.49 and noise1 < 0.51 then
                    love.graphics.setColor(175/255, 121/255, 67/255, 1)
                elseif noise1 < 0.5 then
                    --should be  1-10
                    local n = (noise1 - 0.48)*1000
                    --print(n)
                    if math.random(1, 10) < n then
                        love.graphics.setColor(175/255, 121/255, 67/255, 1)
                    else
                        if noise2*100 > math.random(45, 55) then
                            love.graphics.setColor(67/255,175/255,67/255,1)
                        else
                            love.graphics.setColor(88/255,188/255,88/255,1)

                        end
                    end
                elseif noise1 > 0.5 then
                    --should be  1-10
                    local n = (noise1 - 0.51)*1000
                    --print(n)
                    if math.random(1, 10) > n then

                        love.graphics.setColor(175/255, 121/255, 67/255, 1)
                    else
                        if noise2*100 > math.random(45, 55) then
                            love.graphics.setColor(67/255,175/255,67/255,1)
                        else
                            love.graphics.setColor(88/255,188/255,88/255,1)

                        end
                    end
                end
            end


            love.graphics.points(x, relativeY)
        else

            --water
            love.graphics.setColor(67/255,78/255,175/255,255,1)

            love.graphics.points(x, relativeY)

        end
    end

    love.graphics.setCanvas()

end

function river.addCanvas(y, fill)
    local temp = {
        y = y or 0,
        x = 0
    }
    
    local canvas = love.graphics.newCanvas(math.ceil((love.graphics.getWidth()/screenScale)/pixlesPerPixle), math.ceil((love.graphics.getHeight()/screenScale)/pixlesPerPixle))
    canvas:setFilter("nearest", "nearest")

    temp.x = -canvas:getWidth()*pixlesPerPixle/2

    temp.canvas = canvas

    table.insert(canvases, temp)

    if fill then
        print("filling")
        for i = 1,canvas:getHeight() do
            river.fillCanvasY(canvases[#canvases].canvas, i, canvases[#canvases].y + i*pixlesPerPixle, canvases[#canvases].x)
        end
    end
end


function river.mergePoints(new)
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

    river.addCanvas(0, true)
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

        local range = 100
        if points[1][1][#points[1][1]].y > -camera.y - 1080 - range then
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
    love.graphics.setCanvas()


    love.graphics.setColor(1,1,1,1)
    for i = 1,#canvases do
        love.graphics.draw(canvases[i].canvas, canvases[i].x, canvases[i].y, 0, pixlesPerPixle, pixlesPerPixle)
    end

    --river.drawRiverPoints()
end



function getRiverData()
    return points
end

return river