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
        ["Gravelly Plains"] =        {1,1,0,0,0,0},
        ["Upper Dam"] =    {0,1,1,1,0,0},
        ["The Inlet"] =      {0,0,1,0.7,0,0.3},
        ["Electrical Complex"] = {0,0,0,0,1,1},
        ["River Mouth"] = {1,0,0,0,0,0},
    }
}