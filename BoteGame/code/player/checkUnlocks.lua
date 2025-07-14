print("checking unlocks")
-- this should only run if the player has "Won" the levels

if not assets.code.player.unlocks.beatenLevels then assets.code.player.unlocks.beatenLevels = {} end
assets.code.player.unlocks.beatenLevels[riverName] = true

if riverName == "frostedChannel" then
    assets.code.player.unlocks.levels.autumnGrove = true
    assets.code.player.unlocks.levels.endless = true
    assets.code.player.unlocks.levels.frostedChannelStorm = true
end

if riverName == "autumnGrove" then
    assets.code.player.unlocks.levels.derelictDam = true
    assets.code.player.unlocks.levels.autumnGroveStorm = true
end

if riverName == "derelictDam" then
    assets.code.player.unlocks.levels.endless = true
    assets.code.player.unlocks.levels.derelictDamStorm = true
end

local b = assets.code.player.unlocks.beatenLevels
if b.frostedChannelStorm and b.autumnGroveStorm and b.derelictDamStorm then
    assets.code.player.unlocks.levels.endless_Storm = true
end