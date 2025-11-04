local l = {
    
    {"image/levelSelect/background.png", "blur"},
    --{"image/levelSelect/flag.png"},

    {"image/levelSelect/pin1.png", "blur"},
    {"image/levelSelect/pin2.png", "blur"},
    {"image/levelSelect/pin3.png", "blur"},

    {"image/levelSelect/wood.png", "blur"},


--    {"image/levelSelect/flag.png"},

    {"image/levelSelect/sign/autumnGrove.png"},
    {"image/levelSelect/sign/derelictDam.png"},
    {"image/levelSelect/sign/endless.png"},
    {"image/levelSelect/sign/frostedChannel.png"},

    
    {"image/levelSelect/sign/autumnGroveExt.png"},
    {"image/levelSelect/sign/derelictDamExt.png"},
    {"image/levelSelect/sign/endlessExt.png"},
    {"image/levelSelect/sign/frostedChannelExt.png"},

    -- surely quindoc will make more buttons right?
    {"image/levelSelect/sign/play.png"},
    {"image/levelSelect/sign/storm.png"},
    {"image/levelSelect/sign/lock.png"},
    {"image/levelSelect/sign/back.png"},


    {"code/menu/levelMenu.lua"},

    {"code/menu/boatSelectMenu.lua"},
    {"code/player/playerData.lua", "run"}

}

table.insert(l, function()
    local screenLayers = {{
        name = "",
        scaleType = "fit",
        scale = 1,
        useOffset = true,
        isBoarderd = false,
        anchor = {0,0}
    }}
    screen.load(screenLayers)

end)


table.insert(l, function() ambiance = love.filesystem.load("code/river/effects/ambient.lua")() end)

table.insert(l, function()
    local generateButton = love.filesystem.load("code/gameState/levelSelect/levelButton.lua")()
    userInterface = {}
    userInterface = graetUI:newUI()

    if assets.code.player.unlocks.levels.frostedChannel then
        userInterface:addCustomObject("frostedChannel",  400,     310,   {0,0}, generateButton("frostedChannel"))
    end

    if assets.code.player.unlocks.levels.autumnGrove then
        userInterface:addCustomObject("autumnGrove",  810,     425,   {0,0}, generateButton("autumnGrove"))
    end

    if assets.code.player.unlocks.levels.derelictDam then
        userInterface:addCustomObject("derelictDam",  1260,     510,   {0,0}, generateButton("derelictDam"))
    end

    if assets.code.player.unlocks.levels.endless then
        userInterface:addCustomObject("endless",  600,     265,   {0,0}, generateButton("endless"))
    end

end)

return l