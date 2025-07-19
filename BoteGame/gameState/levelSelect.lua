local uiFade = 0
local selectedMenu = ""

local menus = {}
local levelSelectScreen

local levels = {}

local unlockTimer = 0

local sine = 0



local function load()
    local img = "image/loading/" .. riverName .. ".png"
    -- bootleg fix
    if string.sub(riverName, #riverName - 4, #riverName) == "Storm" then
        img = "image/loading/" .. "storm" .. ".png"
    end
    if previousGameState == "titleScreen" then
        img = "image/loading/title.png"
    end

    DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", true, img)
end


local function unload()
    levels = nil
    menus = nil
    levelSelectScreen = nil
end


local function extraLoad()
    ambiance = love.filesystem.load("code/river/effects/ambient.lua")()

    isStorm = false

    uiFade = 0

    levels = {}
    menus = {}
    menus["boatSelectMenu"] = assets.code.menu.boatSelectMenu():New()
    menus["levelMenu"] = assets.code.menu.levelMenu():New()
    levelSelectScreen = GraetUi:New()
    if not assets.code.player.unlocks.levels then
        print("FIRST")
        assets.code.player.unlocks.levels = {
            frostedChannel = true
        }
    end
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

    if assets.code.player.unlocks.levels.endless then
        table.insert(levels, {
            x = 600,
            y = 265,
            name = "endless",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    levelSelectScreen:AddButton("back", -sox, 1080 + soy - 150, 150, 150)
    levelSelectScreen:GetButtons().back:AddImage(75, 75, love.graphics.newImage("image/titleScreen/titleIco3.png"), nil, nil, nil, 50, 50)
    levelSelectScreen:GetButtons().back.functions.release = {
        function() print("AAA"); gameState = "titleScreen" end
    }
    levelSelectScreen:GetButtons().back.functions.update = {
        function(dt, self)
            if self.mouseMode == "none" then
                self.graphics[1].sx = self.graphics[1].sx + (1-self.graphics[1].sx)*dt*8
                self.graphics[1].sy = self.graphics[1].sx + (1-self.graphics[1].sx)*dt*8
            elseif self.mouseMode == "hover" then
                self.graphics[1].sx = self.graphics[1].sx + (1.1-self.graphics[1].sx)*dt*8
                self.graphics[1].sy = self.graphics[1].sx + (1.1-self.graphics[1].sx)*dt*8
            elseif self.mouseMode == "click" then
                self.graphics[1].sx = self.graphics[1].sx + (0.9-self.graphics[1].sx)*dt*10
                self.graphics[1].sy = self.graphics[1].sx + (0.9-self.graphics[1].sx)*dt*10
            end
        end,

        levelSelectScreen:GetButtons().back
    }

    dialouge.next()
end

local function resize()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    levelSelectScreen:GetButtons().back.x = -sox
    levelSelectScreen:GetButtons().back.y = 1080+soy-150
end

local function update(dt)
    if compRelease then
        if love.keyboard.isDown("lshift") and love.keyboard.isDown("u") then
            unlockTimer = unlockTimer + dt

            if unlockTimer > 1 then
                unlockAllLevels()
                extraLoad()
                dante.save(assets.code.player.unlocks, "save", "unlocks")
                dialouge.schedule("image/levelSelect/dialouge/dialouge5.png", 5)

                unlockTimer = -math.huge
            end
        elseif unlockTimer > -100 then
            unlockTimer = math.max(unlockTimer - dt, 0)
        end
    end


    ambiance.update(dt, nil, nil, {audio = {bird = 0.25, water = 1}})

    --currentZone.audio[name].value


    dialouge.update(dt)

    sine = sine + dt

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    if not menus[selectedMenu] or (menus[selectedMenu].isOpen == false) then
        levelSelectScreen:Update(dt, love.mouse.getX()/screenScale - sox, love.mouse.getY()/screenScale - soy)
    end

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
   -- dialouge.schedule(assets.image.levelSelect.sign.play, 5)
    local mx, my = getMouseSoxSoy()

    if menus[selectedMenu] and menus[selectedMenu].isOpen then
        menus[selectedMenu]:Click(mx, my)
    else
        for i = 1,#levels do
            if levelSelectScreen then
                levelSelectScreen:Click(x/screenScale, y/screenScale)
            end

            local l = levels[i]

            local dist = quindoc.dist(mx, my, l.x, l.y)

            if dist < 100 then
                audioPlayer.playSound(assets.audio.ui.click, "ui", 0.25, nil, 3)
                l.click = true
            end
        end
    end
end

local function mousereleased(x, y, button)
    local mx, my = getMouseSoxSoy()

    
    if menus[selectedMenu] and menus[selectedMenu].isOpen then

        menus[selectedMenu]:Release(mx, my)
    else
        if levelSelectScreen then
            levelSelectScreen:Release(x/screenScale, y/screenScale)
        end

        for i = 1,#levels do
            local l = levels[i]
            local dist = quindoc.dist(mx, my, l.x, l.y)

            if dist < 100 and l.click then
                riverName = l.name
                
                --open sign
                selectedMenu = "levelMenu"
                menus[selectedMenu].type = riverName
                menus[selectedMenu].isOpen = true
                menus[selectedMenu]:GenerateButtons()

                --gameState = "river"
            end
            l.click = false
        end
    end
end


local function keyreleased(key)
   
end


local function draw()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    for x = -10, love.graphics.getWidth()/screenScale + 10, 500 do
        for y = -10, love.graphics.getHeight()/screenScale + 10, 500 do
            love.graphics.draw(assets.image.levelSelect.wood, x - sox, y - soy)
        end
    end

    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 1920/5120, 1080/2880)

    for i = 1,#levels do
        local l = levels[i]
        local img = assets.image.levelSelect.pin1
        if assets.code.player.unlocks.beatenLevels[l.name .. "Storm"] then
            img = assets.image.levelSelect.pin3
        elseif assets.code.player.unlocks.beatenLevels[l.name] then
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

    dialouge.draw()
    levelSelectScreen:Draw()

    if uiFade > 0 and menus[selectedMenu] then
        local f = tweens.sineInOut(uiFade)
        menus[selectedMenu]:Draw(f)
    end

    --last so graphics.reset() dont change it
    love.graphics.setBackgroundColor(.5,.5,.5)
end


return {
    load = load,
    extraLoad = extraLoad,
    unload = unload,

    resize = resize,
    
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}