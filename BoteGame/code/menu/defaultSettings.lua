--Functions required for "click" type buttons
local function ReloadGameState()
    previousGameState = "getRecked"
end

local function PrintAssetTree()
    print("\n\n================= Asset Tree =================")
    dante.printTable(assets)
end

local function OpenSaveFolder()
    love.system.openURL(love.filesystem.getSaveDirectory())
end

local function devCheatyBoat(value, toggle)
    toggle.value = value


    print("cheeaty Boat Toggle")
    if value then
        player.immunity = -1
        player.health = 1000
        player.speed = 100
        player.acceleration = 3000
        player.maxSpeed = 3000
    else
        --Effectuvely reset the player
        player.immunity = 1
    
        player.maxHealth = 5
        player.health = player.maxHealth
        player.deathTime = 0
    
        player.speed = 150
        player.acceleration = 150
        player.maxSpeed = 300
        player.minSpeed = 0
    end
end

-- load each setting as catagories with special order table
return {
    graphics = {
        h_ui = {type = "header", displayName = "User Interface"},
        h_other = {type = "header", displayName = "Other"},


        uiScale = {type = "slider", displayName = "UI Scale", value = 0.5},
        uiSide = {type = "toggle", displayName = "Right UI", value = true},
        uiLock = {type = "toggle", displayName = "Lock UI to 16 X 9", value = false},

        zoneTitles = {type = "toggle", displayName = "Show Biome Titles", value = true},

        particles = {type = "slider", displayName = "Spawn Particles", value = 1},
        lightning = {type = "toggle", displayName = "Lightning", value = true},
        

        fullscreen = {type = "toggle", displayName = "Fullscreen", value = love.window.getFullscreen()},
        showFPS = {type = "toggle", displayName = "Show FPS", value = false},

        shortNumbers = {type = "toggle", displayName = "Short Numbers", value = true},

    },
    audio = {
        masterVolume = {type = "slider", displayName = "Master Volume", value = 0.8},

        h_music = {type = "header", displayName = "Music"},
        musicVolume = {type = "slider", displayName = "Music Volume", value = 0.8},
        ambient = {type = "slider", displayName = "Ambiance Volume", value = 0.8},


    },
    keybinds = {

    },

    -- the player should NEVER have acsess to these :D
    dev = {
        removeSave = {type = "button", displayName = "Delete Save"},
        unlockAll = {type = "button", displayName = "Unlock All"},
        openSaveFolder = {type = "button", displayName = "open Save Folder", func = OpenSaveFolder},
        reloadGamestate = {type = "button", displayName = "Reload Gamestate", func = ReloadGameState},
        printAssetTree = {type = "button", displayName = "Print Asset Tree", func = PrintAssetTree},

        drawHitboxes = {type = "toggle", displayName = "Draw Hitboxes", value = false},
        playerInfo = {type = "toggle", displayName = "Show Player Debug Info", value = false},
        musicInfo = {type = "toggle", displayName = "Show Music Debug Info", value = false}, 

        devCheatyBoat = {type = "toggle", displayName = "Dev Cheaty Boat", value = false, func = devCheatyBoat}, 

        h_ab = {type = "header", displayName = "AB testing"},

        ab_playerCollision = {type = "toggle", displayName = "AB Player sensor", value = false}
    },

    -- Order is here so we load it in at the same time, we can then hvae key, value tables in an ordeer that is not alphabetti-spaghetti.
    order = {
        graphics = {
            "fullscreen",
            "showFPS",

            "h_ui",
            "uiScale",
            "uiSide",
            "uiLock",
            "shortNumbers",

            "h_other",
            "particles",
            "zoneTitles",
            "lightning",
        },
        audio = {
            "masterVolume",

            "musicVolume",
            "ambient",
    
        },
        keybinds = {
    
        },
        dev = {
            "removeSave",
            "unlockAll",
            "openSaveFolder",
            "reloadGamestate",

            "devCheatyBoat",

            "drawHitboxes",
            "playerInfo",
            "musicInfo",


            "h_ab",
            "ab_playerCollision"
        },
    }
}