if not assets then
    assets = {}
end

if not assets.code then
    assets.code = {}
end

if not assets.code.player then
    assets.code.player = {}
end

if assets.code.player.unlocks then
    dante.save(assets.code.player.unlocks, "save", "unlocks")
end

print("loading Unlocks :D")

assets.code.player.unlocks = dante.load("save/unlocks")


if not assets.code.player.unlocks then
    -- load the default & run
    assets.code.player.unlocks = love.filesystem.load("code/player/playerUnlockDefault.lua")()
    -- save the file
    dante.save(assets.code.player.unlocks, "save", "unlocks")
end