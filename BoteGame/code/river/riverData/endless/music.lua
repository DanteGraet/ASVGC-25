-- placeholder
return {
    crossFadeSpeed = 0.3,
    tracks = {  -- Starting Values
        [1] = "music/mvpRiver/townChordsV2.mp3",
        [2] = "music/mvpRiver/snowMelodyV2.mp3",
        [3] = "music/mvpRiver/valleyChords.mp3",
        [4] = "music/mvpRiver/valleyDrums.mp3",
        [5] = "music/mvpRiver/stormMelodyV2.mp3",
        [6] = "music/mvpRiver/stormDrumsChordsV3.mp3",
    },
    zones = {
        ["Ice Plains"] =            {1,1,0,0,0,0},
        ["Boulder Valley"] =        {0,1,1,1,0,0},
        ["Storm Valley"] =          {0,0,0,0,1,1},
        ["Wooded Hills"] =          {1,0,0,0,0,0},


        ["Autumn Grove"] =          {0,1,1,0,0,0},
        ["Clockwork Ruins"] =       {0,1,1,0,0,0},
        ["Clockwork's Core"] =      {0,1,1,1,0,0},
        ["Autumn Rapids"] =         {0,1,1,1,0,0},


        ["Gravelly Plains"] =       {1,0,0,0,0,0},
        ["Upper Dam"] =             {0,1,1,1,0,0},
        ["The Inlet"] =             {0,0,0,0,0,1},
        ["Electrical Complex"] =    {0,0,0,0,1,1},
    }
}