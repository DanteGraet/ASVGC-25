local difficultyIndependentSpawner = {}
difficultyIndependentSpawner.__index = difficultyIndependentSpawner


function difficultyIndependentSpawner:New(obsticals, chance, lastY, front)
    local obj = setmetatable({}, difficultyIndependentSpawner)

    obj.obsticals = obsticals
    obj.chance = chance
    obj.lastY = lastY or riverBorders.up - 250

    obj.inFront = front or false
    

    return obj
end

difficultyIndependentSpawner.spawnObstacle = love.filesystem.load("code/river/generator/spawnObstacleFunc.lua")()


function difficultyIndependentSpawner:Update(val)
    if val then
        self.lastY = riverBorders.up - 250
        return
    end

    if self.lastY == math.ceil((riverBorders.up - 250)/3)*3 then return end
    for y = math.ceil(self.lastY/3)*3, math.ceil((riverBorders.up - 250)/3)*3, -3 do
       
        -- check if we are going to spawn an obtical here
        local zone = riverGenerator:GetZone(y)
        local chance = self.chance

        if chance >= math.random(0, 1000)/1000 then
            -- spawwn the obtical

            self.spawnObstacle(self.obsticals, y)
            
        end

    end
    self.lastY = math.ceil((riverBorders.up - 250)/3)*3

end

return difficultyIndependentSpawner