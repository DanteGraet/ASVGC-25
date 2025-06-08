local uiFade = 0
local selectedMenu = "boatSelectMenu"

local menus = {}
local levelSelectScreen

local levels = {}

local sine = 0

local function load()
    DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", true)
end


local function unload()
    levels = nil
    menus = nil
    levelSelectScreen = nil
end


local function extraLoad()
    uiFade = 0

    levels = {}
    menus = {}
    menus["boatSelectMenu"] = assets.code.menu.boatSelectMenu():New()
    levelSelectScreen = GraetUi:New()

    if assets.code.player.unlocks.levels.frostedChannel then
        table.insert(levels, {
            x = 400,
            y = 310,
            name = "frostedChannel",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    if assets.code.player.unlocks.levels.autumnGrove then
        table.insert(levels, {
            x = 810,
            y = 425,
            name = "autumnGrove",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    if assets.code.player.unlocks.levels.derelictDam then
        table.insert(levels, {
            x = 1260,
            y = 510,
            name = "derelictDam",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    table.insert(levels, {
        x = 600,
        y = 265,
        name = "endless",
        colour = false,
        sine = 0, sineEffect = 0,
        click = false,
    })

end

local function update(dt)
    sine = sine + dt
    --levelSelectScreen:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

    if menus and menus[selectedMenu] then
        menus[selectedMenu]:Update(dt, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)

        if menus[selectedMenu].isOpen then
            uiFade = math.min(uiFade + dt*2, 1)
        else
            uiFade = math.max(uiFade - dt*2, 0)    
        end
    end

    local mx, my = getMouseSoxSoy()
    for i = 1,#levels do
        local l = levels[i]

        local dist = 100 - quindoc.dist(mx, my, l.x, l.y)

        if dist > 0 then
            dist = math.min(dist*10, 100)
        else
            dist = 0
        end
        l.sineEffect = quindoc.clamp(dist/10, l.sineEffect-dt*10, l.sineEffect+dt*10)

        if l.sineEffect == 0 then
            l.sine = 0
        else     
            l.sine = l.sine+dt*3
        end
    end
end

local function mousepressed(x, y, button)
    local mx, my = getMouseSoxSoy()

    --levelSelectScreen:Click(mx, my)

    if menus[selectedMenu] then
        menus[selectedMenu]:Click(mx, my)
    end

    for i = 1,#levels do
        local l = levels[i]

        local dist = quindoc.dist(mx, my, l.x, l.y)

        if dist < 100 then
            l.click = true
        end
    end
end

local function mousereleased(x, y, button)
    local mx, my = getMouseSoxSoy()

    --levelSelectScreen:Release(mx, my)
    if menus[selectedMenu] then
        menus[selectedMenu]:Release(mx, my)
    end

    for i = 1,#levels do
        local l = levels[i]
        local dist = quindoc.dist(mx, my, l.x, l.y)

        if dist < 100 and l.click then
            riverName = l.name
            print(l.name)
            gameState = "river"
        end
        l.click = false
    end
end


local function keyreleased(key)
   
end


local function draw()
    love.graphics.setBackgroundColor(.5,.5,.5)
    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 1920/5120, 1080/2880)

    for i = 1,#levels do
        local l = levels[i]
        local img = assets.image.levelSelect.pin1
        if assets.code.player.unlocks.beatenLevels[l.name] then
            img = assets.image.levelSelect.pin2
        end
        --img = assets.image.levelSelect.flag

        if l.click then
            love.graphics.setColor(.8,.8,.8)
        else
            love.graphics.setColor(1,1,1)
        end

        --love.graphics.draw(img, l.x, l.y - (math.sin(l.sine)+1)*l.sineEffect, 0, 0.375, 0.375, img:getWidth()/2, img:getHeight()/2)
        love.graphics.draw(img, l.x, l.y - (math.sin(l.sine)+1)*l.sineEffect, 0, 0.375, 0.375, img:getWidth()/2, img:getHeight() - 96/2)

    end
    love.graphics.setColor(1,1,1)

    --levelSelectScreen:Draw()

    if uiFade > 0 then
        local f = tweens.sineInOut(uiFade)
        if selectedMenu == "boatSelectMenu" then
            menus["boatSelectMenu"]:Draw(f)
        end
    end
end


return {
    load = load,
    extraLoad = extraLoad,
    unload = unload,
    
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}