local teslaShape = love.physics.newCircleShape(120)
local teslaImages = {
    love.graphics.newImage("image/obstacle/tesla/base.png"),
    love.graphics.newImage("image/obstacle/tesla/orb.png"),
}

for i = 1,#teslaImages do
    teslaImages[i]:setFilter("nearest", "nearest")
end

local teslaObstacle = setmetatable({}, { __index = Obstacle }) 
teslaObstacle.__index = teslaObstacle

function teslaObstacle:New(x, y)

    local y = y - 500
    local x = math.random(-800,800)

    local obj = Obstacle:New(x, y, teslaShape)
    setmetatable(obj, self)
    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})
    obj.base = teslaImages[1]
    obj.orb = teslaImages[2]

    obj.angle = math.random(0,1)*(math.pi/4)
    obj.orbAngle = 0
    
    obj.fireCounter = 0.1
    obj.fireTime = 0.5

    table.insert(obstacles, assets.obstacle.noSpawnSphere:New(x, y, 400))
    
    return obj
end

function teslaObstacle:Update(no, dt)
    if self.body then

        self.orbAngle = self.orbAngle + 0.7*dt

        self.fireCounter = self.fireCounter - dt
        if self.fireCounter < 0 then --fire
            self.fireCounter = self.fireTime

            local xM = math.cos(self.orbAngle)*200
            local yM = math.sin(self.orbAngle)*200

            table.insert(frontObstacles, assets.obstacle.energy:New(self.x, self.y,xM,yM))
            table.insert(frontObstacles, assets.obstacle.energy:New(self.x, self.y,xM*-1,yM*-1))

        end

        Obstacle.Update(self, no, dt)
    end
end

function teslaObstacle:Draw(no)
    if self.body then
        -- look, you're gonna have to draw the things here
        local img = self.base
        love.graphics.draw(img, self.x, self.y, self.angle, 3, 3, img:getWidth()/2, img:getHeight()/2)

        local img = self.orb
        love.graphics.draw(img, self.x, self.y, self.orbAngle, 3, 3, img:getWidth()/2, img:getHeight()/2)
    end
end


return teslaObstacle