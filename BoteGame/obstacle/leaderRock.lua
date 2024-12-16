local rockShape = love.physics.newCircleShape(10)
local rockImages = {
    love.graphics.newImage("image/obstacle/rock/1.png"),
    love.graphics.newImage("image/obstacle/rock/2.png"),
    love.graphics.newImage("image/obstacle/rock/3.png")
}

for i = 1,#rockImages do
    rockImages[i]:setFilter("nearest", "nearest")
end

local leaderRockObstacle = setmetatable({}, { __index = Obstacle }) 
leaderRockObstacle.__index = leaderRockObstacle

function leaderRockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, rockShape)
    setmetatable(obj, self)
    obj.image = rockImages[math.random(1, #rockImages)]

    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE

    local angle = math.random(0,1)*(math.pi+1.5) - math.random(1,140)/100

    for i = 1, 5 do

        table.insert(obstacles, assets.obstacle.rock:New(obj.x+200*i*math.cos(angle),obj.y+200*i*math.sin(angle)))

    end
    
    return obj
end

function leaderRockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return leaderRockObstacle