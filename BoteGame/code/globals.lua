-- load permenant stuff here
font.loadFont("font/fontBlack.ttf", "black")
font.loadFont("font/fontMedium.ttf", "medium")

menuManager = love.filesystem.load("code/menuManager/init.lua")() 
saveManager = love.filesystem.load("code/saveManager/init.lua")()

saveManager.loadSettings()
saveManager.loadProfile()

dialouge = love.filesystem.load("code/global/dialogoge.lua")() 

music = love.filesystem.load("code/global/music.lua")() 



assets = {}

love.physics.setMeter(100)
