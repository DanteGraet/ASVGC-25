return {

    {
        type = "load",   
        data = {
                noSpawnRect = {} ,
                noSpawnSphere = {} ,
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

            spinnerLeader = {
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
        minTime = 700,
        maxTime = 900,
    },

    {
        type = "random",
        data = {

            rock = {
                -- the base spawnWeight that this obstical has
                spawnWeight = 6,

                -- the amount the spawnWeight can change by (+- 1/2)
                weightChange = 0,

                -- the noise value that will controll the spawnWeight, if you want things to have the same spawnWeight, use the same noise values :/
                noise = 2,

                -- divider for the noise.
                noiseDiv = 10
                
            } ,

            bigRock = {
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
    },




} 
