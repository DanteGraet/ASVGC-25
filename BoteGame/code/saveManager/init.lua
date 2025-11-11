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
        if (key ~= "DEV" or not DEV) then   goto nextCatagory end
       
        savingSettings[key] = {}
        for setting, data in pairs(value) do
            savingSettings[key][setting] = data.value
        end

        ::nextCatagory::
    end

    dante.save(savingSettings, "save/settings.lua")
end

function saveManager.loadProfile(profileNumber)
    if unlocks then
        local currentProfile = settings.hidden.profile.value
        saveManager.saveProfile(currentProfile)
    end

    local profileToLoad = profileNumber or settings.hidden.profile.value
    unlocks = dante.load("save/profile" .. profileToLoad) or {}
    settings.hidden.profile.value = profileNumber
end

function saveManager.saveProfile(profileNumber)
    dante.save(unlocks, "save/profile" .. profileNumber)
end


if saveManager.isFirstLaunch then
    saveManager.saveSettings()

end

return saveManager