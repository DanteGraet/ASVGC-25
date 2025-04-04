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

    if assets.code.player.unlocks.levels.frostedChannel then
        levelSelectScreen:AddButton("frostedChannel", 290 - 64, 545 - 128, 128, 128, "default")
        levelSelectScreen:GetButtons()["frostedChannel"]:AddImage(0, 0, assets.image.levelSelect.flag)
        levelSelectScreen:GetButtons()["frostedChannel"]:SetElementColour({.6,.2,.2}, {.8,.1,.1}, {.8,0,0})
        levelSelectScreen:GetButtons()["frostedChannel"].functions.release = {function() riverName = "frostedChannel"; gameState = "river" end}
    end

    if assets.code.player.unlocks.levels.autumnGrove then
        levelSelectScreen:AddButton("autumnGrove", 735 - 64, 452 - 128, 128, 128, "default")
        levelSelectScreen:GetButtons()["autumnGrove"]:AddImage(0, 0, assets.image.levelSelect.flag)
        levelSelectScreen:GetButtons()["autumnGrove"]:SetElementColour({.6,.2,.2}, {.8,.1,.1}, {.8,0,0})
        levelSelectScreen:GetButtons()["autumnGrove"].functions.release = {function() riverName = "autumnGrove"; gameState = "river" end}
    end

    if assets.code.player.unlocks.levels.derelictDam then
        levelSelectScreen:AddButton("derelictDam", 1230 - 64, 565 - 128, 128, 128, "default")
        levelSelectScreen:GetButtons()["derelictDam"]:AddImage(0, 0, assets.image.levelSelect.flag)
        levelSelectScreen:GetButtons()["derelictDam"]:SetElementColour({.6,.2,.2}, {.8,.1,.1}, {.8,0,0})
        levelSelectScreen:GetButtons()["derelictDam"].functions.release = {function() riverName = "derelictDam"; gameState = "river" end}
    end


    levelSelectScreen:AddTextButton("boatSelect", "Pick your bote :D", "left", fontBlack32, 0, 0, 1000, {{1,1,1}, {.8,1,1}, {.4,1,1}})
    levelSelectScreen:GetButtons()["boatSelect"].functions.release = {function() menus["boatSelectMenu"].isOpen = true end}


    --levelSelectScreen:AddTextButton("frostedChannel", "Actually Play", "left", fontBlack32, 0, 300, 1000, {{1,1,1}, {.8,1,1}, {.4,1,1}})

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
    love.graphics.setBackgroundColor(.5,.5,.5)
    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 1920/5120, 1080/2880)

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