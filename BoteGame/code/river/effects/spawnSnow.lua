---windSpeed = 250
local snowAmount
local snowTime
local snowCounter

local function createSnowParticle()

    local randY = love.math.random(riverBorders.down+100,riverBorders.up)
    particles.spawnParticle("snow",-love.graphics.getWidth()/2/GetRiverScale()[1]-100,randY, nil, nil,"top")

end



function spawnSnow(dt)

    local p = riverGenerator:GetPercentageThrough(player.y)

    if not snowAmount then windSpeed = 0 snowAmount = 0 end

    local zones = riverGenerator:GetZone(camera.y, true) 

    if type(zones[1]) == "table" and zones[1].snowAmount and zones[2].snowAmount  then --if we are in a transition

        snowAmount = quindoc.runIfFunc(zones[1].snowAmount,p)*(1-zones[3]) + quindoc.runIfFunc(zones[2].snowAmount,0)*zones[3] 
        windSpeed = quindoc.runIfFunc(zones[1].windSpeed,p)*(1-zones[3]) + quindoc.runIfFunc(zones[2].windSpeed,0)*zones[3] 

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
            snowCounter = snowCounter + dt*settings.graphics.particles.value
        else
            while snowCounter > snowTime do
                createSnowParticle()
                snowCounter = snowCounter - snowTime
            end
        end
    
    end

end


