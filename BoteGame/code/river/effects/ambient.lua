local a = {}

a.snowUpdate = love.filesystem.load("code/river/effects/spawnSnow.lua")()

a.windSpeed = 0

function a.update(dt)
    -- set up variables
    local p = riverGenerator:GetPercentageThrough(player.y)
    local zoneNames = riverGenerator:GetZone(camera.y, true)
    
    local currentZone
    local transitionZone
    local transitionPercent = zoneNames[3] or nil

    if zoneNames[1] and type(zoneNames[1]) == "table" then
        currentZone = assets.code.river.riverData[riverName].ambiance[zoneNames[1].displayName]
        transitionZone = assets.code.river.riverData[riverName].ambiance[zoneNames[2].displayName]
    else
        currentZone = assets.code.river.riverData[riverName].ambiance[zoneNames.displayName]
    end
    

    if transitionZone  then --if we are in a transition
        a.windSpeed = quindoc.runIfFunc(currentZone.windSpeed,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.windSpeed,0)*transitionPercent
    elseif currentZone.windSpeed then --just set the snow amount to what it needs to be
        a.windSpeed = quindoc.runIfFunc(currentZone.windSpeed,p) or 100
    else
        a.windSpeed = 0
    end


    -- update windSpeed
    a.snowUpdate(dt, p, a.windSpeed, currentZone, transitionZone, transitionPercent)
end


return a