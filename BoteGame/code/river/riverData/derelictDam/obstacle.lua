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

return {
    ["Gravelly Plains"] = {
        stormIntensity = 200,
        difficultyFunction = 0.01,
        current = 200,
    },
    ["Upper Dam"] = {
        stormIntensity = 200,
        difficultyFunction = upperDamDifficulty,
        current = 150,
    },
    ["The Inlet"] = {
        stormIntensity = 200,
        difficultyFunction = 0.01,
        current = theInletCurrent,
    },
    ["Electrical Complex"] = {
        stormIntensity = 300,
        difficultyFunction = 0.015,
        current = electricalComplexCurrent,
    },
}



--riverGenerator:GetPercentageThrough(player.y)