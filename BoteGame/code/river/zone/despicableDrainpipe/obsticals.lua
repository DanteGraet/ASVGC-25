return {

    {
        type = "load",   
        data = {
                noSpawnRect = {} ,
                noSpawnSphere = {} ,
        }
    },

    {
        type = "difficultyIndependent",    
        chance = 0.4,
        isFront = true,
        data = {
            hillsTree = {
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
        data = {

            spinner = {
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
        minTime = 500,
        maxTime = 600,
    },


} 
