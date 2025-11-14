local levelMenu = {}
local data = {}

local width = 1250
local height = 800

levelMenu.width = width
levelMenu.height = height
levelMenu.transitionIn = 0
levelMenu.ui = graetUI:newUI()

local typeData = {
    frostedChannel = {
        displayName = "Great Valley",
        stage = 1,
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
    },
    autumnGrove = {
        displayName = "Autumn Grove",
        stage = 2,
        yfunc = function(gs)
            return 1500*(gs - 1)
        end,
        extDir = 2,
    },
    derelictDam = {
        displayName = "The Dam",
        stage = 3,
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
    },
    endless = {
        displayName = "Endless",
        stage = "Infinity",       --?
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
    },
}

local function getButton(image, func, ...)
    local button = {
        components = {
            {
                type = "circleCollider",
                x = 0,
                y = 0,
                r = 128+16,
            },
            {
                type = "imageGraphic",
                image = image,
                ox = image:getWidth()/2,
                oy = image:getHeight() - 96/2,
                colour = {1,1,1}
            },
        },
        data = {
            onRelease = function(...)
                -- goto level/ open level menu
                func(...)
            end,
        }
    }

    return button
end


function levelMenu.load(type)
    data = typeData[type]
    data.type = type
    local bg = {}
    bg.image = love.graphics.newImage("image/nineSliceTest.png")
    bg.x = -width/2
    bg.y = -height/2
    bg.sx = width
    bg.sy = height
    bg.cornerSize = 10

    data.background = assets.image.levelSelect.sign[type]
    data.backgroundExtender = assets.image.levelSelect.sign[type .. "Ext"]


    local nineSlice = graetUI:getComponent("nineSliceGraphic")
    data.background2 = nineSlice:new(bg.image, bg.x, bg.y, bg.sx, bg.sy, bg.cornerSize)
    data.closing = false
    
    data.yOffset = 0 

    local b = getButton(assets.image.levelSelect.sign.play, function() gameStateManager.setGameState("responsiveLoading", false, "river", "image/loading/title.png") end)
    levelMenu.ui:addCustomObject("playLevel", 0-256*1.25, 32+256, {0,0}, b)

    b = getButton(assets.image.levelSelect.sign.storm, function() isStorm = true; print("play") end)
    levelMenu.ui:addCustomObject("playStormLevel", 0, 32+256, {0,0}, b)

    b = getButton(assets.image.levelSelect.sign.back, function() levelMenu.startClose() end)
    levelMenu.ui:addCustomObject("back", 256*1.25, 32+256, {0,0}, b)
end


function levelMenu.update(dt)
    if data.closing then
        levelMenu.transitionIn = math.max(levelMenu.transitionIn - dt*2, 0)
    else
        levelMenu.transitionIn = math.min(levelMenu.transitionIn + dt*2, 1) 
    end

    local sine = tweens.sineOut(levelMenu.transitionIn)
    data.yOffset = 1000 - sine*1000

    if data.closing == true and levelMenu.transitionIn == 0 then
        levelMenu.remove = true
    end
end


function levelMenu.startClose()
    data.closing = true
end


function levelMenu.draw()
    data.background2:draw(0, 0 + data.yOffset)

    love.graphics.translate(0, data.yOffset)

    love.graphics.draw(data.background, -960, -540)

    love.graphics.setColor(0.1,0.1,0.2, 0.9)
    font.setFont("black", 32)
    love.graphics.printf("Stage: " .. data.stage, -960, 350 - 64 - 540, 1920, "center")

    font.setFont("black", 128)
    love.graphics.printf(data.displayName, -960, 350 - 64- 540, 1920, "center")

    -- highscores
    if assets.save and assets.save.highscore then
        font.setFont("black", 48)
        local str = "High Score: "
        local displayNum = 0
        if assets.save.highscore[data.type] and assets.save.highscore[data.type][1] then
            if settings.graphics.shortNumbers.value then
                displayNum = dante.formatNumber(math.floor(math.abs(assets.save.highscore[data.type][1] or 0)), 2)
            else
                displayNum = math.floor(math.abs(assets.save.highscore[data.type][1] or 0))
            end
            str = str .. displayNum
        end

        if assets.save.highscore[data.type .. "Storm"] and assets.save.highscore[data.type .. "Storm"][1] then
            
            if settings.graphics.shortNumbers.value then
                displayNum = dante.formatNumber(math.floor(math.abs(assets.save.highscore[data.type .. "Storm"][1] or 0)), 2)
            else
                displayNum = math.floor(math.abs(assets.save.highscore[data.type .. "Storm"][1] or 0))
            end
            str = str .. " | Storm Score: " .. displayNum
        end
        love.graphics.printf(str, -960, 350+128 - 540, 1920, "center")
    end


    love.graphics.setColor(1,1,1)
    -- Draw extentions for poles/beams of qhatever later tm
    local scaleX, scaleY = screen.getScale("Menu")
    local soy = ((love.graphics.getHeight()/scaleX) - 1080) /2 + 540
    local image = assets.image.levelSelect.sign[data.type .. "Ext"]

    local extraHeight = math.ceil((soy-540)/(image:getHeight() - 10))
    for i = 1, extraHeight do
        local h = image:getHeight() - 10
        if typeData[data.type].extDir == 1 then
            love.graphics.draw(image, -1920/2, 1080/2 + (i-1)*h )
        elseif typeData[data.type].extDir == 2 then
            love.graphics.draw(image, -1920/2, -1080/2 - (i)*h + 10)
        end
    end
end


function levelMenu.keyreleased(key)
    if key == "escape" then 
        levelMenu.startClose()
    end

    return true
end

return levelMenu
