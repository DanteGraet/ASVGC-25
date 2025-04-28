local a = {}

a.snowUpdate = love.filesystem.load("code/river/effects/spawnSnow.lua")()

a.windSpeed = 0

a.sounds = {
    bird = {
        sound = {
            love.audio.newSource("audio/ambient/bird/1.ogg", "static"),
            love.audio.newSource("audio/ambient/bird/2.ogg", "static"),
            love.audio.newSource("audio/ambient/bird/3.ogg", "static"),
        },
        timer = 0,
        value = 0
    }
}

function a.update(dt, y)
    -- set up variables
    local p = riverGenerator:GetPercentageThrough(y or player.y)
    local zoneNames = riverGenerator:GetZone(y or camera.y, true)
    
    local currentZone
    local transitionZone
    local transitionPercent = zoneNames[3] or nil

    if zoneNames[1] and type(zoneNames[1]) == "table" then
        currentZone = assets.code.river.riverData[riverName].ambiance[zoneNames[1].displayName]
        transitionZone = assets.code.river.riverData[riverName].ambiance[zoneNames[2].displayName]
    else
        currentZone = assets.code.river.riverData[riverName].ambiance[zoneNames.displayName]
    end
    

    if transitionZone and currentZone.windSpeed then --if we are in a transition
        a.windSpeed = quindoc.runIfFunc(currentZone.windSpeed,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.windSpeed,0)*transitionPercent
    elseif currentZone.windSpeed then --just set the snow amount to what it needs to be
        a.windSpeed = quindoc.runIfFunc(currentZone.windSpeed,p) or 100
    else
        a.windSpeed = 0
    end


    -- update particle spawners
    a.snowUpdate(dt, p, a.windSpeed, currentZone, transitionZone, transitionPercent)

    -- sounds

    for name, data in pairs(a.sounds) do
        if currentZone and currentZone.audio then 
            if transitionZone then --if we are in a transition
                data.value = quindoc.runIfFunc(currentZone.audio[name],p)*(1-transitionPercent) + quindoc.runIfFunc(currentZone.audio[name],0)*transitionPercent
            elseif currentZone.audio and currentZone.audio[name] then --just set the snow amount to what it needs to be
                data.value = quindoc.runIfFunc(currentZone.audio[name],p) or 100
            else
                data.value = 0
            end
        end

        if type(data.sound) == "table" then
            -- static


            data.timer = data.timer + dt*5

            if math.floor(math.random(0, data.timer)) > 10-data.value then
                audioPlayer.playSound(data.sound, "ambient", nil, nil, tweens.sineInOut(math.min(data.value/10, 1)))
                data.timer = 0
            end
        else
            -- Looping
            if data.value > 0 then
                if not data.playing then
                    audioPlayer.NewLoopingSound("ambiance_" .. name, data.sound, "ambient", data.value)
                end

                audioPlayer.ModifyLoopingSound("ambiance_" .. name, {volume = data.value/10})

            else
                if data.playing == true then
                    audioPlayer.RemoveLoopingSound("ambiance_" .. name)
                end
            end
        end
    end
end


return a