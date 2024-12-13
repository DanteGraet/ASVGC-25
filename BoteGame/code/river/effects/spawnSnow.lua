windSpeed = 500
snowAmount = 100


function spawnSnow(dt)

    snowTime = 1/snowAmount
    if not snowCounter then snowCounter = 0 end

    if snowCounter < snowTime then
        snowCounter = snowCounter + dt
    else
        while snowCounter > snowTime do
            createSnowParticle()
            snowCounter = snowCounter - snowTime
        end
    end

end

function createSnowParticle()

    local topOfScreen = player.y - camera.oy
    local relativeBottomOfScreen = love.graphics.getHeight()/GetRiverScale()[1]

    local randY = love.math.random(-100,100+love.graphics.getHeight()/GetRiverScale()[1]) + topOfScreen
    particles.spawnParticle("snow",-love.graphics.getWidth()/2/GetRiverScale()[1]-100,randY)

end

