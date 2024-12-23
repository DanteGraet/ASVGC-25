local scrapParticle = setmetatable({}, { __index = Particle }) 
scrapParticle.__index = scrapParticle

function scrapParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.speed = love.math.random(300,400)
    obj.life = love.math.random(100,300)/100
    obj.scrapImage = math.random(1,5)

    return obj
end

function scrapParticle:Update(dt)
    self.x = self.x + self.speed*math.cos(self.angle)*dt
    self.y = self.y + self.speed*math.sin(self.angle)*dt

    if self.life > 0 then
        self.life = self.life - 3*dt
    else
        self.delete = true
    end

    self.speed = self.speed - 200*dt
end

function scrapParticle:Draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(scrapImages[self.scrapImage],self.x,self.y,self.angle,3*quindoc.clamp(self.life,0,1),3*quindoc.clamp(self.life,0,1),5,5)
end

return scrapParticle