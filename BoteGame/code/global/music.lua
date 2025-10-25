local music = {} --table for music functions and variables

local crossFadeSpeed
local musicTracks
local zoneMusicTarget

function music.unload()
    if musicTracks then
        for i = 1, #musicTracks do
            musicTracks[i].track:stop()
        end
    end

    musicTracks = nil --this MUST be nil and not empty table!! for now.
end

function music.load(musicData)
    music.unload()

    crossFadeSpeed = musicData.crossFadeSpeed or 0.3

    musicTracks = {}
    for i = 1,#musicData.tracks do
        table.insert(musicTracks, {
            track = love.audio.newSource(musicData.tracks[i], "stream"),
            volume = 0, 
            targetVolume = 0
        })
    end

    zoneMusicTarget = musicData.zones
    music.beQuite(nil, true)

    --Actually update the music tracks instantly, might remove later
    music.update(0)
end

function music.beQuite(dt, abrupt)
    if musicTracks then
        for i = 1, #musicTracks do
            musicTracks[i].targetVolume = 0
        end

        if abrupt then
            for i = 1, #musicTracks do
                musicTracks[i].volume = 0
                musicTracks[i].track:setVolume(0.001)
            end
        end
    end
end

function music.update(dt)
    --play the actual music


    if musicTracks ~= nil then

        local globalMusicVolume = (settings and settings.audio.musicVolume.value * settings.audio.masterVolume.value) or 0.5

        if musicTracks[1].track:isPlaying() then
            if globalMusicVolume == 0 then
                for i = 1, #musicTracks do
                    musicTracks[i].track:stop()
                end
            end
        elseif globalMusicVolume > 0 then
            -- restart music tracks
            for i = 1, #musicTracks do
                musicTracks[i].track:stop()
                musicTracks[i].track:play()
            end
        end


        -- get the volume relaed
        local currentZoneName
        if zones and type(zones[1]) == "table" then
            currentZoneName = zones[1].displayName
        elseif zones then
            currentZoneName = zones.displayName
        end

        -- grab target volume/s
        local targets = quindoc.runIfFunc(zoneMusicTarget[currentZoneName]) or {}
        local fadeThisFrame = crossFadeSpeed*dt

        for i = 1, #musicTracks do
            local track = musicTracks[i]
            track.targetVolume = targets[i] or 0.001

            -- Interpolate volume
            if track.volume ~= track.targetVolume then
                local targetVolumeDifference = track.targetVolume-track.volume
                track.volume = track.volume + math.min(fadeThisFrame*quindoc.sign(targetVolumeDifference), targetVolumeDifference)

                -- finally update thee actual volume
                track.track:setVolume(track.volume*0.5 * globalMusicVolume )
            end
        end

    end
end

return music