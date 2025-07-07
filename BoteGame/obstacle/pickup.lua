-- Example Pickup
local pickupShape = love.physics.newCircleShape(20*3)
-- yea, it looks like a tree, i dont have another image rn.
local pickupImage = love.graphics.newImage("image/obstacle/snowyTree/1.png")


local pickupObstacle = setmetatable({}, { __index = Obstacle }) 
pickupObstacle.__index = pickupObstacle


function pickupObstacle:New(x, y)

    local obj = {}
    
    obj = Obstacle:New(x, y, pickupShape, pickupObstacle.OnCollideWithPlayer)
    setmetatable(obj, self)
    obj.image = pickupImage  
    obj.dir = math.rad(math.random(1,360))    

    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = obj.OnCollideWithPlayer})
    obj.body:setType("dynamic")

    return obj
end

function pickupObstacle:OnCollideWithPlayer(self, collideData)
    if not collideData.hasCollided then
        collideData.hasCollided = true

        
        local data = collideData
        data.remove = true
        print("pickedUp")
        dante.printTable(self)

        self:setUserData(data)
    end
end

function pickupObstacle:Update(no, dt)
    if self.body then
        --CODE FOR UPDATING OBSTACLE GOES HERE

        local currentAngle, currentSpeed = river:GetCurrent(self.y)
        if currentAngle then
            self.x = self.x + (math.cos(currentAngle)*currentSpeed * dt) * dt
            self.y = self.y + (math.sin(currentAngle)*currentSpeed * dt) * dt

            self.current = currentAngle
        end
        self.body:setPosition(self.x, self.y)

        Obstacle.Update(self, no, dt)
    end
end

return pickupObstacle