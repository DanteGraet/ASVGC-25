Obstacle = {}
Obstacle.__index = Obstacle


-- Constructor for SkillTree
function Obstacle:New(x, y, shape)
    local obj = setmetatable({}, Obstacle)

    obj.x = x or 0
    obj.y = y or 0

    obj.dir = 0

    obj.shape = shape or love.physics.newCircleShape(50)
    obj.body = love.physics.newBody(world, x, y, "static")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)


    return obj
end

function Obstacle:DrawHitbox()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end