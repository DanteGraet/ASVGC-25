local tsb = {}

function tsb.CreateButtons(UI)
    --Font is temporary i hope.
    UI:AddTextButton("quitButton", "QUIT", "center", love.graphics.newFont(64), 100, 100, 1920, {{1,1,1}, {0.8, 0.8, 0.8}, {0.6, 0.6, 0.6}})
    UI:AddTextButton("settingsButton", "Settings", "center", love.graphics.newFont(64), 175, 200, 960, {{1,1,1}, {0.8, 0.8, 0.8}, {0.6, 0.6, 0.6}})
    UI:AddTextButton("playButton", "Play!!", "center", love.graphics.newFont(64), 175, 300, 960, {{1,1,1}, {0.8, 0.8, 0.8}, {0.6, 0.6, 0.6}})

    --Temporary fix for adding functions to buttons :D
    UI:GetButtons()["quitButton"].functions.release =       {tsb.quitButtonRelease}
    UI:GetButtons()["settingsButton"].functions.release =   {tsb.settingsButtonRelease}



    -- these buttons can't be acsessed by normal players.
    if DEV then
        UI:AddTextButton("devDeleteSaveButton", "Lose the game (save file)", "right", love.graphics.newFont(32), 0, 100, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        UI:AddTextButton("devRiverButton", "Dev River (soon™ * inf)", "right", love.graphics.newFont(32), 0, 200, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        UI:AddTextButton("devUnlockAllButton", "Unlocak All", "right", love.graphics.newFont(32), 0, 300, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
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




return tsb