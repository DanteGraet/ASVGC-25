Obstacle = {}
Obstacle.__index = Obstacle


function Obstacle:New(x, y, shape)
    local obj = setmetatable({}, Obstacle)

    obj.x = math.floor(x/3)*3 or 0
    obj.y = math.floor(y/3)*3 or 0

    obj.dir = math.rad(math.random(1,4)*90)

    obj.shape = shape or love.physics.newCircleShape(50)

    -- DONT CHNAGE THIS AGAIN. IT HAS TO BE DYNAMIC BY DEFAULT
    obj.body = love.physics.newBody(world, obj.x, obj.y, "dynamic")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData({type = "obstacle", first = true, remove = false})

    return obj
end

function Obstacle:Update(no, dt)

    if self.fixture:getUserData().first then
        local data = self.fixture:getUserData()
        data.first = false

        self.body:setType("static")

        self.fixture:setUserData(data)
    elseif self.fixture:getUserData().remove then
        self.body:destroy()
        table.remove(obstacles, no)
        return
    elseif self.y > riverBorders.down + 500 then
        self.body:destroy()
        table.remove(obstacles, no)
        return
    end

    self.x, self.y = self.body:getPosition()

end


function Obstacle:Draw()
    if self.image and not self.fixture:getUserData().first then
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
    end
end


function Obstacle:DrawHitbox()
    if self.fixture:getUserData().hasCollided then
        love.graphics.setColor(1,0,0)
    end

    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())

    if self.fixture:getUserData().hasCollided then
        love.graphics.setColor(1,1,1)
    end
end