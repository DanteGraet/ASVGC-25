return {
    crossFadeSpeed = 0.3,
    tracks = {  -- Starting Values
        [1] = "music/theDam/drone.mp3",
        [2] = "music/theDam/chords.mp3", 
        [3] = "music/theDam/cymbals.mp3",
        [4] = "music/theDam/upperBackingV2.mp3",
        [5] = "music/theDam/secondHalfBackingV3.mp3",
        [6] = "music/theDam/electricalMelodyV2.mp3",
    },
    zones = {
        ["Gravelly Plains"] =        {1,0,0,0,0,0},
        ["Upper Dam"] =              {0.8,0.8,0.6,1,0,0},
        ["The Inlet"] =              {0,0.7,0.7,0,1.1,0},
        ["_The Inlet"] =              {0,0.7,0.7,0,1.1,0},
        ["Electrical Complex"] =     {0,0,1,0,1.2,1.2},
        ["_Electrical Complex"] =     {0,0,1,0,1.2,1.2},
        ["River Mouth"] =            {1,0,0,0,0,0},
    }
}