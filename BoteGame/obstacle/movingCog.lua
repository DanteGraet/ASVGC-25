local movingCogShape = love.physics.newCircleShape(30)
local movingCogImages = {
    love.graphics.newImage("image/obstacle/cog/b1.png"),
    love.graphics.newImage("image/obstacle/cog/b2.png"),
}

for i = 1,#movingCogImages do
    movingCogImages[i]:setFilter("nearest", "nearest")
end

local movingCogObstacle = setmetatable({}, { __index = Obstacle }) 
movingCogObstacle.__index = movingCogObstacle

function movingCogObstacle:New(x, y)
    local y = y - 100
    local obj = Obstacle:New(x, y, movingCogShape)
    setmetatable(obj, self)
    obj.image = movingCogImages[math.random(1, #movingCogImages)]
    
    local r1 = love.math.random(9,11)/10
    local r2 = love.math.random(8,13)/10

    obj.x = river:getCenter(y)
    obj.body:setPosition(obj.x,y)
    obj.colour = {0.94*r2*r1,0.5*r2,0.2*r2}
    obj.body:setType("kinematic")
    obj.centreX = obj.x
    obj.displacement = -1*river:getDistToEdge(obj.x,y)+20
    obj.phase = love.math.random(0,62)/10
    obj.phaseSpeed = love.math.random(3,8)/10
    obj.spinDirection = (math.random(1, 2) == 1 and 1) or -1
    obj.fixture:setUserData({type = "obstacle", first = false, remove = false, OnCollideWithPlayer = Obstacle.OnCollideWithPlayer})


    table.insert(obstacles, assets.obstacle.noSpawnRect:New(obj.centreX, y - 50/3, obj.displacement, 150/3))
    
    return obj
end

function movingCogObstacle:Update(no, dt)
    if self.body then

        self.phase = self.phase + self.phaseSpeed*dt
        if self.phase > 2*math.pi then self.phase = 0 end

        self.body:setPosition(self.centreX + math.cos(self.phase)*self.displacement,self.y)

        self.dir = self.dir + math.sin(self.phase)*dt*5*self.spinDirection*(self.phaseSpeed) --self.phase

        Obstacle.Update(self, no, dt)
    end
end

function movingCogObstacle:Draw(no)
    if self.body then

        --draw the 'conveyor' mechanism the cog moves on
        love.graphics.setLineWidth(25)
        love.graphics.setColor(0.3,0.2,0.1,0.4)
        love.graphics.line(self.centreX-self.displacement,self.y,self.centreX+self.displacement,self.y)

        --screws on each end
        love.graphics.setColor(0.4,0.4,0.4,0.5)
        love.graphics.circle("fill",self.centreX-self.displacement+15,self.y,10)
        love.graphics.circle("fill",self.centreX+self.displacement-15,self.y,10)

        if self.image and not self.fixture:getUserData().first then
            local img = self.image
            love.graphics.setColor(self.colour)
            love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
        end

        love.graphics.setColor(1,1,1)
    end
end

return movingCogObstacle