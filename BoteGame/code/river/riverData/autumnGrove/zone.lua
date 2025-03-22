local function iceplainsCurrent(percentage)
    return 100*quindoc.clamp(percentage,0,1) + 100
end

local function boulderValleyDifficulty(percentage)
    return 0.0015 + 0.0035*quindoc.clamp(percentage,0,1)
end

local function boulderValleyWind(percentage)
    return 100 + 300*quindoc.clamp(percentage,0,1)
end

local function boulderValleySnow(percentage)
    return 10*quindoc.clamp(percentage,0,1) + 5
end

local function boulderValleyCurrent(percentage)
    return 200*quindoc.clamp(percentage,0,1) + 100
end

local function boulderValleyChainLengthCoefficient(percentage)
    return 1.35 - 0.2*quindoc.clamp(percentage,0,1)
end




local function boulderValleyDifficulty_STORM(percentage)
    return 0.005
end

local function boulderValleyWind_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 400 + 600*quindoc.clamp(idk,-0.2,1)
end

local function boulderValleySnow_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 23 + 20*quindoc.clamp(idk,-1,1)
end

local function boulderValleyCurrent_STORM(percentage)

    local idk = percentage

    if percentage < 0.8 then

        idk = percentage*1.25

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 300 + 200*quindoc.clamp(idk,-0.5,1) 
    
end

local function boulderValleyChainLengthCoefficient_STORM(percentage)
    return 1.15 - 0.05*quindoc.clamp(percentage,0,1)
end

local function boulderValleyStormIntensity_STORM(percentage)

    local idk = percentage

    if percentage < 0.6 then

        idk = percentage*1.66

    elseif percentage < 0.8 then

        idk = 1

    else

        idk = 1 - 2*((percentage - 0.8) * 5)

    end

    return 1000*quindoc.clamp(idk,0,1)
end

local function coniferousMountainsideDifficulty(percentage)

    if percentage > 0.9 then
        return 0
    else
        return 0.01
    end

end

local function icePlainsMusicManager()
    musicTracks[1].targetVolume = 1
    musicTracks[2].targetVolume = 1
    musicTracks[3].targetVolume = 0
    musicTracks[4].targetVolume = 0
    musicTracks[5].targetVolume = 0
    musicTracks[6].targetVolume = 0
end

local function boulderValleyMusicManager()
    musicTracks[1].targetVolume = 0
    musicTracks[2].targetVolume = 1
    musicTracks[3].targetVolume = 1
    musicTracks[4].targetVolume = 1
    musicTracks[5].targetVolume = 0
    musicTracks[6].targetVolume = 0
end

local function stormValleyMusicManager()

    local percentage 
    
    if type(zones[1]) == "table" and zones[2].displayName == "Storm Valley" then
        percentage = 0 
    else
        percentage = riverGenerator:GetPercentageThrough(player.y)
    end
    
    local stormish

    if percentage < 0.6 then
        stormish = quindoc.clamp(2*percentage*1.66,0,2)
    elseif percentage > 0.8 then
        stormish = 2 - quindoc.clamp(4*((percentage-0.8) * 5),0,2)
    else
        stormish = 2
    end


    musicTracks[1].targetVolume = 0
    musicTracks[2].targetVolume = math.max(1-stormish,0)
    musicTracks[3].targetVolume = math.max(1-stormish,0)
    musicTracks[4].targetVolume = math.max(1-stormish,0)
    musicTracks[5].targetVolume = math.max(stormish-1,0)
    musicTracks[6].targetVolume = quindoc.clamp(stormish,0,1)
    
end

local function coniferousMountainsideMusicManager()
    musicTracks[1].targetVolume = 1
    musicTracks[2].targetVolume = 0
    musicTracks[3].targetVolume = 0
    musicTracks[4].targetVolume = 0
    musicTracks[5].targetVolume = 0
    musicTracks[6].targetVolume = 0
end


return {
    {
        zone = "coniferousMountainside",
        subtitle = "-- Another Journey? --",
        displayName = "Coniferous Highlands",
        distanceTitle = "-- WOW!! --",
        distance = 10000,
        --difficultyFunction = coniferousMountainsideDifficulty,
        transition = 500,
        --current = 100,
        --snowAmount = 3,
        currentIcons = 2,
        --windSpeed = 300,
        --musicManager = coniferousMountainsideMusicManager,
    },
    {
        zone = "devZone2",
        displayName = "Ice Plains",
        distanceTitle = "Starting Point",
        subtitle = "River's Source",
        distance = 24700,
        --difficultyFunction = 0.01,
        transition = 300,
        --current = iceplainsCurrent,
        currentIcons = 2,
        --snowAmount = 5,
        --windSpeed = 200,
        --musicManager = icePlainsMusicManager,
    },
    {
        zone = "devZone",
        displayName = "Boulder Valley",
        distanceTitle = "-- 1.5KM --",
        subtitle = "Rock-Chain Gully",
        distance = 15000,
        --difficultyFunction = boulderValleyDifficulty,
        transition = 0,
        --snowAmount = boulderValleySnow,
        --windSpeed = boulderValleyWind,
        --current = boulderValleyCurrent,
        currentIcons = 3,
        --chainLengthCoefficient = boulderValleyChainLengthCoefficient,
        --musicManager = boulderValleyMusicManager,
    },
    {
        zone = "devZone2", --yes i know there is a file for the storm version. not using it yet
        displayName = "Storm Valley",
        subtitle = "Blizzard Approaching",
        distanceTitle = "-- 5KM --",
        distance = 49500,
        --stormIntensity = boulderValleyStormIntensity_STORM,
        --difficultyFunction = boulderValleyDifficulty_STORM,
        transition = 500,
        --snowAmount = boulderValleySnow_STORM,
        --windSpeed = boulderValleyWind_STORM,
        --current = boulderValleyCurrent_STORM,
        currentIcons = 4,
        --chainLengthCoefficient = boulderValleyChainLengthCoefficient_STORM,
        --musicManager = stormValleyMusicManager,
    },



}



--riverGenerator:GetPercentageThrough(player.y)