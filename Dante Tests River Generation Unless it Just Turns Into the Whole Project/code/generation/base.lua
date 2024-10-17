local riverGenerator = {}
local genrationSettings = {}

function riverGenerator.Load() -- loads or reloads the settings
    genrationSettings = require("settings/generation/base")
end

function riverGenerator.NextSpline(riverDist) --returns a table with the next points in the spline
    --0.1 is the default y for all noise values bcause 0 game some odd strange lines

    -- generate a diffrence
    local distance = love.math.noise(riverDist/genrationSettings.widthNoiseSize, 0.1, love.math.getRandomSeed())*(genrationSettings.widthNoiseMax- genrationSettings.widthNoiseMin) + genrationSettings.widthNoiseMin
    print(distance)

    local x1 = (love.math.noise(riverDist/genrationSettings.bigNoiseSize, 0.1, love.math.getRandomSeed())-0.5)*genrationSettings.maxDist - distance/2
    local x2 = (love.math.noise(riverDist/genrationSettings.bigNoiseSize, 0.1 + genrationSettings.bigNoiseOffset, love.math.getRandomSeed())-0.5)*genrationSettings.maxDist + distance/2

    --we want to sample diffrent points so we have 5.1
    x1 = x1 + (love.math.noise(riverDist/genrationSettings.smallNoiseSize, 5.1, love.math.getRandomSeed())-0.5)*genrationSettings.smallNoiseMult
    x2 = x2 + (love.math.noise(riverDist/genrationSettings.smallNoiseSize, 5.1 + genrationSettings.smallNoiseOffset, love.math.getRandomSeed())-0.5)*genrationSettings.smallNoiseMult

    return {{x = x1, y = riverDist}, {x = x2, y = riverDist}}
end


return riverGenerator