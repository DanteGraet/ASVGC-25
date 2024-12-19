---windSpeed = 250
---snowAmount = 100


function spawnSnow(dt)

    local p = riverGenerator:GetPercentageThrough(player.y)

    if not snowAmount then windSpeed = 0 snowAmount = 0 end

    local zones = riverGenerator:GetZone(camera.y, true) 

    if type(zones[1]) == "table" and zones[1].snowAmount and zones[2].snowAmount  then --if we are in a transition

        snowAmount = quindoc.runIfFunc(zones[1].snowAmount,p)*(1-zones[3]) + quindoc.runIfFunc(zones[2].snowAmount,p)*zones[3] 
        windSpeed = quindoc.runIfFunc(zones[1].windSpeed,p)*(1-zones[3]) + quindoc.runIfFunc(zones[2].windSpeed,p)*zones[3] 

    elseif zones.snowAmount then --just set the snow amount to what it needs to be

        snowAmount = quindoc.runIfFunc(zones.snowAmount,p) or 0
        windSpeed = quindoc.runIfFunc(zones.windSpeed,p) or 100

    else
        snowAmount = 0 
    end

    if snowAmount > 0 then
        snowTime = 1/snowAmount
        if not snowCounter then snowCounter = 0 end

        if snowCounter < snowTime then
            snowCounter = snowCounter + dt*settings.graphics.particles.value*2
        else
            while snowCounter > snowTime do
                createSnowParticle()
                snowCounter = snowCounter - snowTime
            end
        end
    
    end

end

function createSnowParticle()

    local topOfScreen = player.y - camera.oy
    local relativeBottomOfScreen = love.graphics.getHeight()/GetRiverScale()[1]

    local randY = love.math.random(-100,100+love.graphics.getHeight()/GetRiverScale()[1]) + topOfScreen
    particles.spawnParticle("snow",-love.graphics.getWidth()/2/GetRiverScale()[1]-100,randY)

end

