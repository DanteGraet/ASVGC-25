local hugeRockShape = love.physics.newCircleShape(50)
local hugeRockImages = {
    love.graphics.newImage("image/obstacle/hugeRock/hugeRock1.png"),
    love.graphics.newImage("image/obstacle/hugeRock/hugeRock2.png"),
    love.graphics.newImage("image/obstacle/hugeRock/hugeRock3.png")
}

for i = 1,#hugeRockImages do
    hugeRockImages[i]:setFilter("nearest", "nearest")
end

local hugeRockObstacle = setmetatable({}, { __index = Obstacle }) 
hugeRockObstacle.__index = hugeRockObstacle

--hugeRockObstacle.xFunc = function()
--    return math.random(-600,600)
--end

function hugeRockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, hugeRockShape)
    setmetatable(obj, self)
    obj.image = hugeRockImages[math.random(1, #hugeRockImages)]
    
    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE
    
    return obj
end

function hugeRockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return hugeRockObstacle