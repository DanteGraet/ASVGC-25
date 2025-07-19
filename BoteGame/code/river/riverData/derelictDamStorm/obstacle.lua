local function upperDamDifficulty(percentage)
    return 0.02 + 0.01*quindoc.clamp(percentage,0,1)
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

    return 300 - 300*quindoc.clamp(percentage,0,1)

end

local function theInletStormIntensity(percentage)

    return 200 + 100*quindoc.clamp(percentage,0,1)

end

return {
    ["Gravelly Plains"] = {
        stormIntensity = 200,
        difficultyFunction = 0.01,
        current = 150,
    },
    ["Upper Dam"] = {
        stormIntensity = 200,
        difficultyFunction = upperDamDifficulty,
        current = 150,
    },
    ["The Inlet"] = {
        stormIntensity = theInletStormIntensity,
        difficultyFunction = 0.01,
        current = theInletCurrent,
    },
    ["_The Inlet"] = {
        stormIntensity = 300,
        difficultyFunction = 0,
        current = 50,
    },
    ["Electrical Complex"] = {
        stormIntensity = 300,
        difficultyFunction = 0.015,
        current = electricalComplexCurrent,
    },
    ["_Electrical Complex"] = {
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