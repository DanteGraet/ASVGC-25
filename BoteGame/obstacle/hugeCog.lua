local hugeCogShape = love.physics.newCircleShape(180)
local hugeCogImages = {
    love.graphics.newImage("image/obstacle/cog/hugeCog.png"),
}

for i = 1,#hugeCogImages do
    hugeCogImages[i]:setFilter("nearest", "nearest")
end

local hugeCogObstacle = setmetatable({}, { __index = Obstacle }) 
hugeCogObstacle.__index = hugeCogObstacle

function hugeCogObstacle:New(x, y)
    local obj = Obstacle:New(x, y-1000, hugeCogShape)
    setmetatable(obj, self)
    obj.image = hugeCogImages[math.random(1, #hugeCogImages)]
    obj.drawDelay = 0.1

    obj.centreX = obj.x
    obj.centreY = obj.y

    local r1 = love.math.random(9,11)/10
    local r2 = love.math.random(8,13)/10
    obj.colour = {0.94*r2*r1,0.5*r2,0.2*r2}

    obj.body:setType("kinematic")

    --fix so they dont despawn
    local data = obj.fixture:getUserData()
    data.first = false
    obj.fixture:setUserData(data)

    local yay = y-800--trust the process

    local globalCogPhase = 0
    local globalCogRadius = 400


    for i = 1,8 do
        --if i == 1 then globalCogInCharge = true else globalCogInCharge = false end
        globalCogPhase = (math.pi*i)/4
        table.insert(obstacles, assets.obstacle.subordinateCog:New(x,yay, globalCogPhase, globalCogRadius, i == 1))
    end

    globalCogRadius = 650

    for i = 1,12 do
        globalCogPhase = (math.pi*i)/6
        table.insert(obstacles, assets.obstacle.subordinateCog:New(x,yay, globalCogPhase, globalCogRadius))
    end
    
    globalCogPhase = nil
    globalCogRadius = nil
    --globalCogInCharge = nil

    table.insert(obstacles, assets.obstacle.noSpawnSphere:New(x, y - 1000, 750))
    
    return obj
end

function hugeCogObstacle:Update(no, dt)
    if self.body then

        self.dir = self.dir + 0.31*dt --approx 5rpm
        if self.drawDelay >= 0 then self.drawDelay = self.drawDelay-dt end

        self.body:setPosition(self.centreX,self.centreY) --temporary fix

        Obstacle.Update(self, no, dt)
    end
end

function hugeCogObstacle:Draw(no)
    if self.body then

        if self.image and not self.fixture:getUserData().first and self.drawDelay < 0 then
            local img = self.image
            love.graphics.setColor(self.colour)
            love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
        end

        love.graphics.setColor(1,1,1)
    end
end

return hugeCogObstacle