local zone          = 1

local areaHard      = 4
local areaNormal    = 4
local areaRest      = 2.7

local rest          = 0.7
local normal        = 0.7
local hard          = 0.5

return {
    start = {
        zone = "icePlains",
        displayName = "Ice Plains",
        subtitle = "",

        distance = {min = 5000, max = 7500},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = zone},      -- rest
            {name = "boulderValley",    weight = areaNormal},      -- normal
            {name = "stormValley",      weight = areaHard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,

        isFirst = true
    },

    icePlains = {
        zone = "icePlains",
        displayName = "Ice Plains",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = zone},      -- rest
            {name = "boulderValley",    weight = areaNormal},      -- normal
            {name = "stormValley",      weight = areaHard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    boulderValley = {
        zone = "boulderValley",
        displayName = "Boulder Valley",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = areaRest},      -- rest
            {name = "boulderValley",    weight = zone},      -- normal
            {name = "stormValley",      weight = areaHard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    stormValley = {
        zone = "stormValley",
        displayName = "Storm Valley",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = areaRest},      -- rest
            {name = "boulderValley",    weight = areaNormal},      -- normal
            {name = "stormValley",      weight = zone},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },


    coniferousHills = {
        zone = "coniferousHills",
        displayName = "Wooded Hills",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = zone},      -- rest
            {name = "autumnGrove",      weight = areaNormal},      -- normal
            {name = "clockworkRuins",   weight = areaNormal},      -- normal
            {name = "clockworkCore",    weight = areaHard},      -- hard
            {name = "autumnRapids",     weight = areaNormal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    autumnGrove = {
        zone = "autumnGrove",
        displayName = "Autumn Grove",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = areaRest},      -- rest
            {name = "autumnGrove",      weight = zone},      -- normal
            {name = "clockworkRuins",   weight = areaNormal},      -- normal
            {name = "clockworkCore",    weight = areaHard},      -- hard
            {name = "autumnRapids",     weight = areaNormal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    clockworkRuins = {
        zone = "clockworkRuins",
        displayName = "Clockwork Ruins",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = areaRest},      -- rest
            {name = "autumnGrove",      weight = areaNormal},      -- normal
            {name = "clockworkRuins",   weight = zone},      -- normal
            {name = "clockworkCore",    weight = areaNormal},      -- hard
            {name = "autumnRapids",     weight = areaNormal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    clockworkCore = {
        zone = "clockworkCore",
        displayName = "Clockwork's Core",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = areaRest},      -- rest
            {name = "autumnGrove",      weight = areaNormal},      -- normal
            {name = "clockworkRuins",   weight = areaNormal},      -- normal
            {name = "clockworkCore",    weight = zone},      -- hard
            {name = "autumnRapids",     weight = areaNormal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },
    autumnRapids = {
        zone = "autumnRapids",
        displayName = "Autumn Rapids",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = areaRest},      -- rest
            {name = "autumnGrove",      weight = areaNormal},      -- normal
            {name = "clockworkRuins",   weight = areaNormal},      -- normal
            {name = "clockworkCore",    weight = areaHard},      -- hard
            {name = "autumnRapids",     weight = zone},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = rest},      -- rest
            {name = "upperDam",         weight = normal},      -- normal
            {name = "theInlet",         weight = hard},      -- hard
            {name = "electricalComplex",weight = hard},      -- hard
            {name = "lowerDam",         weight = hard},      -- hard
            },
        currentIcons = 2,
    },


    gravellyPlains = {
        zone = "gravellyPlains",
        displayName = "Gravelly Plains",
        subtitle = "",

        distance = {min = 7500, max = 12500},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = zone},      -- rest
            {name = "upperDam",         weight = areaNormal},      -- normal
            {name = "theInlet",         weight = areaHard},      -- hard
            {name = "electricalComplex",weight = areaHard},      -- hard
            {name = "lowerDam",         weight = areaHard},      -- hard
            },
        currentIcons = 2,
    },
    upperDam = {
        zone = "upperDam",
        displayName = "Upper Dam",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = areaRest},      -- rest
            {name = "upperDam",         weight = zone},      -- normal
            {name = "theInlet",         weight = areaHard},      -- hard
            {name = "electricalComplex",weight = areaHard},      -- hard
            {name = "lowerDam",         weight = areaHard},      -- hard
            },
        currentIcons = 2,
    },
    electricalComplex = {
        zone = "electricalComplex",
        displayName = "Electrical Powerhouse",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = areaRest},      -- rest
            {name = "upperDam",         weight = areaNormal},      -- normal
            {name = "theInlet",         weight = areaHard},      -- hard
            {name = "electricalComplex",weight = zone},      -- hard
            {name = "lowerDam",         weight = areaHard},      -- hard
            },
        currentIcons = 2,
    },
    theInlet = {
        zone = "theInlet",
        displayName = "The Inlet",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = areaRest},      -- rest
            {name = "upperDam",         weight = areaNormal},      -- normal
            {name = "theInlet",         weight = zone},      -- hard
            {name = "electricalComplex",weight = areaHard},      -- hard
            {name = "lowerDam",         weight = areaHard},      -- hard
            },
        currentIcons = 2,
    },
    lowerDam = {
        zone = "lowerDam",
        displayName = "Lower Dam",
        subtitle = "",

        distance = {min = 10000, max = 15000},
        transition = 300,

        nextZone = {
            --Forsted Channel
            {name = "icePlains",        weight = rest},      -- rest
            {name = "boulderValley",    weight = normal},      -- normal
            {name = "stormValley",      weight = hard},      -- hard

            --Autumn Grove
            {name = "coniferousHills",  weight = rest},      -- rest
            {name = "autumnGrove",      weight = normal},      -- normal
            {name = "clockworkRuins",   weight = normal},      -- normal
            {name = "clockworkCore",    weight = hard},      -- hard
            {name = "autumnRapids",     weight = normal},      -- normal
                
            --The Dam
                -- Other Zone
            {name = "gravellyPlains",   weight = areaRest},      -- rest
            {name = "upperDam",         weight = areaNormal},      -- normal
            {name = "theInlet",         weight = areaHard},      -- hard
            {name = "electricalComplex",weight = areaHard},      -- hard
            {name = "lowerDam",         weight = zone},      -- hard
            },
        currentIcons = 2,
    },
}



--riverGenerator:GetPercentageThrough(player.y)