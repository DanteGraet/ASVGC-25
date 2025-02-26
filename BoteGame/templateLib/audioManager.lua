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
    local tempSound = {}

    --create the sound from either a table (pick random) or sound
    if type(sound) == "table" then
        tempSound.sound = sound[math.random(1,#sound)]:clone()
    else
        tempSound.sound = sound:clone()
    end

    -- modify volume
    local subVolume = volume or 1
    if catagory and settings.audio[catagory] then
        subVolume = subVolume * settings.audio[catagory].value
    end
    local volume = settings.audio.masterVolume.value * subVolume
    tempSound.volume = volume

    tempSound.sound:setVolume(volume)
    tempSound.sound:setLooping(true)
    tempSound.sound:play()
end

local function ModifyLoopingSound(name, data)
    for key, value in pairs(data) do
        loopingSounds[key] = value

        if key == "volume" or key == "catagory" then
            local subVolume = loopingSounds[key].volume or 1
            if value.catagory and settings.audio[value.catagory] then
                subVolume = settings.audio[value.catagory].value
            end
            local volume = settings.audio.masterVolume.value * subVolume
            value.volume = volume


        end
    end
end
local function RemoveLoopingSound(name)
    loopingSounds[name].sound:stop()
    loopingSounds[name] = nil
end


return {
    playSound = playSound,
    NewLoopingSound = NewLoopingSound,
    ModifyLoopingSound = ModifyLoopingSound,
    RemoveLoopingSound = RemoveLoopingSound,
}