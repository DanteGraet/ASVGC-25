require("requirements")

gameState = ""
previousGameState = ""
game = {}



log = {
}
function log.start()
    log.logs = {}
    log.time = love.timer.getTime()
end

function log.jump()
    log.time = love.timer.getTime()
end

function log.point(name)
    local now = love.timer.getTime()
    table.insert(
        log.logs, 
        {
            name = name,
            time = love.timer.getTime() - log.time
        }
    )
    log.time = love.timer.getTime()
end

function log.stop()
    table.sort(log.logs, function(a,b) return a.time > b.time end)

    --print(log.logs[1].name,  (log.logs[1].time * 1000) .. "ms")
    --print(log.logs[1].name, string.format("%.3f ms", log.logs[1].time * 1000)) -- Rounded to 3 decimals
    local lTable  = {}

    for i = 1,#log.logs do
        local l = log.logs[i]
        table.insert(lTable, string.format("%.3f ms", log.logs[i].time * 1000) .. " -> " .. l.name)
    end

    print("=========================================================")
    dante.printTable(lTable)
end


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
                --previousGameState = stateName
            end
        else
            print("this state is a bool, removing")
            game[stateName] = nil
        end
    end

    if gameState == "" then
        gameState = string.sub(gameStateList[1], 1, -5)
        --previousGameState = gameState
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
        if settingsMenu then
            settingsMenu:toggleFullscreen()
        else
            love.window.setFullscreen( not love.window.getFullscreen())
        end
    end

    if key == "g" and love.keyboard.isDown("lctrl") and DEV then
        drawDebugRuler = not drawDebugRuler
    end

    if key == "m" and love.keyboard.isDown("lctrl") and DEV then
        print(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
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

function love.quit()
    if game[gameState] and game[gameState].unload then
        game[gameState].unload()
    end

    dante.save(assets.code.player.unlocks, "save", "unlocks")
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

function love.mousemoved(x, y, dx, dy, istouch)
    if game[gameState] and game[gameState].mousemoved then
        game[gameState].mousemoved(x, y, dx, dy, istouch)
    end
end

function updateGamestate()
    if gameState ~= previousGameState then
        if previousGameState == "" then
            previousGameState = gameState
        else
            if game[previousGameState] and game[previousGameState].unload then
                --game[previousGameState].unload()
            end

            if game[gameState] and game[gameState].load then
                game[gameState].load()
            end
            previousGameState = gameState
        end
    end
end

function love.update(dt)
    updateGamestate()


    local dt = math.min(dt, 1/10)
    if game[gameState] and game[gameState].update then
        game[gameState].update(dt)
    end

end

function getMouseSoxSoy()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    local mx = love.mouse.getX()/screenScale
    local my = love.mouse.getY()/screenScale

    return mx - sox, my - soy
end

function love.draw(pre)

    love.graphics.reset()

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2



    if not pre then
        if not game[gameState].noTransform == true then

            love.graphics.scale(screenScale)
            if lockedAspectRatio then
                love.graphics.translate(sox, soy)
            end
    
        end

        if game[gameState] and game[gameState].draw then
            game[gameState].draw()
        end
    else
        local p = previousGameState
        if p == "GetWreked" then
            p = gameState
        end

        if game[p] then
            if not game[p].noTransform == true then

                love.graphics.scale(screenScale)
                if lockedAspectRatio then
                    love.graphics.translate(sox, soy)
                end
        
            end
            if game[p] and game[p].draw then
                game[p].draw()
            end
        end
    end

    if drawDebugRuler then quindoc.drawRuler() end

    if lockedAspectRatio and not game[gameState].noTransform == true then
        love.graphics.setColor(screenBarColour)
        --x bars
        --love.graphics.rectangle("fill", 0, 0, -sox, love.graphics.getHeight()/screenScale)
        --love.graphics.rectangle("fill", 1920, 0, sox, love.graphics.getHeight()/screenScale)

        --y bars
        --love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/screenScale, -soy)
        --love.graphics.rectangle("fill", 0, 1080, love.graphics.getWidth()/screenScale, soy)
    end


end