local rl = {}

local state
local nextGamestate

local unloading

local processList
local processIndex

local timer             -- literally for the ...
local ox, oy
local backgroundImage
local fade


local angle = -0.1


function rl.load(gameState, image)
    love.mouse.setVisible(false)

    backgroundImage = love.graphics.newImage(image or "image/loading/autumnGrove.png")

    -- All screen layers used in bote game to prevent scuffed drawing
    local screenLayers = {
        {name = "Back",     scaleType = "fill",     scale = 1,  useOffset = true,   isBoarderd = false,     anchor = {0,0}      },
        {name = "Menu",     scaleType = "fit",      scale = 1,  useOffset = false,  isBoarderd = false,     anchor = {.5,.5}    },
        {name = "",         scaleType = "fill",     scale = 1,  useOffset = true,   isBoarderd = false,     anchor = {0,0}      },
        {name = "UI",       scaleType = "fit",      scale = 1,  useOffset = false,  isBoarderd = false,     anchor = {0,0}      }
    }

    screen.load(screenLayers)

    nextGamestate = gameState
    unloading = true

    timer = 0
    fade = 0
    ox, oy = 0, 0

    state = "loadScreen"

    processList = {}
end

function rl.unload()
    love.mouse.setVisible(true)
end

function rl.AddItem(path, current, original)
    if #path == 1 then
        local file = path[#path]
        local fileName = string.sub(file, 1, #file-4)

        if file:match("%.png$") then
            current[fileName] = love.graphics.newImage(original[1])
            if original[2] == "blur" then
                current[fileName]:setFilter("linear", "linear")

            else
                current[fileName]:setFilter("nearest", "nearest")
            end

        elseif file:match("%.mp3$") or file:match("%.ogg$") then
            current[fileName] = love.audio.newSource(original[1], original[2])

        elseif file:match("%.lua$") then
            if original[2] == "run" then
                if original[3] then
                    current[original[3]] = love.filesystem.load(original[1])()

                else
                    if love.filesystem.getInfo(original[1], "file") then
                        current[fileName] = love.filesystem.load(original[1])()
                    end

                end

            else
                current[fileName] = love.filesystem.load(original[1])

                if original[2] == "addObstacles" then
                    local c = current[fileName]()
                    for i = 1,#c do
                        for name, _ in pairs(c[i].data) do
                            table.insert(processList, #processList+1, {"obstacle/" .. name .. ".lua", "run"})
                        end
                    end
                end
            end

        elseif file:match("%.ttf$") then
            current[fileName .. original[2] or "32"] = love.graphics.newFont(original[1],original[2] or 32)
            
        end
        
    else
        if not current[path[1]] then
            current[path[1]] = {}
        end
        local nextCurrent = current[path[1]]
        table.remove(path, 1)

        rl.AddItem(path, nextCurrent, original)
    end
end

function rl.removeItem(path, current)
    if #path == 1 then
        local file = path[#path]
        current[string.sub(file, 1, #file-4)] = nil        
    else
        if not current[path[1]] then
            current[path[1]] = {}
        end
        local nextCurrent = current[path[1]]
        table.remove(path, 1)

        rl.removeItem(path, nextCurrent)
    end
end

function rl.getMusicMultiplier()
    return tweens.sineIn(1-fade)
end

local updateFunctions = {
    loadScreen = function(dt)
        unloading = true
        -- put the animation back here later

        fade = math.min(fade + dt, 1)

        if fade == 1 then
            unloading = nil
            local previousState = gameStateManager.getGameStateName(true) 
            if love.filesystem.getInfo("code/gameState/" .. previousState .. "/loading.lua") then

                state = "unloadData"
                processList = love.filesystem.load("code/gameState/" .. previousState .. "/loading.lua")()
                processIndex = 1

            elseif love.filesystem.getInfo("code/gameState/" .. nextGamestate .. "/loading.lua") then

                state = "loadData"
                processList = love.filesystem.load("code/gameState/" .. nextGamestate .. "/loading.lua")()
                processIndex = 1

            else
                state = "unloadScreen"
            end
        end
    end,


    unloadData = function()
        if type(processList[processIndex]) == "table" then
            local path = {}
            for match in string.gmatch(processList[processIndex][1], "[^/]+") do
                table.insert(path, match)
            end

            rl.removeItem(path, assets, processList[processIndex])
            print(processList[processIndex][1])
        elseif type(processList[processIndex]) == "function" then
            --processList[processIndex]()
        end

        processIndex = processIndex + 1


        if processIndex > #processList then
            if love.filesystem.getInfo("code/gameState/" .. nextGamestate .. "/loading.lua") then

                state = "loadData"
                processList = love.filesystem.load("code/gameState/" .. nextGamestate .. "/loading.lua")()
                processIndex = 1

            else
                state = "unloadScreen"
            end

            local stateName = gameStateManager.getGameStateName(true)
            local state = gameStateManager.getGameState(stateName)
            if state.hyperUnload then
                state.hyperUnload()
            end
            menuManager.forceClose(nil, true)
        end

    end,


    loadData = function()
        if type(processList[processIndex]) == "table" then
            local path = {}
            for match in string.gmatch(processList[processIndex][1], "[^/]+") do
                table.insert(path, match)
            end

            rl.AddItem(path, assets, processList[processIndex])
        elseif type(processList[processIndex]) == "function" then
            processList[processIndex]()
        end

        processIndex = processIndex + 1


        if processIndex > #processList then
            state = "unloadScreen"
        end
    end,


    unloadScreen = function(dt)
        unloading = false
        fade = math.max(fade - dt, 0)

        if fade == 0 then
            gameStateManager.setGameState(nextGamestate)
        end
    end
}

function rl.update(dt)
    timer = timer + (dt*math.pi)/10
    ox = ox - dt*24 -- dt*(100*math.sin(timer) + 200)/10

    if unloading ~= nil then
        local behindGamestateName = (unloading and gameStateManager.getGameStateName(true)) or nextGamestate
        local behindGamestate = gameStateManager.getGameState(behindGamestateName)

        behindGamestate.update(dt)
    end

    --oy = oy - dt*(100*math.cos(timer))/10
    if fade == 1 then
        ox = ox % backgroundImage:getWidth()
        oy = oy % backgroundImage:getHeight()
    end

    updateFunctions[state](dt)
end

function rl.drawBack()
    if fade < 1 then
        local behindGamestateName = (unloading and gameStateManager.getGameStateName(true)) or nextGamestate
        local behindGamestate = gameStateManager.getGameState(behindGamestateName)
        screen.draw(behindGamestate)
    end
end

function rl.drawMenu(targetWidth, targetHeight, offsetX, offsetY)
    if unloading == true then
        menuManager.draw(targetWidth, targetHeight, offsetX, offsetY)
    end
end

function rl.draw()
    if unloading == false then
        if fade < 1 then
            local behindGamestateName = (unloading and gameStateManager.getGameStateName(true)) or nextGamestate
            local behindGamestate = gameStateManager.getGameState(behindGamestateName)
            screen.draw(behindGamestate)
        end
    end

    love.graphics.origin()
    local screenScale = love.graphics.getWidth()/1920
    if love.graphics.getHeight()/1080 > screenScale then
        screenScale = love.graphics.getHeight()/1080
    end

    love.graphics.scale(screenScale)
    local width = love.graphics.getWidth()/screenScale
    local height = love.graphics.getHeight()/screenScale


    local a = 1

    a = tweens.sineInOut(fade)
   --if loadPercentage < 0.5 then
   --    a = tweens.sineIn(fade)
   --elseif loadPercentage > 1.5 then
   --    a = tweens.sineOut(fade)
   --end
    --love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], a)
    love.graphics.setColor(0,0,0,a)

    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(1,1,1)
    love.graphics.rotate(angle)



    local trigWidth = width * math.cos(-angle) - height * math.sin(-angle)--math.cos(angle + startAngle/2)*legnth
    local trigHeight = width * math.sin(-angle) + height * math.cos(-angle)--math.sin(angle + startAngle/2)*height 

    love.graphics.setColor(1,1,1,a*3)


    for x = math.sin(angle)*height -50 - ox , trigWidth + 100, backgroundImage:getWidth() do
        for y = -(math.cos(angle)*width + math.cos(angle)*height) -50 - oy, trigHeight + 100 -oy, backgroundImage:getHeight() do
            if unloading == true then
                love.graphics.draw(backgroundImage, x -(trigWidth+ backgroundImage:getWidth()*3)*(1-a), y) 

            else
                love.graphics.draw(backgroundImage, x +(trigWidth+ backgroundImage:getWidth()*3)*(1-a), y) 
            end
        end
    end

    love.graphics.origin()
    love.graphics.scale(screenScale)

    font.setFont("black", 64)
    local step = 10
    local dist = 5
    local suf = ""
    for i = 1, (timer*10)%4 do
        suf = suf .. "."
    end
    love.graphics.setColor(0,0,0, a)
    for i = 0,359, step do
        
        local angle = math.rad(i)
        local x = 16 + math.cos(angle)*dist
        local y = height - 100 + math.sin(angle)*dist
        love.graphics.print("Loading" .. suf, x, y)
    end
    love.graphics.setColor(1,1,1, a)
    love.graphics.print("Loading".. suf, 16, height-100)

    love.graphics.setColor(1,1,1, 1)
end

return rl