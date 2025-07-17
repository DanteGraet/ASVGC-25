local energyShape = love.physics.newCircleShape(15)
local energyImages = {}

for i = 1, 11 do
    local image = love.graphics.newImage("image/obstacle/energy/energy.png")
    table.insert(energyImages,image)
end

for i = 1,#energyImages do
    energyImages[i]:setFilter("nearest", "nearest")
end

local energyObstacle = setmetatable({}, { __index = Obstacle }) 
energyObstacle.__index = energyObstacle

function energyObstacle:New(x, y,xM,yM)
    local obj = Obstacle:New(x, y, energyShape)
    setmetatable(obj, self)
    obj.image = energyImages[1]

    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})

    obj.fixture:setSensor(true)

    obj.dir = math.random(1,6)
    obj.mathz = 0

    obj.xM = xM
    obj.yM = yM

    obj.life = 10

    return obj

end

function energyObstacle:Update(no, dt)
    if not self.body:isDestroyed() then

        self.mathz = self.mathz + dt
        self.dir = math.sin(3*self.mathz)+3*math.cos(0.4*self.mathz)

        self.body:setPosition(self.x+self.xM*dt,self.y+self.yM*dt)

        self.life = self.life - dt
        
        if self.life < 0 then
            --despawn (some jumping through hoops is required)
            local data = self.fixture:getUserData()
            data.remove = true
            self.fixture:setUserData(data)
        end

        Obstacle.Update(self, no, dt, true)
    end
end

function energyObstacle:Draw(no)
    if self.body then
        love.graphics.setColor(1,1,1,quindoc.clamp(self.life,0,1))
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
        love.graphics.setColor(1,1,1,1)
    end
end

return energyObstacle