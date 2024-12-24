local RandomSpawner = {}
RandomSpawner.__index = RandomSpawner


function RandomSpawner:New(obsticals)
    local obj = setmetatable({}, RandomSpawner)

    obj.obsticals = obsticals
    obj.lastY = riverBorders.up - 250

    print("\n\n==\n\n")
    dante.printTable(obsticals)

    return obj
end

function RandomSpawner:Update(val)
    if val then
        self.lastY = riverBorders.up - 250
        return
    end

    if self.lastY == math.ceil((riverBorders.up - 250)/3)*3 then return end
    for y = math.ceil(self.lastY/3)*3, math.ceil((riverBorders.up - 250)/3)*3, -3 do
       
        -- check if we are going to spawn an obtical here
        local zone = riverGenerator:GetZone(y)
        local chance = quindoc.runIfFunc(zone.difficultyFunction,(riverGenerator:GetPercentageThrough(y)))

        if chance >= math.random(0, 1000)/1000 then
            -- spawwn the obtical

            local obsticalIndexList = {}

            -- calculate the weight of each obstical
            local totalWeight = 0
            for key, value in pairs(self.obsticals) do
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
        end

    end
    self.lastY = math.ceil((riverBorders.up - 250)/3)*3

end

return RandomSpawner