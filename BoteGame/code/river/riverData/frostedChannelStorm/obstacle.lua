local function iceplainsCurrent(percentage)
    return 100*quindoc.clamp(percentage,0,1) + 50
end

local function boulderValleyCurrent(percentage)
    return 150
end

local function boulderValleyChainLengthCoefficient(percentage)
    return 1.35 - 0.2*quindoc.clamp(percentage,0,1)
end

local function stormValleyCurrent(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end
    return 150 + 150*quindoc.clamp(idk,0,1) 
end

local function stormValleyChainLengthCoefficient(percentage)
    return 1.15 - 0.05*quindoc.clamp(percentage,0,1)
end

local function stormValleyStormIntensity(percentage)
    local idk = percentage

    if percentage < 0.4 then
        idk = percentage*2.5
    elseif percentage < 0.8 then
        idk = 1
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 1000*quindoc.clamp(idk,0,1)
end

local function coniferousMountainsideDifficulty(percentage)

    if percentage > 0.9 then
        return 0
    else
        return 0.01
    end

end


return {
    ["Glacial Lake"] = {
        difficultyFunction = 0,
        current = 100,
    },
    ["Ice Plains"] = {
        difficultyFunction = 0.008,
        current = iceplainsCurrent,
    },
    ["Boulder Valley"] = {
        difficultyFunction = 0.002,
        current = boulderValleyCurrent,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient,
    },
    ["Storm Valley"] = {
        stormIntensity = stormValleyStormIntensity,
        difficultyFunction = 0.007,
        current = stormValleyCurrent,
        chainLengthCoefficient = stormValleyChainLengthCoefficient,
    },
    ["_Storm Valley"] = {
        stormIntensity = 0,
        difficultyFunction = 0.005,
        current = 100,
        chainLengthCoefficient = 1.1,
    },
    ["Wooded Hills"] = {
        difficultyFunction = coniferousMountainsideDifficulty,
        current = 100,
    },
}



--riverGenerator:GetPercentageThrough(player.y)