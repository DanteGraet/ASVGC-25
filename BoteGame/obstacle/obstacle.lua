Obstacle = {}
Obstacle.__index = Obstacle


function Obstacle:New(x, y, shape, colisionFunction)
    local obj = setmetatable({}, Obstacle)

    obj.x = math.floor(x/3)*3 or 0
    obj.y = math.floor(y/3)*3 or 0

    obj.dir = math.rad(math.random(1,4)*90)

    obj.shape = shape or love.physics.newCircleShape(50)

    -- DONT CHNAGE THIS AGAIN. IT HAS TO BE DYNAMIC BY DEFAULT
    obj.body = love.physics.newBody(world, obj.x, obj.y, "dynamic")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData({type = "obstacle", first = true, remove = false, OnCollideWithPlayer = colisionFunction or obj.OnCollideWithPlayer})


    return obj
end

function Obstacle:OnCollideWithPlayer(self, collideData)
    --if not collideData.hasCollided then
        --collideData.hasCollided = true
        player:TakeDamage(1)
    --end
end


function Obstacle:Update(no, dt, front)
    if not self.fixture:isDestroyed() then
        if self.fixture:getUserData().first then
            local data = self.fixture:getUserData()
            data.first = false

            if self.firstFunction then
                self:firstFunction()
            end

            self.body:setType("static")

            self.fixture:setUserData(data)
        elseif self.fixture:getUserData().remove or self.y > riverBorders.down + 1000 then
            self.body:destroy()
            if self.Remove then
                self:Remove()
            end

            if front == true then
                table.remove(frontObstacles, no)
            else
                table.remove(obstacles, no)
            end
            
            return
        end

        self.x, self.y = self.body:getPosition()
    else
        if not front == true then
            table.remove(obstacles, no)
        else
            table.remove(frontObstacles, no)
        end
    end

end


function Obstacle:Draw()
    if self.image then
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
    end
end


function Obstacle:DrawHitbox()
    if self.body then

        love.graphics.setLineWidth(1)

        for _, fixture in pairs(self.body:getFixtures()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()

            if shapeType == "polygon" then      -- also counts rectangle
                local points = {self.body:getWorldPoints(shape:getPoints())}
                love.graphics.polygon("line", points)

            elseif shapeType == "circle" then
                local x, y = self.body:getWorldPoint(shape:getPoint())
                local radius = shape:getRadius()
                love.graphics.circle("line", x, y, radius)
            end
        end
    end
end