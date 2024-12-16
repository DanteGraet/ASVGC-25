local templateShape = love.physics.newCircleShape(10)
local templateImages = {
    love.graphics.newImage("image/obstacle/rock/1.png"),
    love.graphics.newImage("image/obstacle/rock/2.png"),
    love.graphics.newImage("image/obstacle/rock/3.png")
}

for i = 1,#templateImages do
    templateImages[i]:setFilter("nearest", "nearest")
end

local templateObstacle = setmetatable({}, { __index = Obstacle }) 
templateObstacle.__index = templateObstacle

function templateObstacle:New(x, y)
    local obj = Obstacle:New(x, y, templateShape)
    setmetatable(obj, self)
    obj.image = templateImages[math.random(1, #templateImages)]
    
    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE
    
    return obj
end

function templateObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return templateObstacle