local hailstoneShape = love.physics.newCircleShape(15)
local hailstoneImages = {}

for i = 1, 11 do
    local image = love.graphics.newImage("image/obstacle/hailstone/1.png")
    table.insert(hailstoneImages,image)
end

for i = 1,#hailstoneImages do
    hailstoneImages[i]:setFilter("nearest", "nearest")
end

local hailstoneObstacle = setmetatable({}, { __index = Obstacle }) 
hailstoneObstacle.__index = hailstoneObstacle

function hailstoneObstacle:New(x, y)

    if currentPlayerPos.stormIntensity > 500 then

        local x = riverBorders.left-200
        local y = math.random(riverBorders.up,riverBorders.down)


        local obj = Obstacle:New(x, y, hailstoneShape)
        setmetatable(obj, self)
        obj.image = hailstoneImages[1]

        obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})

        obj.fixture:setSensor(true)

        obj.dir = math.random(1,6)
        obj.spinSpeed = math.random(15,30)/10

        obj.maths = 0

        obj.speed = math.random(300,400)


        obj.particleCounter = 0
        obj.particleTime = 0.1

        return obj
    
    else

        return nil

    end

end

function hailstoneObstacle:Update(no, dt)
    if not self.body:isDestroyed() then

        self.body:setPosition(self.x+self.speed*dt,self.y)
        self.dir = self.dir + self.spinSpeed*dt+math.sin(self.maths)

        if self.x > riverBorders.right + 100 then
            --despawn (some jumping through hoops is required)
            local data = self.fixture:getUserData()
            data.remove = true
            self.fixture:setUserData(data)
        end

        if self.y > riverBorders.down + 50 then
            self.body:setPosition(self.x+math.random(-200,200),riverBorders.up-math.random(250,750))
        end

        self.particleCounter = self.particleCounter - dt

        if self.particleCounter < 0 then

            particles.spawnParticle("hailTrail",self.x+math.random(-5,5),self.y+math.random(-15,15), nil, {speed = self.speed},"top")


            self.particleCounter = self.particleTime*math.random(5,15)/10
        end

        Obstacle.Update(self, no, dt, true)
    end
end

function hailstoneObstacle:Draw(no)
    if self.body then
        --love.graphics.setColor(1,1,1,quindoc.clamp(self.life,0,1))
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
        love.graphics.setColor(1,1,1,1)
    end
end

return hailstoneObstacle