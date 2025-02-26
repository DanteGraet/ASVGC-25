function music.load()
  
    --music.bpm = 90
    --music.beatsPerBar = 4 --i dont plan on composing anything that isn't 4/4 time signiature so this probably won't change
    music.crossFadeSpeed = 0.3


    if not musicTracks then

        musicTracks = { --table for actual music tracks
            [1] = {track = love.audio.newSource("music/mvpRiver/townChordsV2.mp3","stream"), volume = 1, targetVolume = 1},
            [2] = {track = love.audio.newSource("music/mvpRiver/snowMelodyV2.mp3","stream"), volume = 1, targetVolume = 1},
            [3] = {track = love.audio.newSource("music/mvpRiver/valleyChords.mp3","stream"), volume = 0, targetVolume = 0},
            [4] = {track = love.audio.newSource("music/mvpRiver/valleyDrums.mp3","stream"), volume = 0, targetVolume = 0},
            [5] = {track = love.audio.newSource("music/mvpRiver/stormMelodyV2.mp3","stream"), volume = 0, targetVolume = 0},
            [6] = {track = love.audio.newSource("music/mvpRiver/stormDrumsChordsV3.mp3","stream"), volume = 0, targetVolume = 0},
        } 

    end

end