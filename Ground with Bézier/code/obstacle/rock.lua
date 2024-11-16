local rockShape = love.physics.newCircleShape(10)
local rockImages = {
    love.graphics.newImage("images/obstical/rock/1.png"),
    love.graphics.newImage("images/obstical/rock/2.png"),
    love.graphics.newImage("images/obstical/rock/3.png")
}

for i = 1,#rockImages do
    rockImages[i]:setFilter("nearest", "nearest")
end

rockObstical = setmetatable({}, Obstacle)
rockObstical.__index = rockObstical


-- Constructor for SkillTree
function rockObstical:New(x, y)


    local obj = Obstacle:New(x, y, rockShape)

    obj.image = rockImages[math.random(1, #rockImages)]

    return obj
end