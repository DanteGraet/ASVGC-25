local snowParticle = setmetatable({}, { __index = Particle }) 
snowParticle.__index = snowParticle

function snowParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.size = math.random(5, 2)

    obj.speed = love.math.random(75,125)/100
    obj.yVel = love.math.random(-200,200)/1000
    obj.savedWindSpeed = windSpeed


    return obj
end

function snowParticle:Update(dt)
    if self.savedWindSpeed < windSpeed then
        self.savedWindSpeed = windSpeed
    end

    self.x = self.x + self.speed*self.savedWindSpeed*dt
    self.y = self.y + self.yVel*self.savedWindSpeed*dt

   -- particle.yVel = particle.yVel + particle.yAccel*dt*particle.savedWindSpeed

   self.size = self.size - 0.1*dt

    if self.x > love.graphics.getWidth()/2/GetRiverScale()[1]+100 then
        self.delete = true
    end

    if self.y > player.y - camera.oy + love.graphics.getHeight()/GetRiverScale()[1] + 100 then
        self.y = player.y - camera.oy - 100
    end
end

function snowParticle:Draw()
    love.graphics.setColor(1,1,1,0.8)
    love.graphics.circle("fill", self.x,self.y,self.size)
end

return snowParticle