music = {} --table for music functions and variables

function music.manager(dt) 

    --play the actual music
    if not musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value ~= 0 then
        for i = 1, #musicTracks do

            musicTracks[i].volume = quindoc.clamp(musicTracks[i].volume,0.001,1)

            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value*0.5)

            musicTracks[i].track:play()
            --play all tracks at once to avoid desync
        end

--        music.bar = -1
--        music.beat = 1
--        music.lastBar = 0
--        music.firstFrameInBar = true   

    elseif musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value == 0 then
        for i = 1, #musicTracks do
            musicTracks[i].track:stop()
        end
    end

    --so this manager manages the other managers. dunno enough about buisness to tell you what that role is called
    if zones and type(zones[1]) == "table" and zones[1].musicManager then
        zones[1].musicManager()
    elseif zones.musicManager then
        zones.musicManager()
    end

    for i = 1, #musicTracks do
--        if musicTracks[i].drumTrack == nil then

            if musicTracks[i].volume ~= musicTracks[i].targetVolume then
                musicTracks[i].volume = quindoc.clamp(musicTracks[i].volume+(music.crossFadeSpeed*dt)*quindoc.sign(musicTracks[i].targetVolume-musicTracks[i].volume),0.001,1)
            end
        
            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value*0.5)

--        elseif music.firstFrameInBar then
--            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value)
--        end

    end

    --[[

    i had an epic system where drum beats would only start on the first beat of the bar.....
    but all this ended up being useless because gamespeed screws everything up
    once i can figure out how to update the counter regardless of gamespeed, pausing etc this can be re-enabled

    --bpm calculations
    if music.bar == -1 then
        music.bar = 1
    else
        music.beat = music.beat + dt*(music.bpm/60)/(gameSpeed or 1)
    end
    
    if music.beat >= music.beatsPerBar+1 then
        music.bar = music.bar + 1
        music.beat = 1
        music.firstFrameInBar = true   
    else
        music.firstFrameInBar = false
    end]]
    
end