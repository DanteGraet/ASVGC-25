return {
    -- Add the stats? for each obstical here, not just the actual obsticals.
    rock = {
        -- the base spawnWeight that this obstical has
        spawnWeight = 5,

        -- the amount the spawnWeight can change by (+- 1/2)
        weightChange = 2,

        -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
        noise = 2,

        -- divider for the noise.
        noiseDiv = 10
    } 
}