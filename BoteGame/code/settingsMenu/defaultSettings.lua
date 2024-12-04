--Functions required for "click" type buttons
local function ReloadGameState()
    previousGameState = "getRecked"
end

local function PrintAssetTree()
    print("\n\n================= Asset Tree =================")
    dante.printTable(assets)
end

return {
    graphics = {
        testing = {type = "button", displayName = "reloadTest"},
        slider = {type = "slider", displayName = "Slider", value = 0.5},
        slider2 = {type = "slider", displayName = "Slider Again", value = 0.24},
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
        printAssetTree = {type = "button", displayName = "Print Asset Tree", func = PrintAssetTree},
    },

    -- Order is here so we load it in at the same time, we can then hvae key, value tables in an ordeer that is not alphabetti-spaghetti.
    order = {
        graphics = {
            "testing",
            "slider",
            "slider2",
        },
        audio = {
    
        },
        keybinds = {
    
        },
        dev = {
            "removeSave",
            "unlockAll",
            "reloadGamestate",
            "printAssetTree",
        },
    }
}