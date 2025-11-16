print("Checking Unlocks ...")
local rn = riverName
if isStorm then
    rn = riverName .. "Storm"
end
-- this should only run if the player has "Won" the levels

if not currentProfile.beatenLevels then currentProfile.beatenLevels = {} end
if not currentProfile.unlockedLevels then currentProfile.unlockedLevels = {} end

if rn == "derelictDam" then
    if not currentProfile.beatenLevels[rn] then

        gameStateManager.setGameState("responsiveLoading", nil, "credits")

        playCredits = true
    end
end

if rn == "frostedChannel" then
    currentProfile.unlockedLevels.autumnGrove = true
    currentProfile.unlockedLevels.frostedChannelStorm = true

    if not currentProfile.beatenLevels[rn] then
        dialouge.schedule("image/levelSelect/dialouge/dialouge2.png")
    end
end

if rn == "autumnGrove" then
    currentProfile.unlockedLevels.derelictDam = true
    currentProfile.unlockedLevels.autumnGroveStorm = true
end

if rn == "derelictDam" then
    currentProfile.unlockedLevels.derelictDamStorm = true
    currentProfile.unlockedLevels.endless = true

    if not currentProfile.beatenLevels[rn] then
        dialouge.schedule("image/levelSelect/dialouge/dialouge3.png")
    end
end

currentProfile.beatenLevels[rn] = true

local b = currentProfile.beatenLevels
if b.frostedChannelStorm and b.autumnGroveStorm and b.derelictDamStorm then

    if not currentProfile.unlockedLevels.seenDialouge4 then
        dialouge.schedule("image/levelSelect/dialouge/dialouge4.png")
    end

    currentProfile.unlockedLevels.seenDialouge4 = true 
end


saveManager.saveProfile()
