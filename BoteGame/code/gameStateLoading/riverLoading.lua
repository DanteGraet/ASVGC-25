local riverZones = love.filesystem.load("code/river/river/" .. riverName .. ".lua")()

local toLoad = {}

for i = 1,#riverZones do
    -- add a falg to tell the code to add the obsticals to the loaded list later :/
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/obsticals.lua", "addObstacles"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/pathGeneration.lua"})
end

return toLoad