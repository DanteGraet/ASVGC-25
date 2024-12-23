local trailParticle = setmetatable({}, { __index = Particle }) 
trailParticle.__index = trailParticle

function trailParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX + math.random(-8, 8),spawnY + math.random(-8, 8),spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.speed = -player.speed
    obj.life = love.math.random(100,300)/100
    obj.layer = "bottom"

    obj.colour = {0.2*love.math.random(150,200)/100,0.3*love.math.random(150,200)/100,0.6*love.math.random(150,200)/100,1}

    return obj
end

function trailParticle:Update(dt)
    self.x = self.x + self.speed*math.cos(self.angle)*dt
    self.y = self.y + self.speed*math.sin(self.angle)*dt

    if self.life > 0 then
        self.life = self.life - dt
    else
        self.delete = true
    end
end

function trailParticle:Draw()
    self.colour[4] = quindoc.clamp(self.life,0,0.1)
    love.graphics.setColor(self.colour)
    love.graphics.circle("fill",self.x,self.y,8)
end

return trailParticle