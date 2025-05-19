require("templateLib/quindoc")
require("templateLib/dante")

font = require("templateLib/fontSystem")
font.loadFont("font/fontBlack.ttf", "black")
font.loadFont("font/fontMedium.ttf", "medium")

tweens = require("templateLib/tweens")
buttons = require("templateLib/graetUi")
particles = require("templateLib/particle")
--particles.loadParticleClasses = require("particleConf")
audioPlayer = require("templateLib/audioManager")




require("code/dynamicLoading")

require("code/river/effects/spawnSnow")
require("code/river/effects/playerTrail")
require("code/river/effects/zoneTitle")

require("code/music")

-- Global variables
assets = {}