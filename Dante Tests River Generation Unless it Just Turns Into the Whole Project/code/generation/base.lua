local riverGenerator = {}
local genrationSettings = {}

function riverGenerator.Load() -- loads or reloads the settings
    genrationSettings = require("settings/generation/base")
end

function riverGenerator.NextSpline(riverDist) --returns a table with the next points in the spline
    local noise = (love.math.noise(riverDist/genrationSettings.bigNoiseSize, love.math.getRandomSeed())-0.5)*genrationSettings.maxDist

    return {x = noise, y = riverDist}
end


return riverGenerator