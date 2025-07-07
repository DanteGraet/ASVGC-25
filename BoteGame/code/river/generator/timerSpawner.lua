local timerSpawner = {}
timerSpawner.__index = timerSpawner


function timerSpawner:New(obsticals, min, max, lastY, front)
    local obj = setmetatable({}, timerSpawner)

    obj.obsticals = obsticals
    obj.lastY = lastY or riverBorders.up - 250

    obj.min = min
    obj.max = max
    obj.time = math.random(min, max)*math.random(0, 100)/100

    obj.inFront = front or false

    return obj
end

timerSpawner.spawnObstacle = love.filesystem.load("code/river/generator/spawnObstacleFunc.lua")()


function timerSpawner:Update(val)
    if val then
        self.lastY = riverBorders.up - 250
        return
    end
    if riverBorders.up - 250 >= self.lastY - self.time then return end

    local y = self.lastY - self.time
    -- check if we are going to spawn an obtical here

    self.spawnObstacle(self.obsticals, y, self.inFront)


    self.lastY = math.ceil((riverBorders.up - 250)/3)*3
    self.time = math.random(self.min, self.max)

end

return timerSpawner