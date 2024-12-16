--windSpeed = 500
trailAmount = 80

function spawnTrail(dt)

    trailTime = 1/trailAmount
    if not trailCounter then trailCounter = 0 end

    if trailCounter < trailTime then
        trailCounter = trailCounter + dt*player.speed/50*settings.graphics.particles.value
    else
        while trailCounter > trailTime do
            createTrailParticle()
            createTrailParticle() 
           -- createTrailParticle((player.dir+math.pi)+2*(love.math.random(0,1)*2-1))
            trailCounter = trailCounter - trailTime
        end
    end

end

function createTrailParticle(num)

    local x = player.x + math.cos(player.dir)*25
    local y = player.y + math.sin(player.dir)*25
    local angle

    if num then
        x = player.x --+ math.cos(player.dir+math.sin(num)*0.2)*30
        y = player.y --+ math.sin(player.dir+math.sin(num)*0.2)*30
        angle = num + math.rad(love.math.random(-20,20))
    else
        local dir = math.random(0, 1)
        if dir == 0 then
            dir = -1
        end 
        angle = player.dir+math.pi + math.rad(love.math.random(100,150))*dir
    end


    particles.spawnParticle("trail",x,y,angle)
    if love.math.random(1,5) == 1 then particles.spawnParticle("trail2",x,y,angle) end

end

