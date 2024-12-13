function spawnSnow(dt)

    if not snowTime then snowTime = 0.01 end
    if not snowCounter then snowCounter = 0 end
    if not windSpeed then windSpeed = 500 end

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

