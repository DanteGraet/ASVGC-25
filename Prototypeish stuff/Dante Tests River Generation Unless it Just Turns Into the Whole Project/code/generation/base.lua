local riverGenerator = {}
local genrationSettings = {}

function riverGenerator.Load() -- loads or reloads the settings
    genrationSettings = require("settings/generation/base")
end

function riverGenerator.NextSpline(riverDist, previous) --returns a table with the next points in the spline
    --0.1 is the default y for all noise values bcause 0 game some odd strange lines

    -- generate a diffrence
    local distance = love.math.noise(riverDist/genrationSettings.widthNoiseSize, 0.1, love.math.getRandomSeed())*(genrationSettings.widthNoiseMax- genrationSettings.widthNoiseMin) + genrationSettings.widthNoiseMin

    local x1 = (love.math.noise(riverDist/genrationSettings.bigNoiseSize, 0.1, love.math.getRandomSeed())-0.5)*genrationSettings.maxDist - distance/2
    local x2 = (love.math.noise(riverDist/genrationSettings.bigNoiseSize, 0.1 + genrationSettings.bigNoiseOffset, love.math.getRandomSeed())-0.5)*genrationSettings.maxDist + distance/2

    --we want to sample diffrent points so we have 5.1
    x1 = x1 + (love.math.noise(riverDist/genrationSettings.smallNoiseSize, 5.1, love.math.getRandomSeed())-0.5)*genrationSettings.smallNoiseMult
    x2 = x2 + (love.math.noise(riverDist/genrationSettings.smallNoiseSize, 5.1 + genrationSettings.smallNoiseOffset, love.math.getRandomSeed())-0.5)*genrationSettings.smallNoiseMult

    local y1 = riverDist
    local y2 = riverDist

    local a1 = 0
    local a2 = 0

    if previous then
        local px1 = previous[1].x
        local py1 = previous[1].rel

        local px2 = previous[2].x
        local py2 = previous[2].rel

        --find the angle, then convert to a peercentage (0-1)
        a1 = math.atan2(py1-y1, px1-x1)
        a2 = math.atan2(py2-y2, px2-x2)


        local p1 = quindoc.clamp((a1-(math.pi/2))/(math.pi), 0, 1)
        local p2 = quindoc.clamp((a2-(math.pi/2))/(math.pi), -1, 0)

        --print("a1: " .. a1, "a1-pi/2: " .. (a1-math.pi/2), "p1: " .. p1, "dist*p1: " ..(distance)*p1)

        y1 = y1 - (distance)*p1
        y2 = y2 + (distance)*p2
    end

    return {{x = x1, y = y1, rel = riverDist, dir = a1}, {x = x2, y = y2, rel = riverDist, dir = a2}}
end


return riverGenerator