local function devZoneDifficulty(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 1
end

return {
    {
        zone = "devZone",
        distance = 1000,
        difficultyFunction = devZoneDifficulty,
        transition = 100,
    },
    {
        zone = "devZone2",
        distance = 1000,
        difficultyFunction = devZoneDifficulty,
        transition = 100,
    },
    {
        zone = "devZone",
        distance = 10000,
        difficultyFunction = devZoneDifficulty,
        transition = 100,
    },
    {
        zone = "devZone2",
        distance = 10000,
        difficultyFunction = devZoneDifficulty,
        transition = 100,
    }
}