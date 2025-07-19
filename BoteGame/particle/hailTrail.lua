local snowParticle = setmetatable({}, { __index = Particle }) 
snowParticle.__index = snowParticle

function snowParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.size = math.random(4, 10)

    obj.speed = spawnData.speed*0.8
    obj.yVel = love.math.random(-200,200)/1000
    obj.savedWindSpeed = ambiance.windSpeed

    obj.life = 1


    return obj
end

function snowParticle:Update(dt)
    if self.savedWindSpeed < ambiance.windSpeed then
        self.savedWindSpeed = ambiance.windSpeed
    end

    self.x = self.x + self.speed*dt

    self.speed = self.speed-100*dt
    self.life = self.life - dt

   -- particle.yVel = particle.yVel + particle.yAccel*dt*particle.savedWindSpeed

    self.size = self.size - 0.5*dt

    if self.x > love.graphics.getWidth()/2/(GetRiverScale()[1] or screenScale)+100 or self.life < 0 then
        self.delete = true
    end

    --if self.y > riverBorders.down + 100 then
    --    self.y = riverBorders.up - 100
    --end
end

function snowParticle:Draw()
    love.graphics.setColor(1,1,1,0.6*self.life)
    love.graphics.circle("fill", self.x,self.y,self.size)
end

return snowParticle