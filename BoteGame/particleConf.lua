local function loadParticleClasses()

    --Default

    particleClass["default"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX or 0
        particle.y = spawnY or 0

        particle.angle = spawnAngle or 0

        particle.layer = "top"

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
        particle.size = math.random(5, 2)

        particle.speed = love.math.random(75,125)/100
        particle.yVel = love.math.random(-200,200)/1000
        --particle.yAccel = love.math.random(-30,30)/100000
        particle.savedWindSpeed = windSpeed

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["snow"] = function(particle,dt)

        if particle.savedWindSpeed < windSpeed then

            particle.savedWindSpeed = windSpeed
        
        end

        particle.x = particle.x + particle.speed*particle.savedWindSpeed*dt
        particle.y = particle.y + particle.yVel*particle.savedWindSpeed*dt

       -- particle.yVel = particle.yVel + particle.yAccel*dt*particle.savedWindSpeed

        particle.size = particle.size - 0.1*dt

        if particle.x > love.graphics.getWidth()/2/GetRiverScale()[1]+100 then
            particle.delete = true
        end

        if particle.y > player.y - camera.oy + love.graphics.getHeight()/GetRiverScale()[1] + 100 then
            particle.y = player.y - camera.oy - 100
        end

    end

    
    particleDraw["snow"] = function(particle)
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.circle("fill", particle.x,particle.y,particle.size)
        --love.graphics.rectangle("fill",particle.x,particle.y,5,5)
    end

    --Player trail

    particleClass["trail"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX + love.math.random(-8,8)
        particle.y = spawnY + love.math.random(-8,8)

        particle.angle = spawnAngle or math.rad(love.math.random(1,360))

        particle.speed = -player.speed

        particle.life = love.math.random(100,300)/100

        particle.layer = "bottom"

        particle.colour = {0.2*love.math.random(150,200)/100,0.3*love.math.random(150,200)/100,0.6*love.math.random(150,200)/100,1}

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["trail"] = function(particle,dt)

        particle.x = particle.x + particle.speed*math.cos(particle.angle)*dt
        particle.y = particle.y + particle.speed*math.sin(particle.angle)*dt

        if particle.life > 0 then
            particle.life = particle.life - dt
        else
            particle.delete = true
        end

    end

    particleDraw["trail"] = function(particle)
        particle.colour[4] = quindoc.clamp(particle.life,0,0.1)
        love.graphics.setColor(particle.colour)
        love.graphics.circle("fill",particle.x,particle.y,8)
    end

    particleClass["trail2"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX + love.math.random(-8,8)
        particle.y = spawnY + love.math.random(-8,8)

--        particle.angle = math.rad(love.math.random(-90,90))-player.dir

--        particle.speed = love.math.random(20,50)

        particle.life = love.math.random(30,70)/100

        particle.layer = "bottom"

        particle.colour = {love.math.random(80,90)/100,love.math.random(80,90)/100,love.math.random(90,100)/100,1}

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["trail2"] = function(particle,dt)

--        particle.x = particle.x + particle.speed*math.cos(particle.angle)*dt
--        particle.y = particle.y + particle.speed*math.sin(particle.angle)*dt

        if particle.life > 0 then
            particle.life = particle.life - dt
        else
            particle.delete = true
        end

    end

    particleDraw["trail2"] = function(particle)
        particle.colour[4] = quindoc.clamp(particle.life,0,0.15)
        love.graphics.setColor(particle.colour)
        love.graphics.circle("fill",particle.x,particle.y,3)
    end





    particleClass["damageSmoke"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX + love.math.random(-20,20)
        particle.y = spawnY + love.math.random(-20,20)

--        particle.angle = math.rad(love.math.random(-90,90))-player.dir

--        particle.speed = love.math.random(20,50)

        particle.life = love.math.random(50,150)/100

        particle.layer = "top"

        local grey = love.math.random(30,70)/100

        particle.colour = {grey,grey,grey}

        if spawnData then particle.data = spawnData end
    end

    particleUpdate["damageSmoke"] = function(particle,dt)

--        particle.x = particle.x + particle.speed*math.cos(particle.angle)*dt
--        particle.y = particle.y + particle.speed*math.sin(particle.angle)*dt

        if particle.life > 0 then
            particle.life = particle.life - dt
        else
            particle.delete = true
        end

    end

    particleDraw["damageSmoke"] = function(particle)
        particle.colour[4] = quindoc.clamp(particle.life,0,0.5)
        love.graphics.setColor(particle.colour)
        love.graphics.circle("fill",particle.x,particle.y,5)
    end




    --scrap

    particleClass["scrap"] = function(particle,spawnX,spawnY,spawnAngle,spawnData)

        particle.x = spawnX + love.math.random(-8,8)
        particle.y = spawnY + love.math.random(-8,8)

        particle.angle = spawnAngle or math.rad(love.math.random(1,360))

        particle.speed = love.math.random(300,400)

        particle.life = love.math.random(100,300)/100

        particle.colour = {1,1,1}

        particle.layer = "top"

        particle.scrapImage = math.random(1,5)

    end

    particleUpdate["scrap"] = function(particle,dt)

        particle.x = particle.x + particle.speed*math.cos(particle.angle)*dt
        particle.y = particle.y + particle.speed*math.sin(particle.angle)*dt

        if particle.life > 0 then
            particle.life = particle.life - 3*dt
        else
            particle.delete = true
        end

        particle.speed = particle.speed - 200*dt

    end

    particleDraw["scrap"] = function(particle)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(scrapImages[particle.scrapImage],particle.x,particle.y,particle.angle,3*quindoc.clamp(particle.life,0,1),3*quindoc.clamp(particle.life,0,1),5,5)
    end



end

return loadParticleClasses