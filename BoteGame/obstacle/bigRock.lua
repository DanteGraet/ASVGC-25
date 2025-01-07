local bigRockShape = love.physics.newCircleShape(25*3)
local bigRockImages = {}

for i = 1, 5 do
    local image = love.graphics.newImage("image/obstacle/bigRock/bigRock"..i..".png")
    table.insert(bigRockImages,image)
end


for i = 1,#bigRockImages do
    bigRockImages[i]:setFilter("nearest", "nearest")
end

local bigRockObstacle = setmetatable({}, { __index = Obstacle }) 
bigRockObstacle.__index = bigRockObstacle

bigRockObstacle.xFunc = function()
    return math.random(-600,600)
end

function bigRockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, bigRockShape)
    setmetatable(obj, self)
    obj.image = bigRockImages[math.random(1, #bigRockImages)]

    obj.dir = math.rad(math.random(1,360))    
    
    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE
    
    return obj
end

function bigRockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return bigRockObstacle