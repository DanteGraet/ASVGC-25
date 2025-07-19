return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/theDam/drone.mp3","stream"),        volume = 1, targetVolume = 1},
            [2] = {track = love.audio.newSource("music/theDam/chords.mp3","stream"),        volume = 0, targetVolume = 0},
            [3] = {track = love.audio.newSource("music/theDam/cymbals.mp3","stream"),        volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/theDam/upperBackingV2.mp3","stream"),         volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/theDam/secondHalfBackingV3.mp3","stream"),       volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/theDam/electricalMelodyV2.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Gravelly Plains"] =        {1,0,0,0,0,0},
        ["Upper Dam"] =              {0.8,0.8,0.6,1,0,0},
        ["The Inlet"] =              {0,0.7,0.7,0,1.1,0},
        ["_The Inlet"] =              {0,0.7,0.7,0,1.1,0},
        ["Electrical Complex"] =     {0,0,1,0,1.2,1.2},
        ["_Electrical Complex"] =     {0,0,1,0,1.2,1.2},
        ["River Mouth"] =            {1,0,0,0,0,0},
    }
}