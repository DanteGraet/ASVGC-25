local hillsTreeShape = love.physics.newCircleShape(20*3)
local hillsTreeImages = {
    love.graphics.newImage("image/obstacle/highlandsTree/1.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/2.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/3.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/4.png")
}

for i = 1,#hillsTreeImages do
    hillsTreeImages[i]:setFilter("nearest", "nearest")
end

local hillsTreeObstacle = setmetatable({}, { __index = Obstacle }) 
hillsTreeObstacle.__index = hillsTreeObstacle

local hillsTreeAcceptedColours = {
    0.45,
    0.36,
    0.4
}

hillsTreeObstacle.xFunc = function()
    return math.random(-960,960)
end

function hillsTreeObstacle:New(x, y)

    local obj = {}
    obj.spawnFail = true

    if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    for i = 1, #hillsTreeAcceptedColours do
        if assets.code.river.zone[zones.zone].GetColourAt(x,y)[1] == hillsTreeAcceptedColours[i] then 
            obj = Obstacle:New(x, y, hillsTreeShape)
            setmetatable(obj, self)
            obj.image = hillsTreeImages[math.random(1, #hillsTreeImages)]   
            obj.dir = math.rad(math.random(1,360))   
            --obj.fixture:setSensor(true)
        end
    end


    return obj
end

function hillsTreeObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return hillsTreeObstacle