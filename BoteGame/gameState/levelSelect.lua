local function load()
    DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", 
        {
            {"image/titleScreen/parallax/1.png", 0},
            {"image/titleScreen/parallax/2.png", .1},
            {"image/titleScreen/parallax/3.png", .2},
        }, true)

    assets.image.levelSelect.background:setFilter("nearest", "nearest")
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
    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 3, 3)
end


return {
    load = load,
    mousefocus = mousefocus,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}