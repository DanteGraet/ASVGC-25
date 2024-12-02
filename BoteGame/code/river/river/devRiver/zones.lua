local function devZoneDifficulty(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 1
end

return {
    {
        zone = "devZone",
        distance = 100,
        difficultyFunction = devZoneDifficulty
    }
}