local rockShape = love.physics.newCircleShape(10*3)
local rockImages = {}

for i = 1, 11 do
    local image = love.graphics.newImage("image/obstacle/rock/rock"..i..".png")
    table.insert(rockImages,image)
end

for i = 1,#rockImages do
    rockImages[i]:setFilter("nearest", "nearest")
end

local rockObstacle = setmetatable({}, { __index = Obstacle }) 
rockObstacle.__index = rockObstacle

rockObstacle.xFunc = function()
    return math.random(-800,800)
end

function rockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, rockShape)
    setmetatable(obj, self)
    obj.image = rockImages[math.random(1, #rockImages)]

    obj.dir = math.rad(math.random(1,360))    

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