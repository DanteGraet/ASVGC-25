--windSpeed = 500
local trailAmount = 80
local trailTime
local trailCounter

local function createTrailParticle(num)

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


    particles.spawnParticle("trail",x,y,angle, nil, "bottom")
    if love.math.random(1,5) == 1 then particles.spawnParticle("trail2",x,y,angle,nil, "bottom") end

end

function spawnTrail(dt)

    trailTime = 1/trailAmount
    if not trailCounter then trailCounter = 0 end

    if trailCounter < trailTime then
        trailCounter = trailCounter + dt*player.speed/100*settings.graphics.particles.value * tweens.sineInOut(player.beachTimer)
    else
        while trailCounter > trailTime do
            createTrailParticle()
            createTrailParticle() 
           -- createTrailParticle((player.dir+math.pi)+2*(love.math.random(0,1)*2-1))
            trailCounter = trailCounter - trailTime
        end
    end

    --[[player damage smoke --i added this and then didn't like it so :P

    if player.health < 3 and  math.random(1, player.health*10) == 1 then
        particles.spawnParticle("damageSmoke",player.x,player.y)
    end]]

end



