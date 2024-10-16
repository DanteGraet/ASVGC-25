local generator = {}

local splines = {}
local splineDist = 10
local scrollDist = 0
local splineSpawner = 0

local function load()
    generator = require("code/generation/base")
    math.randomseed(os.time(), love.timer.getTime())
    love.math.setRandomSeed(os.time(), love.timer.getTime())

    splines = {}

    generator.Load()
    for i = 1,1080, splineDist do
        table.insert(splines, generator.NextSpline(i))
    end
end

local function keypressed(key)
    if DEV then
        if key == "r" then
            load()
        end
    end
end

local function update(dt)
    --scroling
    scrollDist = scrollDist + dt*100
    splineSpawner = splineSpawner + dt*100

    if splineSpawner > splineDist then
        splineSpawner = scrollDist%splineDist
        table.insert(splines, 1, generator.NextSpline(scrollDist))
        table.remove(splines, #splines)
    end
end

local function draw()
    love.graphics.translate(love.graphics.getWidth()/2/screenScale, 0)
    if #splines > 0 then
        for i = 1,#splines do
            love.graphics.circle("fill", splines[i].x, splines[i].y - scrollDist + 1080, 10)
        end
    end
end

return {
    load = load,
    keypressed = keypressed,
    update = update,
    draw = draw,
}