local uiFade = 0
local selectedMenu = "boatSelectMenu"

local menus = {}
local levelSelectScreen

local function load()
    DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", 
        {
            {"image/titleScreen/parallax/1.png", 0},
            {"image/titleScreen/parallax/2.png", .1},
            {"image/titleScreen/parallax/3.png", .2},
        }, true)

    assets.image.levelSelect.background:setFilter("nearest", "nearest")

    uiFade = 0

    menus["boatSelectMenu"] = assets.code.menu.boatSelectMenu():New()
    levelSelectScreen = GraetUi:New()

    levelSelectScreen:AddTextButton("boatSelect", "Pick your bote :D", "left", fontBlack32, 0, 0, 1000, {{1,1,1}, {.8,1,1}, {.4,1,1}})
    levelSelectScreen:GetButtons()["boatSelect"].functions.release = {function() menus["boatSelectMenu"].isOpen = true end}

    levelSelectScreen:AddTextButton("play", "Actually Play", "left", fontBlack32, 0, 300, 1000, {{1,1,1}, {.8,1,1}, {.4,1,1}})
    levelSelectScreen:GetButtons()["play"].functions.release = {function() riverName = "mvpRiver"; gameState = "river" end}
end

local function update(dt)
    levelSelectScreen:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

    menus[selectedMenu]:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

    if menus[selectedMenu].isOpen then
        uiFade = math.min(uiFade + dt*2, 1)
    else
        uiFade = math.max(uiFade - dt*2, 0)    
    end
end

local function mousepressed(x, y, button)
    levelSelectScreen:Click(x/screenScale, y/screenScale)

    menus[selectedMenu]:Click(x/screenScale, y/screenScale)
end

local function mousereleased(x, y, button)
    levelSelectScreen:Release(x/screenScale, y/screenScale)

    menus[selectedMenu]:Release(x/screenScale, y/screenScale)
end


local function keyreleased(key)
   
end


local function draw()
    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 3, 3)

    levelSelectScreen:Draw()

    if uiFade > 0 then
        local f = tweens.sineInOut(uiFade)
        if selectedMenu == "boatSelectMenu" then
            menus["boatSelectMenu"]:Draw(f)
        end
    end
 
end


return {
    load = load,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}