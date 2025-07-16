local beachJunkShape = love.physics.newCircleShape(20*3)
local beachJunkImages = {
    love.graphics.newImage("image/obstacle/beachJunk/1.png"),
    love.graphics.newImage("image/obstacle/beachJunk/2.png"),
    love.graphics.newImage("image/obstacle/beachJunk/3.png"),
    love.graphics.newImage("image/obstacle/beachJunk/4.png"),
    love.graphics.newImage("image/obstacle/beachJunk/5.png"),
    love.graphics.newImage("image/obstacle/beachJunk/6.png"),
    love.graphics.newImage("image/obstacle/beachJunk/7.png"),
    love.graphics.newImage("image/obstacle/beachJunk/1.png"), --intentional
    love.graphics.newImage("image/obstacle/beachJunk/1.png"),
    love.graphics.newImage("image/obstacle/beachJunk/2.png"),
    love.graphics.newImage("image/obstacle/beachJunk/3.png"),
    love.graphics.newImage("image/obstacle/beachJunk/4.png"),

}

for i = 1,#beachJunkImages do
    beachJunkImages[i]:setFilter("nearest", "nearest")
end

local beachJunkObstacle = setmetatable({}, { __index = Obstacle }) 
beachJunkObstacle.__index = beachJunkObstacle

local beachJunkAcceptedColours = {
    1.0,
    0.96
}

beachJunkObstacle.xFunc = function()
    return math.random(-960,960)
end

function beachJunkObstacle:New(x, y)

    local obj = {}

    --[[if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end]]

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    for i = 1, #beachJunkAcceptedColours do
        if assets.code.river.zone[riverGenerator:GetZone(y).zone].GetColourAt(x,y)[1] == beachJunkAcceptedColours[i] and river:getDistToEdge(x, y) > 0 then 
            obj = Obstacle:New(x, y, beachJunkShape, obj.OnCollideWithPlayer)
            setmetatable(obj, self)
            obj.image = beachJunkImages[math.random(1, #beachJunkImages)]   
            obj.dir = math.rad(math.random(1,360))   
            obj.fixture:setSensor(true)

            return obj

        end
    end
end

function beachJunkObstacle:OnCollideWithPlayer(self, collideData)
    if not collideData.hasCollided then
        collideData.hasCollided = true
    end
end

function beachJunkObstacle:Update(no, dt, front)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt, front)
    end
end

return beachJunkObstacle