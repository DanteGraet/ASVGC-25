require("requirements")

gameState = ""
previousGameState = ""
game = {}

local function loadGameStates()
    local gameStateList = love.filesystem.getDirectoryItems("gameState")

    for key, value in pairs(gameStateList) do
        local stateName = string.sub(value, 1, -5)
        print("Loading Gamestate: " .. value .. " as " .. stateName)

        game[stateName] = require("gameState/" .. stateName)

        if type(game[stateName]) == "table" then
            if game[stateName] and game[stateName].isFirst then
                gameState = stateName

                --this one will load anyway.
                previousGameState = stateName
            end
        else
            print("this state is a bool, removing")
            game[stateName] = nil
        end
    end

    if gameState == "" then
        gameState = string.sub(gameStateList[1], 1, -5)
        previousGameState = gameState
    end
end

loadGameStates()

screenScale = love.graphics.getWidth()/1920

function updateScale()
    screenScale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 < screenScale then
        screenScale = love.graphics.getHeight()/1080
    end
end


function love.resize(w, h)
    updateScale()

    if game[gameState] and game[gameState].resize then
        game[gameState].resize(x, y)
    end
end

function love.focus(focus)
    if game[gameState] and game[gameState].focus then
        game[gameState].focus(focus)
    end
end

function love.load()
    if game[gameState] and game[gameState].load then
        game[gameState].load()
    end
end


function love.textinput(key)
    if game[gameState] and game[gameState].textinput then
        game[gameState].textinput(key)
    end
end



function love.wheelmoved(x,y)
    if game[gameState] and game[gameState].wheelmoved then
        game[gameState].wheelmoved(x, y)
    end
end

function love.mousefocus(f)
    if game[gameState] and game[gameState].mousefocus then
        game[gameState].mousefocus(f)
    end
end


function love.keypressed(key)
    if key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())

        love.resize(love.graphics.getWidth(), love.graphics.getHeight())
    end

    if key == "g" and love.keyboard.isDown("lctrl") and DEV then
        drawDebugRuler = not drawDebugRuler
    end
    
    if game[gameState] and game[gameState].keypressed then
        game[gameState].keypressed(key)
    end
end
function love.keyreleased(key)
    if game[gameState] and game[gameState].keyreleased then
        game[gameState].keyreleased(key)
    end
end


function love.mousepressed(mx, my, button)
    if game[gameState] and game[gameState].mousepressed then
        game[gameState].mousepressed(mx, my, button)
    end
end
function love.mousereleased(x, y, button)
    if game[gameState] and game[gameState].mousereleased then
        game[gameState].mousereleased(x, y, button)
    end
end


function love.update(dt)

    if gameState ~= previousGameState then
        if game[gameState] and game[gameState].load then
            game[gameState].load()
        end
        previousGameState = gameState
    end


    if game[gameState] and game[gameState].update then
        game[gameState].update(dt)
    end
end


function love.draw()
    love.graphics.reset()

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    if not game[gameState].noTransform == true then

        love.graphics.scale(screenScale)
        if lockedAspectRatio then
            love.graphics.translate(sox, soy)
        end

    end

    if game[gameState] and game[gameState].draw then
        game[gameState].draw()
    end

    if drawDebugRuler then quindoc.drawRuler() end

    if lockedAspectRatio and not game[gameState].noTransform == true then
        love.graphics.setColor(screenBarColour)
        --x bars
        love.graphics.rectangle("fill", 0, 0, -sox, love.graphics.getHeight()/screenScale)
        love.graphics.rectangle("fill", 1920, 0, sox, love.graphics.getHeight()/screenScale)

        --y bars
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/screenScale, -soy)
        love.graphics.rectangle("fill", 0, 1080, love.graphics.getWidth()/screenScale, soy)
    end
end