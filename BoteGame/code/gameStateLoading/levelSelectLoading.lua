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


table.insert(l, function() ambiance = love.filesystem.load("code/river/effects/ambient.lua")() end)

return l