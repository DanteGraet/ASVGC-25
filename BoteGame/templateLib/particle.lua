local particleTable = {}
local particleClass = {}




local function loadParticles()
    particleTable = {}
    particleClass = {}

    local classes = love.filesystem.getDirectoryItems("particle")

    love.filesystem.load("particle/particle.lua")
    for i = 1,#classes do
        particleClass[string.sub(classes[i], 1, #classes[i]-4)] = love.filesystem.load("particle/" .. classes[i])()
    end
end

local function spawnParticle(spawnClass,spawnX,spawnY,spawnAngle,spawnData, layer)
    local layer = layer
    if layer then
        if not particleTable[layer] then
            particleTable[layer] = {}
        end
    else
        if not particleTable["default"] then
            particleTable["default"] = {}
        end    
        layer = "default"
    end 



    table.insert(particleTable[layer], particleClass[spawnClass]:New(spawnX,spawnY,spawnAngle,spawnData))
end

local function updateParticles(dt)

    for key, value in pairs(particleTable) do
        for i = #value,1, -1 do
            value[i]:Update(dt)

            if value[i].delete then
                table.remove(value, i)
            end
        end
    end
end

local function drawParticles(layer)
    if particleTable[layer] then
        for i = #particleTable[layer], 1, -1 do
            particleTable[layer][i]:Draw()
        end
        love.graphics.setColor(1,1,1,1)
    end
end

return {
    loadParticles = loadParticles,
    spawnParticle = spawnParticle,
    updateParticles = updateParticles,
    drawParticles = drawParticles,
}