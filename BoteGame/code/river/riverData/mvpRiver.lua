local function boulderValleyDifficulty(percentage)
    return 0.0005 + 0.001*percentage
end

local function boulderValleyWind(percentage)
    return 100 + 300*percentage
end

local function boulderValleySnow(percentage)
    return 10 + 10*percentage
end

local function boulderValleyCurrent(percentage)
    return 400*percentage + 100
end

local function boulderValleyChainLengthCoefficient(percentage)
    return 1.35 - 0.2*percentage
end


return {
    {
        zone = "boulderValley",
        distance = 15000,
        difficultyFunction = boulderValleyDifficulty,
        transition = 400,
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
        current = boulderValleyCurrent,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient
    },
}



--riverGenerator:GetPercentageThrough(player.y)