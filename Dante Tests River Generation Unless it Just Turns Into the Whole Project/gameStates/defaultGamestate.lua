local generator = {}

local splines = {}
local autoScroll = true
local splineDist = 5
local scrollDist = 0
local splineSpawner = 0

local function load()
    generator = require("code/generation/base")
    math.randomseed(os.time(), love.timer.getTime())
    love.math.setRandomSeed(os.time(), love.timer.getTime())

    splines = {}

    generator.Load()
    for i = 1,1080, splineDist do
        table.insert(splines, generator.NextSpline(i, splines[#splines]))
    end
end

local function keypressed(key)
    if DEV then
        if key == "r" then
            load()
        end
        if key == "s" then
            autoScroll = not autoScroll
        end
        if autoScroll == false and key == "g" then

            scrollDist = scrollDist - splineDist
            splineSpawner = splineSpawner - splineDist

            splineSpawner = -scrollDist%splineDist
            table.insert(splines, 1, generator.NextSpline(scrollDist, splines[1]))
            table.remove(splines, #splines)

        end
    end
end

local function update(dt)
    --scroling
    if autoScroll then
        scrollDist = scrollDist - dt*100
        splineSpawner = splineSpawner - dt*100

        if splineSpawner < -splineDist then
            splineSpawner = -scrollDist%splineDist
            table.insert(splines, 1, generator.NextSpline(scrollDist, splines[1]))
            table.remove(splines, #splines)
        end
    end
end

local function draw()
    love.graphics.translate(love.graphics.getWidth()/2/screenScale, 0)

    if #splines > 0 then
        for i = 1,#splines do
            for j = 1,#splines[i] do
                love.graphics.setColor(1,1,1)

                love.graphics.circle("fill", splines[i][j].x, splines[i][j].y - scrollDist, 10)

                love.graphics.setColor(1,0,0, 0.5)
                love.graphics.circle("fill", splines[i][j].x, splines[i][j].rel - scrollDist, 10)

                love.graphics.line(splines[i][j].x, splines[i][j].y- scrollDist, splines[i][j].x, splines[i][j].rel- scrollDist)


                love.graphics.setColor(0,1,1)

                love.graphics.line(splines[i][j].x, splines[i][j].y- scrollDist, splines[i][j].x + math.cos(splines[i][j].dir)*100, splines[i][j].y- scrollDist + math.sin(splines[i][j].dir)*100)

            end
        end
    end
end

return {
    load = load,
    keypressed = keypressed,
    update = update,
    draw = draw,
}