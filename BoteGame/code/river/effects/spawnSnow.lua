---windSpeed = 250
---snowAmount = 100


function spawnSnow(dt)

    if not snowAmount then windSpeed = 0 snowAmount = 0 end

    zones = riverGenerator:GetZone(camera.y, true) 

    if type(zones[1]) == "table" then --if we are in a transition

        snowAmount = (zones[1].snowAmount or 0)*(1-zones[3]) + (zones[2].snowAmount or 0)*zones[3] 
        windSpeed = (zones[1].windSpeed or 100)*(1-zones[3]) + (zones[2].windSpeed or 100)*zones[3] 

    else --just set the snow amount to what it needs to be

        snowAmount = zones.snowAmount or 0
        windSpeed = zones.windSpeed or 100

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

