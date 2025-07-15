
return {
    {
        zone = "gravellyPlains",
        displayName = "Gravelly Plains",
        distanceTitle = "Starting Point",
        subtitle = "Rocky Lowlands",
        distance = 5000,--should be 4500 after

        transition = 0,

        currentIcons = 2,
    },
    {
        zone = "upperDam",
        displayName = "Upper Dam",
        distanceTitle = "-- 1.5KM --",
        subtitle = "Rocky Reservoir",
        distance = 15000,

        transition = 0,

        currentIcons = 2,

    },
    {
        zone = "theInlet",
        displayName = "The Inlet",
        subtitle = "Passing the Floodgates",
        distanceTitle = "-- 5KM --",
        distance = 20000,

        transition = 0,

        currentIcons = 4,

    },
    {
        zone = "lowerDam",
        subtitle = "High-voltage Powerhouse",
        displayName = "Electrical Complex",
        distanceTitle = "",
        distance = 10000,

        transition = 0,

        currentIcons = 1,
    },


}



--riverGenerator:GetPercentageThrough(player.y)