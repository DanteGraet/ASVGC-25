---windSpeed = 250
local snowAmount
local snowTime
local snowCounter
local function createSnowParticle()
    local randY = love.math.random(riverBorders.down+100,riverBorders.up)
    particles.spawnParticle("snow",-love.graphics.getWidth()/2/(GetRiverScale()[1] or screenScale)-100,randY, nil, nil,"top")

end


local function updateSpawn(dt, p, windSpeed, currentZone, transitionZone, transitionPercent)


    if transitionZone and currentZone.snowAmount then --if we are in a transition
        snowAmount = quindoc.runIfFunc(currentZone.snowAmount,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.snowAmount,0)*transitionPercent

    elseif currentZone.snowAmount then --just set the snow amount to what it needs to be
        snowAmount = quindoc.runIfFunc(currentZone.snowAmount,p) or 0
    else
        snowAmount = 0 
    end

    if snowAmount > 0 then
        snowTime = 1/snowAmount
        if not snowCounter then snowCounter = 0 end

        if snowCounter < snowTime then
            snowCounter = snowCounter + dt*settings.graphics.particles.value
        else
            while snowCounter > snowTime do
                createSnowParticle()
                snowCounter = snowCounter - snowTime
            end
        end

    end
end

return updateSpawn
