--[[

dP     dP                   oo          dP       dP                   
88     88                               88       88                   
88    .8P .d8888b. 88d888b. dP .d8888b. 88d888b. 88 .d8888b. .d8888b. 
88    d8' 88'  `88 88'  `88 88 88'  `88 88'  `88 88 88ooood8 Y8ooooo. 
88  .d8P  88.  .88 88       88 88.  .88 88.  .88 88 88.  ...       88 
888888'   `88888P8 dP       dP `88888P8 88Y8888' dP `88888P' `88888P' 
                                                                      
]]

require("requirements")

gameState = ""
previousGameState = ""
game = {}

local function loadGameStates()
    local gameStateList = love.filesystem.getDirectoryItems("gameStates")

    for key, value in pairs(gameStateList) do
        local stateName = string.sub(value, 1, -5)
        print("Loading Gamestate: " .. value .. " as " .. stateName)

        game[stateName] = require("gameStates/" .. stateName)

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
print(screenScale) 
function updateScale()
    screenScale = love.graphics.getWidth()/1920

    if love.graphics.getHeight()/1080 < screenScale then
        screenScale = love.graphics.getHeight()/1080
    end
end



--[[

dP                              dP   
88                              88   
88 88d888b. 88d888b. dP    dP d8888P 
88 88'  `88 88'  `88 88    88   88   
88 88    88 88.  .88 88.  .88   88   
dP dP    dP 88Y888P' `88888P'   dP   
            88                       
            dP                       

]]
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

function love.wheelmoved(x,y)
    if game[gameState] and game[gameState].wheelmoved then
        game[gameState].wheelmoved(x, y)
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

function love.textinput(key)
    if game[gameState] and game[gameState].textinput then
        game[gameState].textinput(key)
    end
end



--[[

8888ba.88ba           oo             d8888b. 
88  `8b  `8b                             `88 
88   88   88 .d8888b. dP 88d888b.     aaad8' 
88   88   88 88'  `88 88 88'  `88        `88 
88   88   88 88.  .88 88 88    88        .88 
dP   dP   dP `88888P8 dP dP    dP    d88888P 
                                                                                 
]]
function love.load()
    if game[gameState] and game[gameState].load then
        game[gameState].load()
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

    love.graphics.scale(screenScale)

    love.graphics.translate(sox, 0)


    if game[gameState] and game[gameState].draw then
        game[gameState].draw()
    end

    if drawDebugRuler then quindoc.drawRuler() end

    if lockedAspectRatio then
        love.graphics.setColor(screenBarColour)
        --x bars
        love.graphics.rectangle("fill", 0, 0, -sox, love.graphics.getHeight()/screenScale)
        love.graphics.rectangle("fill", 1920, 0, sox, love.graphics.getHeight()/screenScale)

        --y bars
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/screenScale, -soy)
        love.graphics.rectangle("fill", 0, 1080, love.graphics.getWidth()/screenScale, soy)
    end
end



--[[

 .88888.    dP   dP                         
d8'   `8b   88   88                         
88     88 d8888P 88d888b. .d8888b. 88d888b. 
88     88   88   88'  `88 88ooood8 88'  `88 
Y8.   .8P   88   88    88 88.  ... 88       
 `8888P'    dP   dP    dP `88888P' dP       
                                            
]]

function love.resize(w, h)
    updateScale()
end




--[[

 888888ba  dP                         oo                       a88888b.          dP dP dP                         dP                
 88    `8b 88                                                 d8'   `88          88 88 88                         88                
a88aaaa8P' 88d888b. dP    dP .d8888b. dP .d8888b. .d8888b.    88        .d8888b. 88 88 88d888b. .d8888b. .d8888b. 88  .dP  .d8888b. 
 88        88'  `88 88    88 Y8ooooo. 88 88'  `"" Y8ooooo.    88        88'  `88 88 88 88'  `88 88'  `88 88'  `"" 88888"   Y8ooooo. 
 88        88    88 88.  .88       88 88 88.  ...       88    Y8.   .88 88.  .88 88 88 88.  .88 88.  .88 88.  ... 88  `8b.       88 
 dP        dP    dP `8888P88 `88888P' dP `88888P' `88888P'     Y88888P' `88888P8 dP dP 88Y8888' `88888P8 `88888P' dP   `YP `88888P' 
                         .88                                                                                                        
                     d8888P                                                                                                         
]]

function beginContact(a, b, coll)
    print("col")
	--[[if game[gameState] and game[gameState].beginContact then
        game[gameState].beginContact(a, b, coll)
    end]]
end

function endContact(a, b, coll)
	if game[gameState] and game[gameState].endContact then
        game[gameState].endContact(a, b, coll)
    end
end

function preSolve(a, b, coll)
	if game[gameState] and game[gameState].preSolve then
        game[gameState].preSolve(a, b, coll)
    end
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	if game[gameState] and game[gameState].postSolve then
        game[gameState].postSolve(a, b, coll, normalimpulse, tangentimpulse)
    end
end
