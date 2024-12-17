local function boulderValleyDifficulty(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 0.005
end


return {
    {
        zone = "boulderValley",
        distance = 25000,
        difficultyFunction = boulderValleyDifficulty,
        transition = 400,
        snowAmount = 30,
        windSpeed = 200,
    },
}