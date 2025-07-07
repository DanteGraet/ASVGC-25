

return function(obsticals, y)
    local obsticalIndexList = {}

    -- calculate the weight of each obstical
    local totalWeight = 0
    for key, value in pairs(obsticals) do
        local noise = (love.math.noise(y/value.noiseDiv, value.noise/value.noiseDiv, love.math.getRandomSeed())-0.5)*2 * value.weightChange
        totalWeight = totalWeight + value.spawnWeight + noise

        table.insert(obsticalIndexList, {
            name = key,
            weight = value.spawnWeight + noise,
        })
    end

    local obsticalNumber = math.random(0, totalWeight)

    for i = 1,#obsticalIndexList do
        if obsticalNumber < obsticalIndexList[i].weight then

            local obj

            if assets.obstacle[obsticalIndexList[i].name].xFunc then
                obj = assets.obstacle[obsticalIndexList[i].name]:New(assets.obstacle[obsticalIndexList[i].name].xFunc(), y)
            else
                obj = assets.obstacle[obsticalIndexList[i].name]:New(math.random(-960, 960), y)
            end 

            table.insert(obstacles, obj)

            break
        else
            obsticalNumber = obsticalNumber - obsticalIndexList[i].weight
        end
    end
end