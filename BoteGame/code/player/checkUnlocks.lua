print("checking unlocks")
-- this should only run if the player has "Won" the levels

if not assets.code.player.unlocks.beatenLevels then assets.code.player.unlocks.beatenLevels = {} end
assets.code.player.unlocks.beatenLevels[riverName] = true

if riverName == "frostedChannel" then
    assets.code.player.unlocks.levels.autumnGrove = true
    assets.code.player.unlocks.levels.frostedChannel_Strom = true
end

if riverName == "autumnGrove" then
    assets.code.player.unlocks.levels.derelictDam = true
    assets.code.player.unlocks.levels.autumnGrove_Strom = true
end

if riverName == "derelictDam" then
    assets.code.player.unlocks.levels.endless = true
    assets.code.player.unlocks.levels.derelictDam_Strom = true
end

local b = assets.code.player.unlocks.beatenLevels
if b.frostedChannel_Strom and b.autumnGrove_Strom and b.derelictDam_Strom then
    assets.code.player.unlocks.levels.endless_Storm = true
end