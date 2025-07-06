local noSpawnCircle = setmetatable({}, { __index = Obstacle }) 
noSpawnCircle.__index = noSpawnCircle


function noSpawnCircle:New(x, y, radius)

    local obj = {}

    if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    obj = Obstacle:New(x, y, love.physics.newCircleShape(radius), obj.OnCollideWithPlayer)
    setmetatable(obj, self)
    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = obj.OnCollideWithPlayer})
    obj.fixture:setSensor(true)

    obj.r = radius




    return obj
end

function noSpawnCircle:OnCollideWithPlayer(self, collideData)

end

function noSpawnCircle:Draw()
   --[[love.graphics.setLineWidth(10)
    love.graphics.line(player.x, player.y, self.x, self.y)
    love.graphics.circle("line", self.x, self.y, self.r)]]
end


return noSpawnCircle