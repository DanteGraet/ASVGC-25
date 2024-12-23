local trail2Particle = setmetatable({}, { __index = Particle }) 
trail2Particle.__index = trail2Particle

function trail2Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX + math.random(-8,8) ,spawnY + math.random(-8,8) ,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.life = love.math.random(30,70)/100
    obj.layer = "bottom"
    obj.colour = {love.math.random(80,90)/100,love.math.random(80,90)/100,love.math.random(90,100)/100,1}

    obj.angle = nil

    return obj
end

function trail2Particle:Update(dt)
    if self.life > 0 then
        self.life = self.life - dt
    else
        self.delete = true
    end
end

function trail2Particle:Draw()
    self.colour[4] = quindoc.clamp(self.life,0,0.15)
    love.graphics.setColor(self.colour)
    love.graphics.circle("fill",self.x,self.y,3)
end

return trail2Particle