local uiFade = 0
local selectedMenu = ""

local menus = {}
local levelSelectScreen = GraetUi:New()

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

    --DynamicLoading:New("code/gameStateLoading/levelSelectLoading.lua", true, img)
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


    if currentProfile.unlockedLevels.frostedChannel then
        table.insert(levels, {
            x = 400,
            y = 310,
            name = "frostedChannel",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    if currentProfile.unlockedLevels.autumnGrove then
        table.insert(levels, {
            x = 810,
            y = 425,
            name = "autumnGrove",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    if currentProfile.unlockedLevels.derelictDam then
        table.insert(levels, {
            x = 1260,
            y = 510,
            name = "derelictDam",
            colour = false,
            sine = 0, sineEffect = 0,
            click = false,
        })
    end

    if currentProfile.unlockedLevels.endless then
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
        function() gameState = "titleScreen" end
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
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth() /screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
    if levelSelectScreen and levelSelectScreen:GetButtons().back then
        levelSelectScreen:GetButtons().back.x = -sox
        levelSelectScreen:GetButtons().back.y = 1080+soy-150
    end
end

local function update(dt)
    local screenScale = screen.getScale()

    ambiance.update(dt, nil, nil, {audio = {bird = 0.1, water = 1}})

    --currentZone.audio[name].value


    dialouge.update(dt)

    sine = sine + dt

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2


    if menuManager.isMenuOpen() then
        menuManager.update(dt)
    else
        userInterface:checkHover("")
    end

    userInterface:update(dt)
end

local function mousepressed(x, y, button)
    local screenScale = screen.getScale()
   -- dialouge.schedule(assets.image.levelSelect.sign.play, 5)
    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousepressed(mx, my, button) then
        return
    end

    userInterface:toggleClick(true, "")
end

local function mousereleased(x, y, button)
    local screenScale = screen.getScale()
    local mx, my = screen.translatePosition(x, y, "Menu")
    if menuManager.mousereleased(mx, my, button) then
        return
    end

    userInterface:toggleClick(false, "")
end


local function keyreleased(key)
    if menuManager.keyreleased and menuManager.keyreleased(key) then
        return true
    end
    if key == "escape" then
        gameStateManager.setGameState("responsiveLoading", nil, "titleScreen")
    end
end


local function draw()
    love.graphics.setColor(1,1,1)
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    for x = -10, love.graphics.getWidth()/screenScale + 10, 500 do
        for y = -10, love.graphics.getHeight()/screenScale + 10, 500 do
            love.graphics.draw(assets.image.levelSelect.wood, x - sox, y - soy)
        end
    end

    love.graphics.draw(assets.image.levelSelect.background, 0, 0, 0, 1920/5120, 1080/2880)

    love.graphics.setColor(1,1,1)

    dialouge.draw()

    if uiFade > 0 and menus[selectedMenu] then
        local f = tweens.sineInOut(uiFade)
        menus[selectedMenu]:Draw(f)
    end

    --last so graphics.reset() dont change it
    love.graphics.setBackgroundColor(.5,.5,.5)

    userInterface:draw()
end


local function drawMenu(targetWidth, targetHeight, offsetX, offsetY)
    menuManager.draw(targetWidth, targetHeight, offsetX, offsetY)
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
    drawMenu = drawMenu,
}