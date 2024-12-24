local timerSpawner = {}
timerSpawner.__index = timerSpawner


function timerSpawner:New(obsticals, min, max)
    local obj = setmetatable({}, timerSpawner)

    obj.obsticals = obsticals
    obj.lastY = riverBorders.up - 250

    obj.min = min
    obj.max = max
    obj.time = math.random(min, max)*math.random(0, 100)/100

    return obj
end

function timerSpawner:Update(val)
    if val then
        self.lastY = riverBorders.up - 250
        return
    end
    if riverBorders.up - 250 >= self.lastY - self.time then return end

    local y = self.lastY - self.time
    -- check if we are going to spawn an obtical here

    local obsticalIndexList = {}

    -- calculate the weight of each obstical
    local totalWeight = 0
    for key, value in pairs(self.obsticals) do
        local noise = (love.math.noise(riverBorders.up/value.noiseDiv, value.noise/value.noiseDiv, love.math.getRandomSeed())-0.5)*2 * value.weightChange
        totalWeight = totalWeight + value.spawnWeight + noise

        table.insert(obsticalIndexList, {
            name = key,
            weight = value.spawnWeight + noise,
        })
    end

    local obsticalNumber = math.random(0, totalWeight)

    for i = 1,#obsticalIndexList do
        if obsticalNumber < obsticalIndexList[i].weight then

            if assets.obstacle[obsticalIndexList[i].name].xFunc then
                table.insert(obstacles, assets.obstacle[obsticalIndexList[i].name]:New(assets.obstacle[obsticalIndexList[i].name].xFunc(), y))
            else
                table.insert(obstacles, assets.obstacle[obsticalIndexList[i].name]:New(math.random(-960, 960), y))
            end

            break
        else
            obsticalNumber = obsticalNumber - obsticalIndexList[i].weight
        end
    end


    self.lastY = math.ceil((riverBorders.up - 250)/3)*3
    self.time = math.random(self.min, self.max)

end

return timerSpawner