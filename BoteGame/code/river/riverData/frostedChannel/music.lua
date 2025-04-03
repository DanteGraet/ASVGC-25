local function stormValleyMusicManager()
    local percentage 
    if type(zones[1]) == "table" and zones[2].displayName == "Storm Valley" then
        percentage = 0 
    else
        percentage = riverGenerator:GetPercentageThrough(player.y)
    end
    
    local stormish

    if percentage < 0.6 then
        stormish = quindoc.clamp(2*percentage*1.66,0,2)
    elseif percentage > 0.8 then
        stormish = 2 - quindoc.clamp(4*((percentage-0.8) * 5),0,2)
    else
        stormish = 2
    end

    local data = {
        0,
        math.max(1-stormish,0),
        math.max(1-stormish,0),
        math.max(1-stormish,0),
        math.max(stormish-1,0),
        quindoc.clamp(stormish,0,1),
    }

    return data    
end

return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/mvpRiver/townChordsV2.mp3","stream"),        volume = 1, targetVolume = 1},
            [2] = {track = love.audio.newSource("music/mvpRiver/snowMelodyV2.mp3","stream"),        volume = 1, targetVolume = 1},
            [3] = {track = love.audio.newSource("music/mvpRiver/valleyChords.mp3","stream"),        volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/mvpRiver/valleyDrums.mp3","stream"),         volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/mvpRiver/stormMelodyV2.mp3","stream"),       volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/mvpRiver/stormDrumsChordsV3.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Ice Plains"] =        {1,1,0,0,0,0},
        ["Boulder Valley"] =    {0,1,1,1,0,0},
        ["Storm Valley"] =      stormValleyMusicManager,
        ["Coniferous Highlands"] = {1,0,0,0,0,0}
    }
}