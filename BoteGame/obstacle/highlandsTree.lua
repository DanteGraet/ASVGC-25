local highlandsTreeShape = love.physics.newCircleShape(20*3)
local highlandsTreeImages = {
    love.graphics.newImage("image/obstacle/highlandsTree/1.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/2.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/3.png"),
    love.graphics.newImage("image/obstacle/highlandsTree/4.png")
}

for i = 1,#highlandsTreeImages do
    highlandsTreeImages[i]:setFilter("nearest", "nearest")
end

local highlandsTreeObstacle = setmetatable({}, { __index = Obstacle }) 
highlandsTreeObstacle.__index = highlandsTreeObstacle

local highlandsTreeAcceptedColours = {
    0.12,
}

highlandsTreeObstacle.xFunc = function()
    return math.random(-960,960)
end

function highlandsTreeObstacle:New(x, y)

    local obj = {}
    obj.spawnFail = true

    if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    for i = 1, #highlandsTreeAcceptedColours do
        if assets.code.river.zone[zones.zone].GetColourAt(x,y)[1] == highlandsTreeAcceptedColours[i] then 
            obj = Obstacle:New(x, y, highlandsTreeShape)
            setmetatable(obj, self)
            obj.image = highlandsTreeImages[math.random(1, #highlandsTreeImages)]   
            obj.dir = math.rad(math.random(1,360))   
            --obj.fixture:setSensor(true)
        end
    end


    return obj
end

function highlandsTreeObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return highlandsTreeObstacle