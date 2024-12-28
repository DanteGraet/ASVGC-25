return {
    -- Add the stats? for each obstical here, not just the actual obsticals.
    {
        type = "random",     
        data = {
            hugeRock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 3,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
            bigRock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 4,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
            rock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 2,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
        }
    },
    {
        type = "timer",
        minTime = 1500,
        maxTime = 1700,        
        data = {
            leaderRock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 10,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
        }
    },
    {
        type = "difficultyIndependent",    
        chance = 0.1,
        data = {
            snowyTree = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 1,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
        }
    }
} 