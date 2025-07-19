--local function coniferousHillsCurrent(percentage)
--    return 200*quindoc.clamp(percentage,0,1) + 300
--end

local function gruelingGroveCurrent(percentage)

    if percentage < 0.8 then

        return 250+150*percentage

    else

        return 350-150*((percentage-0.8)*5)

    end

end

local function ruinsStormIntensity(percentage)

    return 400 + 400*percentage

end

local function exitStormIntensity(percentage)

    return 800-800*percentage

end


return {
    ["Wooded Hills"] = {
        difficultyFunction = 0.008,
        current = 250,
        stormIntensity = 400
    },
    ["Grueling Grove"] = {
        difficultyFunction = 0.004,
        current = gruelingGroveCurrent,
        stormIntensity = 400,
        chainLengthCoefficient = 1.25
    },
    ["Ruins of Regret"] = {
        difficultyFunction = 0.026,
        current = 250,
        stormIntensity = ruinsStormIntensity
    },
    ["Clockwork Catastrophe"] = {
        difficultyFunction = 0.05,
        current = 100,
        stormIntensity = 800
    },
    ["_Clockwork Catastrophe"] = {
        difficultyFunction = 0.007,
        current = 150,
        stormIntensity = exitStormIntensity
    },
    ["Gravelly Plains"] = {
        difficultyFunction = 0.005,
        current = 150,
    },
}



--riverGenerator:GetPercentageThrough(player.y)