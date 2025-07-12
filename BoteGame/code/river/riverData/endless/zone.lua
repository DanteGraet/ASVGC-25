local zone          = 1

local areaHard      = 4
local areaNormal    = 4
local areaRest      = 2.7

local rest          = 0.7
local normal        = 0.7
local hard          = 0.7

local frostCount = 3
local autumnCount = 4
local damCount = 5

local count = {
    frost = 3,
    autumn = 5,
    dam = 4,
    total = 12
}

local zoneDefaultWeight = {
    {name = "icePlains",        weight = 1},      -- rest
    {name = "boulderValley",    weight = 1},      -- normal
    {name = "stormValley",      weight = 1},      -- hard

    --Autumn Grove
    {name = "coniferousHills",  weight = 1},      -- rest
    {name = "autumnGrove",      weight = 1},      -- normal
    {name = "clockworkRuins",   weight = 1},      -- normal
    {name = "clockworkCore",    weight = 1},      -- hard
    {name = "autumnRapids",     weight = 1},      -- normal
        
    --The Dam
        -- Other Zone
    {name = "gravellyPlains",   weight = 1},      -- rest
    {name = "upperDam",         weight = 1},      -- normal
    {name = "theInlet",         weight = 1},      -- hard
    {name = "lowerDam",         weight = 1},      -- hard
}

local expectedDifficulty = 0
local continuityBonus = 7/5
local function calculateWeight(self)
    if self[1].difficulty == "rest" then
        expectedDifficulty = expectedDifficulty + 3
    elseif self[1].difficulty == "hard" then
        expectedDifficulty = expectedDifficulty - 5
    else
        expectedDifficulty = expectedDifficulty + 0.2
    end

    for i = 1,#zoneDefaultWeight do
        local z = data[zoneDefaultWeight[i].name]
        local w = 1

        -- difficulty bonus
        if z.difficulty == "rest" then
            w = w + 10/(expectedDifficulty+1) - self[2]/25
        elseif z.difficulty == "hard" then
            w = w + math.max(-60/(expectedDifficulty+1) + 10 + self[2]/20, 0)
        else    -- should default to normal
            w = w + math.max(-10/(expectedDifficulty+1) + 5 + self[2]/15, 0)
        end

        if z.area == self[1].area then
            w = w*continuityBonus/(count[z.area]/count.total)
        end
        if z.zone == self[1].zone then
            w = w*0.1
        end

        zoneDefaultWeight[i].weight = math.max(w, 0)
    end

    return zoneDefaultWeight
end

return {
    start = {
        difficulty = "rest",
        area = "frost",

        zone = "icePlains",
        displayName = "Ice Plains",
        subtitle = "",

        distance = {min = 5000, max = 7500},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,

        isFirst = true
    },

    icePlains = {
        area = "frost",

        zone = "icePlains",
        displayName = "Ice Plains",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    boulderValley = {
        area = "frost",

        zone = "boulderValley",
        displayName = "Boulder Valley",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    stormValley = {
        area = "frost",

        difficulty = "hard",

        zone = "stormValley",
        displayName = "Storm Valley",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },


    coniferousHills = {
        area = "autumn",

        difficulty = "rest",

        zone = "coniferousHills",
        displayName = "Wooded Hills",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    autumnGrove = {
        area = "autumn",

        zone = "autumnGrove",
        displayName = "Autumn Grove",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    clockworkRuins = {
        area = "autumn",

        zone = "clockworkRuins",
        displayName = "Clockwork Ruins",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    clockworkCore = {
        area = "autumn",

        difficulty = "hard",

        zone = "clockworkCore",
        displayName = "Clockwork's Core",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    autumnRapids = {
        area = "autumn",

        zone = "autumnRapids",
        displayName = "Autumn Rapids",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },


    gravellyPlains = {
        area = "dam",

        difficulty = "rest",

        zone = "gravellyPlains",
        displayName = "Gravelly Plains",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    upperDam = {
        area = "dam",

        zone = "upperDam",
        displayName = "Upper Dam",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },

    theInlet = {
        area = "dam",

        difficulty = "hard",

        zone = "theInlet",
        displayName = "The Inlet",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
    lowerDam = {
        area = "dam",

        difficulty = "hard",

        zone = "lowerDam",
        displayName = "Electrical Complex",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = calculateWeight,
        currentIcons = 2,
    },
}



--riverGenerator:GetPercentageThrough(player.y)