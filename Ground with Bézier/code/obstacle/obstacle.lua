Obstacle = {}
Obstacle.__index = Obstacle


-- Constructor for SkillTree
function Obstacle:New(x, y, shape)
    local obj = setmetatable({}, Obstacle)

    obj.x = math.floor(x/3)*3 or 0
    obj.y = math.floor(y/3)*3 or 0

    obj.dir = math.rad(math.random(1,4)*90)

    obj.shape = shape or love.physics.newCircleShape(50)
    obj.body = love.physics.newBody(world, x, y, "static")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)


    return obj
end

function Obstacle:Draw()
    if self.image then
        local img = self.image
        love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)
    end
end

function Obstacle:DrawHitbox()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end