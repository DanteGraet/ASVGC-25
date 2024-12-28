local function boulderValleyDifficulty(percentage)
    return 0.0015 + 0.0035*quindoc.clamp(percentage,0,1)
end

local function boulderValleyWind(percentage)
    return 100 + 300*quindoc.clamp(percentage,0,1)
end

local function boulderValleySnow(percentage)
    return 10*quindoc.clamp(percentage,0,1)
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

local function boulderValleyWind_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 400 + 600*quindoc.clamp(idk,-0.5,1)
end

local function boulderValleySnow_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 13 + 27*quindoc.clamp(idk,-0.3,1)
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
    return 1.15 - 0.15*quindoc.clamp(percentage,0,1)
end

local function boulderValleyStormIntensity_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 1000*quindoc.clamp(idk,0,1)
end


return {

    {
        zone = "boulderValley",
        distance = 30000,
        difficultyFunction = boulderValleyDifficulty,
        transition = 1,
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
        current = boulderValleyCurrent,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient
    },
    {
        zone = "boulderValley", --yes i know there is a file for the storm version. not using it yet
        distance = 50000,
        stormIntensity = boulderValleyStormIntensity_STORM,
        difficultyFunction = boulderValleyDifficulty_STORM,
        transition = 500,
        snowAmount = boulderValleySnow_STORM,
        windSpeed = boulderValleyWind_STORM,
        current = boulderValleyCurrent_STORM,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient_STORM
    },
    {
        zone = "mvpForest",
        distance = 10000,
        difficultyFunction = 0.01,
        transition = 0,
        current = 100,
    },

}



--riverGenerator:GetPercentageThrough(player.y)