local function playSound(sound, catagory, pitchChange, position, volumeOverride)
    local tempSound

    --create the sound from either a table (pick random) or sound
    if type(sound) == "table" then
        tempSound = sound[math.random(1,#sound)]:clone()
    else
        tempSound = sound:clone()
    end

    -- modify pitch
    local pitch = (pitchChange or 0.05)/2
    tempSound:setPitch(1 + math.random(-pitch*100, pitch*100)/100)

    -- modify volume
    local subVolume = 1
    if catagory and settings.audio[catagory] then
        subVolume = settings.audio[catagory].value
    end
    local volume = (settings.audio.masterVolume.value * subVolume) * volumeOverride or 1
    tempSound:setVolume(volume)

    -- 'move' the sound
    if position then
        if position.absoloute ~= true then
            tempSound:setRelative(true)
        end
        tempSound:setPosition(position.x or 0, position.y or 0, position.z or 0)
    end
    
    tempSound:play()
end


local loopingSounds = {}
local function NewLoopingSound(name, sound, catagory, volume)
    loopingSounds[name] = {}

    --create the sound from either a table (pick random) or sound
    if type(sound) == "table" then
        loopingSounds[name].sound = sound[math.random(1,#sound)]:clone()
    else
        loopingSounds[name].sound = sound:clone()
    end

    -- modify volume
    local subVolume = volume or 1
    if catagory and settings.audio[catagory] then
        subVolume = subVolume * settings.audio[catagory].value
        loopingSounds[name].catagory = catagory
    end
    local volume = settings.audio.masterVolume.value * subVolume
    loopingSounds[name].volume = volume

    loopingSounds[name].sound:setVolume(volume)
    loopingSounds[name].sound:setLooping(true)
    loopingSounds[name].sound:play()

end

local function ModifyLoopingSound(name, data)
    if not loopingSounds[name] then
        return
    end
    for key, value in pairs(data) do
        loopingSounds[name][key] = value

        if key == "volume" or key == "catagory" then
            local subVolume = value or 1
            if loopingSounds[name].catagory and settings.audio[loopingSounds[name].catagory] then
                subVolume = subVolume*settings.audio[loopingSounds[name].catagory].value
            end
            local volume = settings.audio.masterVolume.value * subVolume
            loopingSounds[name].volume = volume
            loopingSounds[name].sound:setVolume(volume)

            --print(name, volume, value)
        elseif key == "pitch" then
            local subVolume = value or 1
            loopingSounds[name].sound:setPitch(subVolume)
        elseif key == "speed" then
            local subVolume = value or 1
            loopingSounds[name].sound:set(subVolume)
        end
    end
end
local function RemoveLoopingSound(name)
    if loopingSounds[name] and loopingSounds[name].sound then 
        loopingSounds[name].sound:stop()
        loopingSounds[name] = nil
    end
end


return {
    playSound = playSound,
    NewLoopingSound = NewLoopingSound,
    ModifyLoopingSound = ModifyLoopingSound,
    RemoveLoopingSound = RemoveLoopingSound,
}