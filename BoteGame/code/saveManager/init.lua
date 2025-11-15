local saveManager = {}
saveManager.isFirstLaunch = not love.filesystem.getInfo("save", "directory")

local function mergeCatagories(catagory, savedSettings)
    for key, value in pairs(savedSettings) do
        if not catagory[key] then return end
        catagory[key].value = savedSettings[key]
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

function saveManager.loadSettings()
    settings = love.filesystem.load("code/saveManager/defaultSettings.lua")()

    local savedSettings = dante.load("save/settings.lua")
    
    mergeSettings(settings, savedSettings)
end

function saveManager.saveSettings()
    local savingSettings = {}

    for key, value in pairs(settings) do
        if key == "order" then              goto nextCatagory end
        if (key == "DEV" and not DEV) then   goto nextCatagory end
       
        savingSettings[key] = {}

        for setting, data in pairs(value) do

            savingSettings[key][setting] = data.value
        end

        ::nextCatagory::
    end
    dante.save(savingSettings, "save/settings.lua")
end

function saveManager.loadProfile(profileNumber)
    if currentProfile then
        local profile = settings.hidden.profile.value
        saveManager.saveProfile(profile)
    end

    local profileToLoad = profileNumber or settings.hidden.profile.value
    currentProfile = dante.load("save/profile" .. profileToLoad) or {
        unlockedLevels = {
            frostedChannel = true
        }
    }
    
    -- just in case someone sacked 
    if not currentProfile.unlockedLevels then
        currentProfile.unlockedLevels = {}
    end
    if not currentProfile.unlockedLevels.frostedChannel then
        currentProfile.unlockedLevels.frostedChannel = true
    end
    settings.hidden.profile.value = profileToLoad
end

function saveManager.saveProfile(profileNumber)
    dante.save(currentProfile, "save/profile" .. (profileNumber or settings.hidden.profile.value))
end

function saveManager.updateHighScore(newScore)
    if not currentProfile.highscore then
        currentProfile.highscore = {}
    end
    --print("--- updating high score")

    local rn = riverName
    if isStorm then
        rn = rn .. "Storm"
    end
    if not currentProfile.highscore[rn] then
        currentProfile.highscore[rn] = {}
    end

    if newScore then
        table.insert(currentProfile.highscore[rn], newScore)
    end
    table.sort(currentProfile.highscore[rn], function(a, b) return a > b end)

    if currentProfile.highscore[rn] then
        dante.save(currentProfile.highscore, "save/highscore.lua")
    end

    -- only store 6 records
    if #currentProfile.highscore[rn] > 6 then
        while #currentProfile.highscore[rn] > 6 do
            table.remove(currentProfile.highscore[rn], #currentProfile.highscore[rn])
        end
    end
end



if saveManager.isFirstLaunch then
    saveManager.saveSettings()
end

return saveManager