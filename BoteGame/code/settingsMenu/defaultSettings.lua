--Functions required for "click" type buttons
local function ReloadGameState()
    previousGameState = "getRecked"
end

return {
    graphics = {
        testing = {type = "button", displayName = "reloadTest"},
        slider = {type = "slider", displayName = "Slider", value = 0.5}
    },
    audio = {

    },
    keybinds = {

    },

    -- the player should NEVER have acsess to these :D
    dev = {
        removeSave = {type = "button", displayName = "Delete Save"},
        unlockAll = {type = "button", displayName = "Unlock All"},
        reloadGamestate = {type = "button", displayName = "Reload Gamestate", func = ReloadGameState},
    },

    -- Order is here so we load it in at the same time, we can then hvae key, value tables in an ordeer that is not alphabetti-spaghetti.
    order = {
        graphics = {
            "testing",
            "slider",
        },
        audio = {
    
        },
        keybinds = {
    
        },
        dev = {
            "removeSave",
            "unlockAll",
            "reloadGamestate"
        },
    }
}