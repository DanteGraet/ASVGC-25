print("Checking Unlocks ...")
local rn = riverName
if isStorm then
    rn = riverName .. "Storm"
end
-- this should only run if the player has "Won" the levels

if not assets.code.player.unlocks.beatenLevels then assets.code.player.unlocks.beatenLevels = {} end

if rn == "derelictDam" then
    if not assets.code.player.unlocks.beatenLevels[rn] then
        playCredits = true
    end
end

if rn == "frostedChannel" then
    assets.code.player.unlocks.levels.autumnGrove = true
    assets.code.player.unlocks.levels.frostedChannelStorm = true

    if not assets.code.player.unlocks.beatenLevels[rn] then
        dialouge.schedule("image/levelSelect/dialouge/dialouge2.png")
    end
end

if rn == "autumnGrove" then
    assets.code.player.unlocks.levels.derelictDam = true
    assets.code.player.unlocks.levels.autumnGroveStorm = true
end

if rn == "derelictDam" then
    assets.code.player.unlocks.levels.derelictDamStorm = true
    assets.code.player.unlocks.levels.endless = true

    if not assets.code.player.unlocks.beatenLevels[rn] then
        dialouge.schedule("image/levelSelect/dialouge/dialouge3.png")
    end
end

assets.code.player.unlocks.beatenLevels[rn] = true

local b = assets.code.player.unlocks.beatenLevels
if b.frostedChannelStorm and b.autumnGroveStorm and b.derelictDamStorm then

    if not assets.code.player.unlocks.levels.seenDialouge4 then
        dialouge.schedule("image/levelSelect/dialouge/dialouge4.png")
    end

    assets.code.player.unlocks.levels.seenDialouge4 = true 
end

dante.printTable(assets.code.player.unlocks)
if assets.code then
    dante.save(assets.code.player.unlocks, "save", "unlocks")
end
