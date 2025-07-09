--local function coniferousHillsCurrent(percentage)
--    return 200*quindoc.clamp(percentage,0,1) + 300
--end

local function autumnRapidsCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 200 + 100*quindoc.clamp(percentage*10,0,1)
end


return {
    ["Wooded Hills"] = {
        difficultyFunction = 0.005,
        current = 150,
    },
    ["Autumn Grove"] = {
        difficultyFunction = 0.01,
        current = 200,
    },
    ["Clockwork Ruins"] = {
        difficultyFunction = 0.02,
        current = 200,
    },
    ["Clockwork's Core"] = {
        difficultyFunction = 0.1,
        current = 100,
    },
    ["Autumn Rapids"] = {
        difficultyFunction = 0.01,
        current = autumnRapidsCurrent,
    },
}



--riverGenerator:GetPercentageThrough(player.y)