require("code.dynamicLoading")
require("templateLib.graetUi")

local UI

local function load()
    --testParralax = ParallaxImage:New(1920, 1080, {{"images/paralax/temp1.png", 0.05},{"images/paralax/temp2.png", 0.1},{"images/paralax/temp3.png", 0.15}})
    loading = DynamicLoading:New("code/toload.lua", {{"images/paralax/temp1.png", 0.05},{"images/paralax/temp2.png", 0.1},{"images/paralax/temp3.png", 0.15}}, true)


    UI = GraetUi:New()
    UI:AddButton("test1", 100, 100, 100, 100)
    UI:GetButtons()["test1"]:AddText("Test", "left", love.graphics.getFont())
    UI:GetButtons()["test1"]:SetElementColour(1, {1,0,0}, {0,1,0}, {0,0,1})
end

local function update(dt)
    --testParralax:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
    UI:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end

local function mousepressed(x, y, button)
    UI:Click(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end

local function mousereleased(x, y, button)
    UI:Release(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
end

local function draw()
    --testParralax:Draw(0, 0, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

    UI:Draw()
end




return {
    load = load,
    mousereleased = mousereleased,
    mousepressed = mousepressed,
    update = update,
    draw = draw,
}