local function coniferousHillsCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 300
end


return {
    ["Coniferous Hills"] = {
        difficultyFunction = 0.02,
        current = coniferousHillsCurrent,
    },
    ["Autumn Grove"] = {
        difficultyFunction = 0.01,
        current = 0,
    },
    ["Clockwork's Core"] = {
        difficultyFunction = 0.1,
        current = 100,
    },
}



--riverGenerator:GetPercentageThrough(player.y)