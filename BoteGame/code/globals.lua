-- load permenant stuff here
font.loadFont("font/fontBlack.ttf", "black")
font.loadFont("font/fontMedium.ttf", "medium")

dialouge = love.filesystem.load("code/global/dialogoge.lua")() 
music = love.filesystem.load("code/global/music.lua")() 


settings = love.filesystem.load("code/menu/defaultSettings.lua")()
local savedSettings = dante.load("save/settings")

local function mergeCatagories(catagory, savedSettings)
    for key, value in pairs(savedSettings) do
        if not catagory[key] then return end

        settings[catagory][key].value = savedSettings[catagory][key]
    end
end

local function mergeSettings(settings, savedSettings)
    if not savedSettings then return end

    for catagory, settingList in pairs(settings) do
        if (catagory == "DEV" and not DEV) or catagory == "order" then goto nextCatagory end
        if not savedSettings[catagory] then goto nextCatagory end
        -- looking though all saved setting with the current SetCatagory
        mergeCatagories(settings[catagory], savedSettings[catagory])
        
        ::nextCatagory::
    end
end
mergeSettings(settings, savedSettings)


assets = {}

love.physics.setMeter(100)
