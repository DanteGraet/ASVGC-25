local tsb = {}
local fontBlack72 = love.graphics.newFont("font/fontBlack.ttf",100)--get trolled

function tsb.CreateButtons(UI)
    local width = love.graphics.getWidth()/screenScale

    local f = font.getFont({"black", 100})
    --Font is temporary i hope.
    UI:AddTextButton("quitButton", "Quit", "center",            {"black", 100}, width*0.2 - 2.5, 460 + f:getHeight()*2, 1920,   {{1,1,1}, {1, 0.6, 0.6}, {1, 0.4, 0.4}})
    UI:AddTextButton("settingsButton", "Settings", "center",    {"black", 100}, width*0.2 - 2.5, 460 + f:getHeight(), 960,      {{1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45}})
    UI:AddTextButton("playButton", "Play", "center",            {"black", 100}, width*0.2 - 2.5, 460 + f:getHeight()*0, 960,    {{1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45}})

    --Temporary fix for adding functions to buttons :D
    UI:GetButtons()["quitButton"].functions.release =       {tsb.quitButtonRelease}
    UI:GetButtons()["settingsButton"].functions.release =   {tsb.settingsButtonRelease}
    UI:GetButtons()["playButton"].functions.release =       {tsb.playButtonRelease}

    -- these buttons can't be acsessed by normal players.
    if DEV then
        --UI:AddTextButton("devDeleteSaveButton", "Lose the game (save file)", "right", love.graphics.newFont(32), 0, 100, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        UI:AddTextButton("devRiverButton", "Dev River", "right", love.graphics.newFont(32), 0, 200, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        --UI:AddTextButton("devUnlockAllButton", "Unlocak All", "right", love.graphics.newFont(32), 0, 300, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        
        UI:GetButtons()["devRiverButton"].functions.release =       {tsb.devRiverButtonRelease}
    end
end


function tsb.quitButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    love.event.quit()
end

function tsb.settingsButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    settingsMenu.isOpen = true
end

function tsb.playButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    gameState = "levelSelect"

    --[[riverName = "mvpRiver"
    gameState = "river"]]
end

function tsb.devRiverButtonRelease()
    riverName = "devRiver"
    gameState = "river"
end





return tsb