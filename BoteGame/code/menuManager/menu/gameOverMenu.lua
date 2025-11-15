local gameOverMenu = {}
local data = {}

local width = 750
local height = 650

gameOverMenu.width = width
gameOverMenu.height = height
gameOverMenu.transitionIn = 0

gameOverMenu.ui = graetUI:newUI()

local function getButton(text, func, ...)
    local currentFont = font.getFont("medium", 50)
    local width = currentFont:getWidth(text)
    local height = currentFont:getHeight(text)
    local button = {
        components = {
            {
                type = "rectangleCollider",
                x = -width/2,
                y = 0,
                sx = currentFont:getWidth(text),
                sy = currentFont:getHeight(),
            },
            {
                type = "textGraphic",
                text = text,
                font = currentFont,

                x = -width/2,
                y = 0,
                colour = {1,1,1},
            },
        },
        data = {
            onRelease = function(obj, button)
                func()
            end,
        }
    }

    return button
end


function gameOverMenu.load()
    data = {}
    local bg = {}
    bg.image = love.graphics.newImage("image/nineSliceTest.png")
    bg.x = -width/2
    bg.y = -height/2
    bg.sx = width
    bg.sy = height
    bg.cornerSize = 84

    local nineSlice = graetUI:getComponent("nineSliceGraphic")
    data.background = nineSlice:new(bg.image, bg.x, bg.y, bg.sx, bg.sy, bg.cornerSize)
    data.closing = false
    
    data.yOffset = 0 

    data.hasPlayerWon = player.health > 0
    
    local restartText = (data.hasPlayerWon and "Play Again") or "Retry"
    gameOverMenu.ui:addCustomObject("restart", -(width-50)/4, height/2-125, {0,0},       getButton(restartText,  function() gameStateManager.setGameState("responsiveLoading", nil, "river") end))
    gameOverMenu.ui:addCustomObject("exit", (width-50)/4, height/2 - 125, {0,0},          getButton("Exit",  function() player.health = 0; gameStateManager.setGameState("responsiveLoading", nil, "levelSelect") end))
end

function gameOverMenu.update(dt)
    if data.closing then
        gameOverMenu.transitionIn = math.max(gameOverMenu.transitionIn - dt*2, 0)
    else
        gameOverMenu.transitionIn = math.min(gameOverMenu.transitionIn + dt*2, 1) 
    end

    local sine = tweens.sineOut(gameOverMenu.transitionIn)
    data.yOffset = 1000 - sine*1000

    if data.closing == true and gameOverMenu.transitionIn == 0 then
        gameOverMenu.remove = true
    end
end

function gameOverMenu.startClose()
    data.closing = true
end

function gameOverMenu.draw()
    local rn = riverName
    if isStorm then
        rn = rn .. "Storm"
    end

    love.graphics.translate(0, data.yOffset)

    data.background:draw(0, 0)


    font.setFont("black", 75)
    local text = (data.hasPlayerWon and "Stage Clear!") or "Game Over"
    love.graphics.printf(text, -width/2, -height/2+40, width, "center")

    local height = 600
    local width = width - 50

    if riverName == "endless" then
        font.setFont("medium", 50)
        love.graphics.printf("Zones:", -width/2 + 10, -height/2 + 230 + 15, width/2, "center")

        local zonesCleared = riverGenerator:GetZone(player.y).zoneCount - 1
        font.setFont("medium", 28)
        love.graphics.printf(zonesCleared.."",-width/2 + 10,-height/2 + 290 + 15,width/2,"center")

        -- this is a scam fix
        if zonesCleared >= 0 then
            currentProfile.beatenLevels["endless"] = true
        end

        if zonesCleared >= 15 then
            currentProfile.beatenLevels["endlessStorm"] = true
        end
    else
        font.setFont("medium", 50)
        love.graphics.printf("Progress:", -width/2 + 10, -height/2 + 230 + 15, width/2, "center")

        local p = player.y/riverGenerator:GetTotalRiverLength()
        local percentageThru = math.floor(p*-100)

        font.setFont("medium", 40)
        love.graphics.printf(quindoc.clamp(percentageThru,0,100).."%",-width/2 + 10,-height/2 + 295 + 15,width/2,"center")
    end


    if savedDisplayName then
        font.setFont("medium", 50)
        love.graphics.printf("Zone:", -width/2 + 10, -height/2 + 360 + 15, width/2, "center")

        font.setFont("medium", 28)
        love.graphics.printf(savedDisplayName,-width/2+ 10,-height/2 + 420 + 15,width/2,"center")
    end


    font.setFont("medium", 50)
    love.graphics.printf("Score:", -width/2 + 10, -height/2 + 100 + 15, width/2, "center")

    font.setFont("medium", 40)
    love.graphics.printf("High Scores:", 20, -height/2 + 115, width/2 - 40, "center")

    local displayNum
    if settings.graphics.shortNumbers.value then
        displayNum = dante.formatNumber(math.floor(math.abs(player.score)), 2)
    else
        displayNum = math.floor(math.abs(player.score))
    end
    love.graphics.printf(displayNum, -width/2+ 10, -height/2 + 160 + 15, width/2, "center")
    
    -- white is there so if the player gets the same score (unlikely like very unlikey) then there will only on white score
    local white = false
    if assets.save.highscore then
        if not assets.save.highscore[rn] then
            assets.save.highscore[rn] = {}
        end
    else
        assets.save.highscore = {rn = {}}
    end
    for i = 1,#assets.save.highscore[rn] do
        local pref = ""
        local suf = ""
        if assets.save.highscore[rn][i] == player.score and not white then
            love.graphics.setColor(0.1,0.1,0.1)
            white = true

            pref = ">"
            suf = "<"
        else
            love.graphics.setColor(0,0,0)   
        end

        local displayNum
        if settings.graphics.shortNumbers.value then
            displayNum = dante.formatNumber(math.floor(math.abs(assets.save.highscore[rn][i])), 2)
        else
            displayNum = math.floor(math.abs(assets.save.highscore[rn][i]))
        end

        love.graphics.printf(pref .. displayNum --[[.."m"]] .. suf, 20, -height/2 + 105 + i*55, width/2 - 40, "center")
    end
end

function gameOverMenu.keyreleased(key)
    if key == "escape" then 
        gameOverMenu.startClose()
    end

    return true
end


return gameOverMenu
