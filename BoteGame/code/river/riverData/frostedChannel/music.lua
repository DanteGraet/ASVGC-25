local function stormValleyMusicManager()
    local percentage 
    --if type(zones[1]) == "table" and zones[2].displayName == "Storm Valley" then
    --    percentage = 0 
    --else
    percentage = riverGenerator:GetPercentageThrough(player.y)
    --end
    
    stormish = 0

    if percentage < 0.4 then
        stormish = percentage*2.5
    elseif percentage < 0.8 then
        stormish = 1
    else
        stormish = 1 - 2*((percentage - 0.8) * 5)
    end

    player.stormish = stormish

    local data = {
        0,
        math.max(1-stormish,0),
        math.max(1-stormish,0),
        math.max(1-stormish,0),
        quindoc.clamp(stormish,0,1),
        quindoc.clamp(stormish,0,1),
    }

    return data    
end

return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/mvpRiver/townChordsV2.mp3","stream"),        volume = 0.9, targetVolume = 0.9},
            [2] = {track = love.audio.newSource("music/mvpRiver/snowMelodyV2.mp3","stream"),        volume = 0, targetVolume = 0},
            [3] = {track = love.audio.newSource("music/mvpRiver/valleyChords.mp3","stream"),        volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/mvpRiver/valleyDrums.mp3","stream"),         volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/mvpRiver/stormMelodyV2.mp3","stream"),       volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/mvpRiver/stormDrumsChordsV3.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Glacial Lake"] =        {0.9,0,0,0,0,0},
        ["Ice Plains"] =        {0.9,0.9,0,0,0,0},
        ["Boulder Valley"] =    {0,0.9,0.9,0.9,0,0},
        ["Storm Valley"] =      stormValleyMusicManager,
        ["_Storm Valley"] =      {0.9,0,0,0,0,0},
        ["Wooded Hills"] = {0.7,0,0,0,0,0}
    }
}