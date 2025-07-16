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


local spinnerLeaderLineImages = {
    love.graphics.newImage("image/obstacle/spinner/centre.png"),
    love.graphics.newImage("image/obstacle/spinner/blade.png"),
}

for i = 1,#spinnerLeaderLineImages do
    spinnerLeaderLineImages[i]:setFilter("nearest", "nearest")
end


local spinnerLeaderLineObstacle = setmetatable({}, { __index = Obstacle }) 
spinnerLeaderLineObstacle.__index = spinnerLeaderLineObstacle

function spinnerLeaderLineObstacle:New(x, y, givDir)

    local z1 = riverGenerator:GetZone(y)

    if z1.displayName and z1.displayName == "The Inlet" then
        return nil --don't spawn
    else

        local x = riverBorders.left-math.random(420,460)
        local y = y - 500
        local obj = Obstacle:New(x, y, centerShape)
        local var = math.random(1,3)
        
        setmetatable(obj, self)
        obj.image = spinnerLeaderLineImages[1]
        obj.bladeImage = spinnerLeaderLineImages[2]

        obj.body:setPosition(obj.x,y)
        obj.body:setType("kinematic")
        obj.angle = 0

        obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})
        obj.bladeFixtures = {}

        -- add the blades
        for i = 1,bladeCount do
            table.insert(obj.bladeFixtures, love.physics.newFixture(obj.body, bladeShapes[i]))
            obj.bladeFixtures[i]:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})
        end

        obj.spinSpeed = 0.5

        obj.spinDir = (math.random(0,1)*2)-1

        for i = 1, 7 do

            local direction = 1
            local idk = 1

            if var < 3 and i % 2 == 0 then
                direction = 1
                idk = -1
            end

            local ag = 0

            if var > 1 and direction == -1 then
                ag = 1 
            end

            table.insert(obstacles, assets.obstacle.spinner:New(x+400*i, y, direction*idk*obj.spinDir,0.5,ag))

        end

        table.insert(obstacles, assets.obstacle.noSpawnSphere:New(x, y, 300))

        return obj

    end
end

function spinnerLeaderLineObstacle:Update(no, dt)
    if self.body then

        self.angle = self.angle + dt*self.spinDir*self.spinSpeed  -- mult by a speed
        self.body:setAngle(self.angle)

        Obstacle.Update(self, no, dt)
    end
end

local function drawBodyFixtures(body)
    
end

function spinnerLeaderLineObstacle:Draw(no)
    if self.body then
        -- look, you're gonna have to draw the things here
        local img = self.bladeImage
        for i = 1,bladeCount do
            -- full rev * percentage --> i/max
            local angle = math.pi*2*(i/bladeCount)

            love.graphics.draw(img, self.x, self.y, self.angle + angle - math.pi/6, 3*self.spinDir, 3, img:getWidth()/2, img:getHeight())
        end

        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.angle, 3*self.spinDir, 3, img:getWidth()/2, img:getHeight()/2)
    end
end

return spinnerLeaderLineObstacle