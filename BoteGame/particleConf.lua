local function loadParticleClasses()

    --Default

    particleClass["default"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX or 0
        particle.y = spawnY or 0

        particle.angle = spawnAngle or 0

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["default"] = function(particle,dt)
        particle.x = particle.x + 100*dt

        if particle.x > 2000 then
            particle.delete = true
        end

    end

    particleDraw["default"] = function(particle)
        love.graphics.setColor(1,0,0,0.5)
        love.graphics.circle("fill",particle.x,particle.y,100)
    end

    --Snow

    particleClass["snow"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX or 0
        particle.y = spawnY or 0

        particle.angle = spawnAngle or 0

        particle.speed = love.math.random(windSpeed*0.75,windSpeed*1.25)
        particle.yVel = love.math.random(-windSpeed/5,windSpeed/5)
        particle.yAccel = love.math.random(-windSpeed/20,windSpeed/20)

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["snow"] = function(particle,dt)

        particle.x = particle.x + particle.speed*dt
        particle.y = particle.y + particle.yVel*dt

        if particle.x > love.graphics.getWidth()/2/GetRiverScale()[1]+100 then
            particle.delete = true
        end

        if particle.y > player.y - camera.oy + love.graphics.getHeight()/GetRiverScale()[1] + 100 then
            particle.y = player.y - camera.oy - 100
            particle.yVel = particle.yVel + particle.yAccel*dt
        end

    end

    particleDraw["snow"] = function(particle)
        love.graphics.setColor(1,1,1,0.9)
        love.graphics.rectangle("fill",particle.x,particle.y,5,5)
    end


end

return loadParticleClasses