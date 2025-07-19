return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/autumnGrove/forestChords.mp3","stream"),  volume = 0.7, targetVolume = 0.7},
            [2] = {track = love.audio.newSource("music/autumnGrove/forestStrings.mp3","stream"),  volume = 0.5, targetVolume = 0.5},
        },
    },
    zones = {
        ["Title Zone"] = {0.7,0.5}
    }
}