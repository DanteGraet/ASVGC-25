local damageSmokeParticle = setmetatable({}, { __index = Particle }) 
damageSmokeParticle.__index = damageSmokeParticle

function damageSmokeParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX + math.random(-20, 20),spawnY + math.random(-20, 20),spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.life = love.math.random(50,150)/100
    local grey = love.math.random(30,70)/100
    obj.colour = {grey,grey,grey}

    return obj
end

function damageSmokeParticle:Update(dt)
    if self.life > 0 then
        self.life = self.life - dt
    else
        self.delete = true
    end
end

function damageSmokeParticle:Draw()
    self.colour[4] = quindoc.clamp(self.life,0,0.5)
    love.graphics.setColor(self.colour)
    love.graphics.circle("fill",self.x,self.y,5)
end

return damageSmokeParticle