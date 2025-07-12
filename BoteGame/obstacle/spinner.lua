-- you change the size later
local centerShape = love.physics.newCircleShape(25)
-- you can make this a tryangle later, I dont care.
local bladePoints = {
    {0, 10},
    {170, 10},
    {180, -10},
    {0, -10},
}

-- genrate blade shapes
local bladeShapes = {}
local bladeCount = 3
for i = 1,bladeCount do
    -- full rev * percentage --> i/max
    local angle = math.pi*2  * (i/bladeCount)

    local vertecies = {}

    for j = 1,#bladePoints do
        -- atan2 (y, x)
        local oldAngle = math.atan2(bladePoints[j][2], bladePoints[j][1])
        local dist = quindoc.pythag(bladePoints[j][1], bladePoints[j][2])

        local newAngle = oldAngle + angle
        local newX = math.cos(newAngle) * dist
        local newY = math.sin(newAngle) * dist
        table.insert(vertecies, newX)
        table.insert(vertecies, newY)
    end
    dante.printTable(vertecies)
    table.insert(bladeShapes, love.physics.newPolygonShape(vertecies))
end


local spinnerImages = {
    love.graphics.newImage("image/obstacle/spinner/centre.png"),
    love.graphics.newImage("image/obstacle/spinner/blade.png"),
}


local spinnerObstacle = setmetatable({}, { __index = Obstacle }) 
spinnerObstacle.__index = spinnerObstacle

function spinnerObstacle:New(x, y)
    local y = y - 100
    local obj = Obstacle:New(x, y, centerShape)
    
    setmetatable(obj, self)
    obj.image = spinnerImages[1]
    obj.bladeImage = spinnerImages[2]
    

    obj.body:setPosition(obj.x,y)
    obj.body:setType("kinematic")
    obj.angle = 0

    obj.spinDirection = (math.random(1, 2) == 1 and 1) or -1
    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})
    obj.bladeFixtures = {}

    -- add the blades
    for i = 1,bladeCount do
        table.insert(obj.bladeFixtures, love.physics.newFixture(obj.body, bladeShapes[i]))
        obj.bladeFixtures[i]:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})
    end

    return obj
end

function spinnerObstacle:Update(no, dt)
    if self.body then

        self.angle = self.angle + dt  -- mult by a speed
        self.body:setAngle(self.angle)

        Obstacle.Update(self, no, dt)
    end
end

local function drawBodyFixtures(body)
    
end

function spinnerObstacle:Draw(no)
    if self.body then
        -- look, you're gonna have to draw the things here
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.angle, 3, 3, img:getWidth()/2, img:getHeight()/2)

        local img = self.bladeImage
        for i = 1,bladeCount do
            -- full rev * percentage --> i/max
            local angle = math.pi*2*(i/bladeCount)

            love.graphics.draw(img, self.x, self.y, self.angle + angle - math.pi/6, 3, 3, img:getWidth()/2, img:getHeight())
        end
    end
end

return spinnerObstacle