local function boulderValleyDifficulty(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 0.005
end

local function devZoneDifficulty(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 0.01
end

local function devZoneDifficulty2(percentage)
    -- a function that SHOULD increase the return amount if hard mode is active
    -- might want to add a dicciculty curve also with math so...
    return 0.1
end

return {
    {
        zone = "devZone",
        distance = 1000,
        difficultyFunction = boulderValleyDifficulty,
        transition = 400,
        snowAmount = 30,
        windSpeed = 200,
        stormIntensity = 1000
    },
}