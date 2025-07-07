return {
    -- Add the stats? for each obstical here, not just the actual obsticals.
    {
        type = "random",     
        data = {
            bigRock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 2,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,
    --[[        subordinateCog = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 1,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
            } ,]]
        }
    },
    --[[{
        type = "timer",
        data = {

            movingCog = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 1,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
                
            } ,


        },
        minTime = 100,
        maxTime = 200,
    }]]
    {
        type = "difficultyIndependent",    
        chance = 0.3,
        isFront = true,
        data = {
            autumnTree = {
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
  --[[  {
        type = "timer",    
        maxTime = 2000,
        minTime = 1500,
        data = {
                hugeCog = {
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
    }]]




} 
