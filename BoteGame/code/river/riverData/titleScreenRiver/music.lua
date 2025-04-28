return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/mvpRiver/stormMelodyV2.mp3","stream"),       volume = 1, targetVolume = 1},
            [2] = {track = love.audio.newSource("music/mvpRiver/stormDrumsChordsV3.mp3","stream"),  volume = 1, targetVolume = 1},
        },
    },
    zones = {
        ["Title Zone"] = {1,1}
    }
}