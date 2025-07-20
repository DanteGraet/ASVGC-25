local function upperDamDifficulty(percentage)
    return 0.03 + 0.01*quindoc.clamp(percentage,0,1)
end

local function theInletCurrent(percentage)

    if percentage < 0.1 then
        local t = percentage*10
        local a = 150 + t * (350 - 150) --simple tween between both values
        return a

    elseif percentage > 0.9 then
        local t = (percentage-0.9)*10
        local a = 500 + t * (50 - 350)
        return a

    else
        return 500
    end

end

local function electricalComplexCurrent(percentage)

    return 50 + 100*quindoc.clamp(percentage,0,1)

end

local function exitElectricalCurrent(percentage)

    return 150 + 200*quindoc.clamp(percentage,0,1)

end

local function exitElectricalStormIntensity(percentage)

    return 800 - 800*quindoc.clamp(percentage,0,1)

end

local function theInletStormIntensity(percentage)

    return 400 + 400*quindoc.clamp(percentage,0,1)

end

return {
    ["Gravelly Plains"] = {
        stormIntensity = 400,
        difficultyFunction = 0.01,
        current = 180,
    },
    ["Ultra Dam"] = {
        stormIntensity = 400,
        difficultyFunction = upperDamDifficulty,
        current = 180,
    },
    ["Despicable Drainpipe"] = {
        stormIntensity = theInletStormIntensity,
        difficultyFunction = 0.01,
        current = theInletCurrent,
    },
    ["_Despicable Drainpipe"] = {
        stormIntensity = 800,
        difficultyFunction = 0,
        current = 50,
    },
    ["Electrical Complex Deluxe"] = {
        stormIntensity = 800,
        difficultyFunction = 0.015,
        current = electricalComplexCurrent,
    },
    ["_Electrical Complex Deluxe"] = {
        stormIntensity = exitElectricalStormIntensity,
        difficultyFunction = 0.015,
        current = exitElectricalCurrent,
    },
    ["River Mouth"] = {
        stormIntensity = 0,
        difficultyFunction = 0.015,
        current = 350,
    },
}



--riverGenerator:GetPercentageThrough(player.y)