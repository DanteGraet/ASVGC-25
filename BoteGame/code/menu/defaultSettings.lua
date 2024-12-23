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
        h_ui = {type = "header", displayName = "User Interface"},
        h_other = {type = "header", displayName = "Other"},


        uiScale = {type = "slider", displayName = "UI Scale", value = 0.5},
        uiSide = {type = "toggle", displayName = "Right UI", value = true},
        uiLock = {type = "toggle", displayName = "Lock UI to 16 X 9", value = false},

        particles = {type = "slider", displayName = "Spawn Particles", value = 0.5},

        fullscreen = {type = "toggle", displayName = "Fullscreen", value = love.window.getFullscreen()}
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

        drawHitboxes = {type = "toggle", displayName = "Draw Hitboxes", value = false},

        h_ab = {type = "header", displayName = "AB testing"},

        ab_playerCollision = {type = "toggle", displayName = "AB Player sensor", value = false}
    },

    -- Order is here so we load it in at the same time, we can then hvae key, value tables in an ordeer that is not alphabetti-spaghetti.
    order = {
        graphics = {
            "fullscreen",

            "h_ui",
            "uiScale",
            "uiSide",
            "uiLock",

            "h_other",
            "particles",
        },
        audio = {
    
        },
        keybinds = {
    
        },
        dev = {
            "removeSave",
            "unlockAll",
            "reloadGamestate",

            "drawHitboxes",


            "h_ab",
            "ab_playerCollision"
        },
    }
}