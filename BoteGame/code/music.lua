music = {} --table for music functions and variables

local crossFadeSpeed
local musicTracks
local zoneMusicTarget
local lastZone = ""

function music.unload()
    if musicTracks then
        for i = 1, #musicTracks do
            musicTracks[i].track:stop()
        end
    end

    musicTracks = nil --this MUST be nil and not empty table!! for now.
end

function music.load(data)
    local data = data or love.filesystem.load("code/river/riverData/" .. riverName .. "/music.lua")()
  
    crossFadeSpeed = data.data.crossFadeSpeed
    if musicTracks == nil then
        musicTracks = data.data.tracks 
    end
    zoneMusicTarget = data.zones
    music.beQuite(nil, true)

    --Actually update the music tracks instantly, might remove later
    music.manager(0)
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

function music.manager(dt, fadeOut)
    --play the actual music
    if settings and musicTracks ~= nil then
        if not musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value > 0 and settings.audio.masterVolume.value > 0 then
            -- music should be playing but isn't

            --play all tracks at once to "avoid" desync
            for i = 1, #musicTracks do
                musicTracks[i].track:stop()
                musicTracks[i].track:play()
            end

        elseif musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value <= 0 and settings.audio.masterVolume.value <= 0  then
            -- music should not be playing
            for i = 1, #musicTracks do
                musicTracks[i].track:stop()
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

        for i = 1, #musicTracks do
            musicTracks[i].targetVolume = targets[i] or 0.001

            -- Interpolate volume
            if musicTracks[i].volume ~= musicTracks[i].targetVolume then
                musicTracks[i].volume = quindoc.clamp(musicTracks[i].volume+((crossFadeSpeed)*dt)*quindoc.sign(musicTracks[i].targetVolume-musicTracks[i].volume),0.001,1) 
            end
            
            -- finally update thee actual volume
            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value*0.5*settings.audio.masterVolume.value* (fadeOut or 1) )
        end
    end
end