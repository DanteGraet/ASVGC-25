require("code.dynamicLoading")

local function load()
    --testParralax = ParallaxImage:New(1920, 1080, {{"images/paralax/temp1.png", 0.05},{"images/paralax/temp2.png", 0.1},{"images/paralax/temp3.png", 0.15}})
    loading = DynamicLoading:New("code/toload.lua", {{"images/paralax/temp1.png", 0.05},{"images/paralax/temp2.png", 0.1},{"images/paralax/temp3.png", 0.15}})
    if loading:Run() == "QUIT" then
        love.event.quit()
    end
end

local function update(dt)
    --testParralax:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end

local function draw()
    --testParralax:Draw(0, 0, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end




return {
    load = load,
    keypressed = keypressed,
    mousepressed = mousepressed,
    update = update,
    draw = draw,
}