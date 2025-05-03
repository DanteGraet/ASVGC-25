local function coniferousHillsCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 300
end

local function boulderValleyDifficulty(percentage)
    return 0.0015 + 0.0035*quindoc.clamp(percentage,0,1)
end


local function boulderValleyCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 100
end

local function boulderValleyChainLengthCoefficient(percentage)
    return 1.35 - 0.2*quindoc.clamp(percentage,0,1)
end


local function boulderValleyDifficulty_STORM(percentage)
    return 0.005
end


local function boulderValleyCurrent_STORM(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end
    return 300 + 200*quindoc.clamp(idk,-0.5,1) 
end

local function boulderValleyChainLengthCoefficient_STORM(percentage)
    return 1.15 - 0.05*quindoc.clamp(percentage,0,1)
end

local function boulderValleyStormIntensity_STORM(percentage)
    local idk = percentage

    if percentage < 0.6 then
        idk = percentage*1.66
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
    ["Coniferous Hills"] = {
        difficultyFunction = 0.02,
        current = coniferousHillsCurrent,
    },
    ["Autumn Grove"] = {
        difficultyFunction = 0.01,
        current = 0,
    },
    ["Storm Valley"] = {
        stormIntensity = boulderValleyStormIntensity_STORM,
        difficultyFunction = boulderValleyDifficulty_STORM,
        current = boulderValleyCurrent_STORM,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient_STORM,
    },
    ["Coniferous Highlands"] = {
        difficultyFunction = coniferousMountainsideDifficulty,
        current = 100,
    },
}



--riverGenerator:GetPercentageThrough(player.y)