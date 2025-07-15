local rainParticle = setmetatable({}, { __index = Particle }) 
rainParticle.__index = rainParticle

function rainParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.vel = math.random(500, 600)
    obj.targetHeight = math.random(riverBorders.up - 100, riverBorders.down) 
    obj.plop = -1

    obj.lx = spawnX
    obj.ly = spawnY

    obj.legnth = math.random(1000, 1500)/15000

    obj.angle = math.atan2(obj.vel, obj.data)

    return obj
end

function rainParticle:Update(dt)
    self.x = self.x + self.vel*math.cos(self.angle or math.pi/2)*dt
    self.y = self.y + self.vel*math.sin(self.angle or math.pi/2)*dt

    self.lx = self.x - self.vel*math.cos(self.angle or math.pi/2)*self.legnth
    self.ly = self.y - self.vel*math.sin(self.angle or math.pi/2)*self.legnth

    if self.plop < 0 then

        if self.y > self.targetHeight then
            self.plop = 0

            self.ex = self.x
            self.ey = self.y
        end
    else
        self.plop = self.plop + dt

        if self.plop >= 1 then
            self.delete = true
        end
    end
end

function rainParticle:Draw()
    love.graphics.setLineWidth(3)
    if self.plop < 0 then 
        love.graphics.setColor(.4,.6,.9,  0.5)
        love.graphics.line(self.lx, self.ly, self.x, self.y)
    else
        love.graphics.setColor(.4,.6,.9, tweens.sineInOut(1-self.plop))
        if self.ly < self.ey then
            love.graphics.line(self.lx, self.ly, self.ex, self.ey)
        end
        love.graphics.circle("line", self.ex, self.ey, tweens.sineInOut(self.plop)*15)
    end
end

return rainParticle