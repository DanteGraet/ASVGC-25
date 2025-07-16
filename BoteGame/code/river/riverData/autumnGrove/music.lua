return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/autumnGrove/forestChords.mp3","stream"),        volume = 1, targetVolume = 1},
            [2] = {track = love.audio.newSource("music/autumnGrove/forestStrings.mp3","stream"),        volume = 0, targetVolume = 0},
            [3] = {track = love.audio.newSource("music/autumnGrove/forestLead.mp3","stream"),        volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/autumnGrove/clockworkChords.mp3","stream"),         volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/autumnGrove/clockworkDrums.mp3","stream"),       volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/autumnGrove/ruinsLead.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Wooded Hills"] =         {1,0,0,0,0,0},
        ["Autumn Grove"] =         {1,0.7,1,0,0,1},
        ["Clockwork Ruins"] =      {0,0,0,0.8,0,1},
        ["Clockwork's Core"] = {0,0,0,0.8,1,1},
        ["Autumn Rapids"] =    {1,0.7,1,0,1,1},
        ["Gravelly Plains"] =         {1,0,0,0,0,0},
    }
}