return {
    data = {
        crossFadeSpeed = 0.3,
        tracks = {  -- Starting Values
            [1] = {track = love.audio.newSource("music/mvpRiver/stormDrumsChordsV3.mp3","stream"),  volume = 0, targetVolume = 0},
        },
    },
    zones = {
        ["Title Zone"] = {1,1}
    }
}