local function iceplainsCurrent(percentage)
    return 100*quindoc.clamp(percentage,0,1) + 100
end

local function boulderValleyDifficulty(percentage)
    return 0.0015 + 0.0035*quindoc.clamp(percentage,0,1)
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


return {
    icePlains = {
        zone = "icePlains",
        displayName = "Ice Plains",
        distanceTitle = "-- hmm --",
        subtitle = "River's Source",

        distance = {min = 3000, max = 10000},
        transition = 300,

        nextZone = {"boulderValley", "coniferousMountainside"},
        currentIcons = 2,

        isFirst = true
    },
    boulderValley = {
        zone = "boulderValley",
        displayName = "Boulder Valley",
        distanceTitle = "-- okie? --",
        subtitle = "Rock-Chain Gully",
        distance = {min = 5000, max = 25000},
        transition = 300,

        nextZone = {"boulderValley2", "coniferousMountainside", "icePlains"},
        currentIcons = 3,
    },
    boulderValley2 = {
        zone = "boulderValley", --yes i know there is a file for the storm version. not using it yet
        displayName = "Storm Valley",
        subtitle = "Blizzard Approaching",
        distanceTitle = "-- nope --",

        distance = {min = 5000, max = 25000},
        transition = 300,

        nextZone = {"boulderValley", "coniferousMountainside"},
        currentIcons = 4,
    },
    coniferousMountainside = {
        zone = "coniferousMountainside",
        subtitle = "-- haha --",
        displayName = "Coniferous Highlands",
        distanceTitle = "-- huh> --",

        distance = {min = 5000, max = 20000},
        transition = 300,

        nextZone = {"boulderValley", "icePlains"},
        currentIcons = 2,
    },


}



--riverGenerator:GetPercentageThrough(player.y)