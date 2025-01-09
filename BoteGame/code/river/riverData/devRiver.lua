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


local function boulderValleyMusicManager()
    musicTracks[1].targetVolume = 1
    musicTracks[2].targetVolume = 1
    musicTracks[3].targetVolume = 1
    musicTracks[4].targetVolume = 1
    musicTracks[5].targetVolume = 1
    musicTracks[6].targetVolume = 1
end

return {
    devZone = {
        -- the zone you want appearing first needs this flag
        isFirst = true,

        zone = "devZone",
        distance = {min = 1000, max = 10000},
        difficultyFunction = boulderValleyDifficulty,
        displayName = "Coniferous Highlands",
        transition = 400,
        snowAmount = 30,
        windSpeed = 200,
        stormIntensity = 0,
        nextZone = {"devZone2"},
        musicManager = boulderValleyMusicManager,

    },
    devZone2 = {
        zone = "devZone2",
        distance = {min = 1000, max = 10000},
        difficultyFunction = boulderValleyDifficulty,
        displayName = "Coniferous Highlands",
        transition = 400,
        snowAmount = 30,
        windSpeed = 200,
        stormIntensity = 0,
        nextZone = {"boulderValley", "icePlains"},
        musicManager = boulderValleyMusicManager,
    },

    boulderValley = {
        zone = "boulderValley",
        distance = {min = 1000, max = 2000},
        difficultyFunction = boulderValleyDifficulty,
        displayName = "Coniferous Highlands",
        transition = 400,
        snowAmount = 30,
        windSpeed = {min = 0, max = 50},
        stormIntensity = 0,
        nextZone = {"devZone2", "icePlains"},
        musicManager = boulderValleyMusicManager,
    },

    icePlains = {
        zone = "icePlains",
        distance = 2500,
        difficultyFunction = boulderValleyDifficulty,
        displayName = "Coniferous Highlands",
        transition = 400,
        snowAmount = 30,
        windSpeed = {min = 25, max = 50},
        stormIntensity = 0,
        nextZone = {"devZone", "boulderValley"},
        musicManager = boulderValleyMusicManager,
    },
}