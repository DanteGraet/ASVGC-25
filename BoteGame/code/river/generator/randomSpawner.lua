local RandomSpawner = {}
RandomSpawner.__index = RandomSpawner


function RandomSpawner:New(obsticals, lastY, front)
    local obj = setmetatable({}, RandomSpawner)

    obj.obsticals = obsticals
    obj.lastY = lastY or riverBorders.up - 250

    obj.inFront = front or false

    return obj
end

RandomSpawner.spawnObstacle = love.filesystem.load("code/river/generator/spawnObstacleFunc.lua")()

function RandomSpawner:Update(val)
    

    if val then
        self.lastY = riverBorders.up - 250
        return
    end

    if self.lastY == math.ceil((riverBorders.up - 250)/3)*3 then return end
    for y = math.ceil(self.lastY/3)*3, math.ceil((riverBorders.up - 250)/3)*3, -3 do
       
        -- check if we are going to spawn an obtical here
        --assets.code.river.riverData[riverName].ambiance[zoneNames[1].displayName]
        local zone = riverGenerator:GetZone(y)
        local obsVars = riverFileDirectory.obstacle[zone.displayName]
        if obsVars then
            local chance = quindoc.runIfFunc(obsVars.difficultyFunction,(riverGenerator:GetPercentageThrough(y)))

            if chance >= math.random(0, 1000)/1000 then
                self.spawnObstacle(self.obsticals, y, self.inFront)
            end
        end

    end
    self.lastY = math.ceil((riverBorders.up - 250)/3)*3

end

return RandomSpawner