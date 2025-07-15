---windSpeed = 250
local leafAmount
local leafTime
local leafCounter
local function createLeafParticle(windSpeed, leafTimer)
    local x = riverBorders.left-100
    local y = math.random(riverBorders.up,riverBorders.down)
    particles.spawnParticle("leaf",x, y, leafTimer, windSpeed,"top")

end


local function updateSpawn(dt, p, windSpeed, currentZone, transitionZone, transitionPercent, leafTimer)
    local leafAmount

    if transitionZone and currentZone.leafAmount then --if we are in a transition
        leafAmount = quindoc.runIfFunc(currentZone.leafAmount,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.leafAmount,0)*transitionPercent

    elseif currentZone.leafAmount then --just set the leaf amount to what it needs to be
        leafAmount = quindoc.runIfFunc(currentZone.leafAmount,p) or 0
    else
        leafAmount = 0 
    end

    if leafAmount > 0 then
        leafTime = 1/leafAmount
        if not leafCounter then leafCounter = 0 end

        if leafCounter < leafTime then
            leafCounter = leafCounter + dt*settings.graphics.particles.value
        else
            while leafCounter > leafTime do
                createLeafParticle(windSpeed, leafTimer)
                leafCounter = leafCounter - leafTime
            end
        end

    end
end

return updateSpawn
