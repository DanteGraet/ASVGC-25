local function load()
    DynamicLoading:New("code/gameStateLoading/riverLoading.lua", 
    {
        {"image/titleScreen/parallax/1.png", 0},
        {"image/titleScreen/parallax/2.png", .1},
        {"image/titleScreen/parallax/3.png", .2},
    }, true)
end

local function update(dt)
   
end

local function mousepressed(x, y, button)

end

local function mousereleased(x, y, button)

end


local function keyreleased(key)

end


local function draw()
    
end


return {
    load = load,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}