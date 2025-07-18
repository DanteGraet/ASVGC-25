--local function coniferousHillsCurrent(percentage)
--    return 200*quindoc.clamp(percentage,0,1) + 300
--end

local function autumnRapidsCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 100 + 100*quindoc.clamp(percentage*10,0,1)
end


return {
    ["Wooded Hills"] = {
        difficultyFunction = 0.008,
        current = 150,
    },
    ["Autumn Grove"] = {
        difficultyFunction = 0.006,
        current = 250,
    },
    ["Clockwork Ruins"] = {
        difficultyFunction = 0.012,
        current = 200,
    },
    ["Clockwork's Core"] = {
        difficultyFunction = 0.05,
        current = 100,
    },
    ["Autumn Rapids"] = {
        difficultyFunction = 0.007,
        current = autumnRapidsCurrent,
    },
    ["Gravelly Plains"] = {
        difficultyFunction = 0.005,
        current = 150,
    },
}



--riverGenerator:GetPercentageThrough(player.y)