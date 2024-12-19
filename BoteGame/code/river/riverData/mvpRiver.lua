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


return {
    {
        zone = "boulderValley",
        distance = 15000,
        difficultyFunction = boulderValleyDifficulty,
        transition = 400,
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
        current = boulderValleyCurrent
    },
}



--riverGenerator:GetPercentageThrough(player.y)