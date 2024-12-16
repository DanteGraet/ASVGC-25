local leaderRockShape = love.physics.newCircleShape(25)

local leaderRockImages = {}

for i = 1, 5 do
    local image = love.graphics.newImage("image/obstacle/bigRock/bigRock"..i..".png")
    table.insert(leaderRockImages,image)
end

for i = 1,#leaderRockImages do
    leaderRockImages[i]:setFilter("nearest", "nearest")
end

local leaderRockObstacle = setmetatable({}, { __index = Obstacle }) 
leaderRockObstacle.__index = leaderRockObstacle

leaderRockObstacle.xFunc = function()
    return math.random(-200,200)
end

function leaderRockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, leaderRockShape)
    setmetatable(obj, self)
    obj.image = leaderRockImages[math.random(1, #leaderRockImages)]

    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE

    local angle = math.random(0,1)*(math.pi+1.5) - math.random(1,140)/100
    local chainLength = math.random(2,5)
    chainDiff = math.random(170,220)

    if chainLength > 0 then
        for i = 1, chainLength do

            local randNum = math.random(1,5)

            if randNum == 1 or randNum == 2 then

                chainDiff = chainDiff + math.random(600,800)
                table.insert(obstacles, assets.obstacle.hugeRock:New(obj.x+chainDiff*i*math.cos(angle),obj.y+chainDiff*i*math.sin(angle)))
                angle = angle + math.random(-50,50)/100

            elseif randNum == 3 or randNum == 4 then

                chainDiff = chainDiff + math.random(350,500)
                table.insert(obstacles, assets.obstacle.bigRock:New(obj.x+chainDiff*i*math.cos(angle),obj.y+chainDiff*i*math.sin(angle)))
                angle = angle + math.random(-50,50)/100

            else

                chainDiff = chainDiff + math.random(170,220)
                table.insert(obstacles, assets.obstacle.rock:New(obj.x+chainDiff*i*math.cos(angle),obj.y+chainDiff*i*math.sin(angle)))
                angle = angle + math.random(-50,50)/100

            end

            

        end
    end
    
    return obj
end

function leaderRockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

return leaderRockObstacle