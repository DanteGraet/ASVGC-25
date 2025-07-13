---windSpeed = 250
local rainAmount
local rainTime
local rainCounter
local function createRainParticle(windSpeed)
    local x = math.random(-1920, 1920)
    local y = math.random(riverBorders.up - 250, riverBorders.up- 200)
    particles.spawnParticle("rain",x, y, nil, windSpeed,"top")

end


local function updateSpawn(dt, p, windSpeed, currentZone, transitionZone, transitionPercent)
    local rainAmount

    if transitionZone and currentZone.rainAmount then --if we are in a transition
        rainAmount = quindoc.runIfFunc(currentZone.rainAmount,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.rainAmount,0)*transitionPercent

    elseif currentZone.rainAmount then --just set the rain amount to what it needs to be
        rainAmount = quindoc.runIfFunc(currentZone.rainAmount,p) or 0
    else
        rainAmount = 0 
    end

    if rainAmount > 0 then
        rainTime = 1/rainAmount
        if not rainCounter then rainCounter = 0 end

        if rainCounter < rainTime then
            rainCounter = rainCounter + dt*settings.graphics.particles.value
        else
            while rainCounter > rainTime do
                createRainParticle(windSpeed)
                rainCounter = rainCounter - rainTime
            end
        end

    end
end

return updateSpawn
