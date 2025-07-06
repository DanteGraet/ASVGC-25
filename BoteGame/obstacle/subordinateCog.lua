local subordinateCogShape = love.physics.newCircleShape(30)
local subordinateCogImages = {
    love.graphics.newImage("image/obstacle/cog/s1.png"),
    love.graphics.newImage("image/obstacle/cog/s2.png"),
}

for i = 1,#subordinateCogImages do
    subordinateCogImages[i]:setFilter("nearest", "nearest")
end

local subordinateCogObstacle = setmetatable({}, { __index = Obstacle }) 
subordinateCogObstacle.__index = subordinateCogObstacle

function subordinateCogObstacle:New(x, y)
    local obj = Obstacle:New(x, y, subordinateCogShape)
    setmetatable(obj, self)
    obj.image = subordinateCogImages[math.random(1, #subordinateCogImages)]

    local r1 = love.math.random(9,11)/10
    local r2 = love.math.random(8,13)/10
    obj.colour = {0.94*r2*r1,0.5*r2,0.2*r2}
    obj.dir = math.random(0,63)/10

    if globalCogPhase then --if being spawned in by a hugecog

        --fix so they dont despawn
        local data = obj.fixture:getUserData()
        data.first = false
        obj.fixture:setUserData(data)

        obj.selfSpinSpeed = -1*math.random(70,80)/100
        obj.phase = globalCogPhase
        obj.radius = globalCogRadius
        obj.body:setType("kinetic")

        obj.centreX = x
        obj.centreY = y-200

        if globalCogInCharge then
            obj.drawResponsibility = true
        end

    end

    return obj
end

function subordinateCogObstacle:Update(no, dt)
    if self.body then

        if self.phase then --if a moving cog

            self.dir = self.dir + self.selfSpinSpeed*dt 

            if self.radius == 400 then 
                self.phase=self.phase + 0.31*dt--same as the huge cog 
                if self.phase > 2*math.pi then self.phase=self.phase-2*math.pi end
            else
                self.phase=self.phase - 0.31*dt--rotate the other way
                if self.phase < -2*math.pi then self.phase=self.phase+2*math.pi end
            end

            
            self.body:setPosition(self.centreX+math.cos(self.phase)*self.radius,self.centreY+math.sin(self.phase)*self.radius)

        end

        Obstacle.Update(self, no, dt)
    end
end

function subordinateCogObstacle:Draw(no)
    if self.body then

        if self.drawResponsibility then --because of layering blah blah
            --draw the 'conveyor' mechanism the subordinate cogs will move on
            love.graphics.setLineWidth(15)
            love.graphics.setColor(0.3,0.2,0.1,0.4)
            love.graphics.circle("line",self.centreX,self.centreY,400)
            love.graphics.circle("line",self.centreX,self.centreY,650)
        end


        if self.image and not self.fixture:getUserData().first then
            local img = self.image
            love.graphics.setColor(self.colour)
            love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
        end

        love.graphics.setColor(1,1,1)
    end
end

return subordinateCogObstacle