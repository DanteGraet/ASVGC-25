local snowyTreeShape = love.physics.newCircleShape(20*3)
local snowyTreeImages = {
    love.graphics.newImage("image/obstacle/snowyTree/1.png"),
    love.graphics.newImage("image/obstacle/snowyTree/2.png"),
    love.graphics.newImage("image/obstacle/snowyTree/3.png"),
    love.graphics.newImage("image/obstacle/snowyTree/4.png")
}

for i = 1,#snowyTreeImages do
    snowyTreeImages[i]:setFilter("nearest", "nearest")
end

local snowyTreeObstacle = setmetatable({}, { __index = Obstacle }) 
snowyTreeObstacle.__index = snowyTreeObstacle

local snowyTreeAcceptedColours = {
    0.9,
    0.821,
}

snowyTreeObstacle.xFunc = function()
    return math.random(300,960) * (math.random(0,1)*2-1)
end

function snowyTreeObstacle:New(x, y)

    local obj = {}
    obj.spawnFail = true

    if zones[1] and type(zones[1]) == "table" then
        zones = zones[1]
    end

    --dante.printTable(assets.code.river.zone[zones.zone].GetColourAt(x,y))

    for i = 1, #snowyTreeAcceptedColours do
        if assets.code.river.zone[zones.zone].GetColourAt(x,y)[1] == snowyTreeAcceptedColours[i] then 
            obj = Obstacle:New(x, y, snowyTreeShape)
            setmetatable(obj, self)
            obj.image = snowyTreeImages[math.random(1, #snowyTreeImages)]  
            obj.dir = math.rad(math.random(1,360))    
            obj.fixture:setSensor(true)   
        end
    end


    return obj
end

function snowyTreeObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return snowyTreeObstacle