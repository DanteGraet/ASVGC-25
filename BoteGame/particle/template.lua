local templateParticle = setmetatable({}, { __index = Particle }) 
templateParticle.__index = templateParticle

function templateParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    

    return obj
end

function templateParticle:Update(dt)

end

function templateParticle:Draw()

end

return templateParticle