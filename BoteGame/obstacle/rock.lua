local rockShape = love.physics.newCircleShape(10)
local rockImages = {
    love.graphics.newImage("image/obstacle/rock/1.png"),
    love.graphics.newImage("image/obstacle/rock/2.png"),
    love.graphics.newImage("image/obstacle/rock/3.png")
}

for i = 1,#rockImages do
    rockImages[i]:setFilter("nearest", "nearest")
end

local rockObstacle = setmetatable({}, { __index = Obstacle }) 
rockObstacle.__index = rockObstacle

function rockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, rockShape)
    setmetatable(obj, self)
    obj.image = rockImages[math.random(1, #rockImages)]
    obj.fixture:getUserData().first = false 
    obj.body:setType("kinematic")

    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE
    
    return obj
end

function rockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return rockObstacle