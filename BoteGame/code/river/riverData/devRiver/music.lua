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
    crossFadeSpeed = 0.3,
    tracks = {  -- Starting Values
        [1] = "music/mvpRiver/townChordsV2.mp3",
        [2] = "music/mvpRiver/snowMelodyV2.mp3",
        [3] = "music/mvpRiver/valleyChords.mp3",
        [4] = "music/mvpRiver/valleyDrums.mp3",
        [5] = "music/mvpRiver/stormMelodyV2.mp3",
        [6] = "music/mvpRiver/stormDrumsChordsV3.mp3",
    },
    zones = {
        ["Autumn Grove"] =        {1,1,0,0,0,0},
    }
}