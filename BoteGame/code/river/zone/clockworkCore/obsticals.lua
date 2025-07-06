return {
    -- Add the stats? for each obstical here, not just the actual obsticals.
    {
        type = "random",     
        data = {
            subordinateCog = {
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
    },
    {
        type = "timer",    
        maxTime = 2000,
        minTime = 1500,
        data = {
                hugeCog = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 30,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 1
            
            } ,
        }
    }




} 
