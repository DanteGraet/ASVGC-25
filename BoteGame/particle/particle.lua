Particle = {}
Particle.__index = Particle


function Particle:New(spawnX,spawnY,spawnAngle,spawnData)

    local obj = setmetatable({}, Particle)

    obj.x = spawnX or 0
    obj.y = spawnY or 0

    obj.angle = spawnAngle or 0


    if spawnData then obj.data = spawnData end

    return obj
end

function Particle:Update(dt)
    if self.x > 2000 then
        self.delete = true
    end
end


function Particle:Draw()
    love.graphics.setColor(1,0,0,0.5)
    love.graphics.circle("fill",self.x,self.y,100)
end

return nil