return {
    crossFadeSpeed = 0.3,
    tracks = {  -- Starting Values
        [1] = "music/autumnGrove/forestChords.mp3",
        [2] = "music/autumnGrove/forestStrings.mp3",
        [3] = "music/autumnGrove/forestLead.mp3",
        [4] = "music/autumnGrove/clockworkChords.mp3",
        [5] = "music/autumnGrove/clockworkDrums.mp3",
        [6] = "music/autumnGrove/ruinsLead.mp3",
    },
    zones = {
        ["Wooded Hills"] =         {0.9,0,0,0,0,0},
        ["Grueling Grove"] =         {0.9,0.65,0.9,0,0,0.9},
        ["Ruins of Regret"] =      {0,0,0,0.8,0,0.9},
        ["Clockwork Catastrophe"] =     {0,0,0,0.8,0.9,0.9},
        ["_Clockwork Catastrophe"] =        {0.9,0.65,0.9,0,0.9,0.9},
        ["Gravelly Plains"] =      {0.9,0,0,0,0,0},
    }
}