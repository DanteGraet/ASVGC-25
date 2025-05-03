local autumnTreeShape = love.physics.newCircleShape(20*3)
local autumnTreeImages = {
    love.graphics.newImage("image/obstacle/autumnTree/1.png"),
    love.graphics.newImage("image/obstacle/autumnTree/2.png"),
    love.graphics.newImage("image/obstacle/autumnTree/3.png"),
    love.graphics.newImage("image/obstacle/autumnTree/4.png")
}

for i = 1,#autumnTreeImages do
    autumnTreeImages[i]:setFilter("nearest", "nearest")
end

local autumnTreeObstacle = setmetatable({}, { __index = Obstacle }) 
autumnTreeObstacle.__index = autumnTreeObstacle

local autumnTreeAcceptedColours = {
    0.87,
    0.72
}

autumnTreeObstacle.xFunc = function()
    return math.random(-960,960)
end

function autumnTreeObstacle:New(x, y)

    local obj = {}
    obj.spawnFail = true

    if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    for i = 1, #autumnTreeAcceptedColours do
        if assets.code.river.zone[zones.zone].GetColourAt(x,y)[1] == autumnTreeAcceptedColours[i] then 
            obj = Obstacle:New(x, y, autumnTreeShape)
            setmetatable(obj, self)
            obj.image = autumnTreeImages[math.random(1, #autumnTreeImages)]   
            obj.dir = math.rad(math.random(1,360))   
            --obj.fixture:setSensor(true)
        end
    end


    return obj
end

function autumnTreeObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return autumnTreeObstacle