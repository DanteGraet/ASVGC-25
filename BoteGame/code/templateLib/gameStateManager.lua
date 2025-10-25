local currentGameState = ""
local nextGamestate = ""
local previousGameState = ""
local reload = false
local gameStates = {}

local loadParam

gameStateManager = {}


function gameStateManager.setGameState(gameState, forceReload, ...)
    nextGamestate = gameState
    loadParam = ...  or nil
    reload = forceReload
end

function gameStateManager.getGameStateName(getPrevious)
    return ( getPrevious and previousGameState ) or currentGameState
end

function gameStateManager.getGameState(stateName)
    return gameStates[stateName or currentGameState]
end

function gameStateManager.updateGameState()
    if currentGameState ~= nextGamestate or reload then
        
        if gameStates[currentGameState] and gameStates[currentGameState].unload then gameStates[currentGameState].unload() end
        --[[if currentGameState == nextGamestate then
            -- reloading
            if gameStates[currentGameState] and gameStates[currentGameState].unload then gameStates[currentGameState].unload() end
        else
            -- unloading
            if gameStates[previousGameState] and gameStates[previousGameState].unload then gameStates[previousGameState].unload() end
        end]]
        
        if gameStates[nextGamestate].load then gameStates[nextGamestate].load((type(loadParam) == "table" and love.data.unpack(loadParam)) or loadParam) end

        previousGameState = currentGameState
        currentGameState = nextGamestate

        reload = false

        return gameStates[currentGameState]
    end

    return nil
end



-- initially load all game states in gameState folder
local gameStatePath = "code/gameState/"
if isServer then
    gameStatePath = "server/gamestate/"
end
local gameStateList = love.filesystem.getDirectoryItems(gameStatePath)

for _, state in pairs(gameStateList) do
    -- remove the ".lua"
    local stateName = state:gsub("%.lua$", "")

    gameStates[stateName] = require(gameStatePath .. stateName)
    debug.print("[gameStateManager] Loading game state " .. stateName)

    if type(gameStates[stateName]) == "table" then
        if gameStates[stateName] and gameStates[stateName].isFirst then
            currentGameState = stateName
            gameStateManager.setGameState(stateName, true)
        end
    else
        gameStates[stateName] = nil
        debug.print("[gameStateManager] unloading game state " .. stateName)
    end
end