

return function(obsticals, y, front)
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
                obj = assets.obstacle[obsticalIndexList[i].name]:New(assets.obstacle[obsticalIndexList[i].name].xFunc(), y, front)
            else
                obj = assets.obstacle[obsticalIndexList[i].name]:New(math.random(-960, 960), y, front)
            end 


            -- slower than doing it in the actual obstacle spawn but much better to look at in one place instead of all of them
            if obj then
                local data = obj.fixture:getUserData()

                if front == true then
                    data.type = "frontObstacle"
                else
                    data.type = "obstacle" 
                end

                obj.fixture:setUserData(data)
            end

            if front == true then
                table.insert(frontObstacles, obj)
            else
                table.insert(obstacles, obj)
            end

            break
        else
            obsticalNumber = obsticalNumber - obsticalIndexList[i].weight
        end
    end
end