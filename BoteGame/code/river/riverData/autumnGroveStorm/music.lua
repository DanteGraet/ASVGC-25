return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/autumnGrove/forestChords.mp3","stream"),        volume = 0.9, targetVolume = 0.9},
            [2] = {track = love.audio.newSource("music/autumnGrove/forestStrings.mp3","stream"),        volume = 0, targetVolume = 0},
            [3] = {track = love.audio.newSource("music/autumnGrove/forestLead.mp3","stream"),        volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/autumnGrove/clockworkChords.mp3","stream"),         volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/autumnGrove/clockworkDrums.mp3","stream"),       volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/autumnGrove/ruinsLead.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Wooded Hills"] =         {0.9,0,0,0,0,0},
        ["Grueling Grove"] =         {0.9,0.65,0.9,0,0,0.9},
        ["Ruins of Regret"] =      {0,0,0,0.8,0,0.9},
        ["Clockwork Catastrophe"] =     {0,0,0,0.8,0.9,0.9},
        ["_Clockwork Catastrophe"] =        {0.9,0.65,0.9,0,0.9,0.9},
        ["Gravelly Plains"] =      {0.9,0,0,0,0,0},
    }
}