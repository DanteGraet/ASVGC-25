require("code.parallaxImage")

local function load()
    testParralax = ParallaxImage:New(500, 500, {{"images/moaigus.png", 0.5},{"images/hmm.png", 0.1}})
end

local function update(dt)
    testParralax:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end

local function draw()
    testParralax:Draw(100, 100, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end




return {
    load = load,
    keypressed = keypressed,
    mousepressed = mousepressed,
    update = update,
    draw = draw,
}