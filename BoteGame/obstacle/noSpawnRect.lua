local noSpawnCircle = setmetatable({}, { __index = Obstacle }) 
noSpawnCircle.__index = noSpawnCircle


function noSpawnCircle:New(x, y, w, h)

    local obj = {}


    obj = Obstacle:New(x, y, love.physics.newRectangleShape(0, 0, w*pixlesPerPixle, h*pixlesPerPixle), obj.OnCollideWithPlayer)
    setmetatable(obj, self)
    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = obj.OnCollideWithPlayer})
    obj.fixture:setSensor(true)
    obj.body:setType("kinetic")
    
    obj.w = w
    obj.h = h




    return obj
end

function noSpawnCircle:OnCollideWithPlayer(self, collideData)

end

function noSpawnCircle:Draw()
    --[[love.graphics.setLineWidth(10)
    love.graphics.line(player.x, player.y, self.x, self.y)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)]]
end


return noSpawnCircle