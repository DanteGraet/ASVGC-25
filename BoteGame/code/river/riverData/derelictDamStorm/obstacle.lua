local function upperDamDifficulty(percentage)
    return 0.02 + 0.01*quindoc.clamp(percentage,0,1)*1.5
end

local function theInletCurrent(percentage)

    if percentage < 0.1 then
        local t = percentage*10
        local a = 150 + t * (500 - 150) --simple tween between both values
        return a

    elseif percentage > 0.9 then
        local t = (percentage-0.9)*10
        local a = 500 + t * (50 - 500)
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
        difficultyFunction = 0.02,
        current = 200,
    },
    ["Upper Dam"] = {
        difficultyFunction = upperDamDifficulty,
        current = 150,
    },
    ["The Inlet"] = {
        difficultyFunction = 0.02,
        current = theInletCurrent,
    },
    ["Electrical Complex"] = {
        difficultyFunction = 0.03,
        current = electricalComplexCurrent,
    },
}



--riverGenerator:GetPercentageThrough(player.y)