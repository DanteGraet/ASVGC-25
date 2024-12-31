local randomSpawner = love.filesystem.load("code/river/generator/randomSpawner.lua")()
local timerSpawner = love.filesystem.load("code/river/generator/timerSpawner.lua")()
local difficultyIndependentSpawner = love.filesystem.load("code/river/generator/difficultyIndependentSpawner.lua")()


local ObstacleSpawner = {}
ObstacleSpawner.__index = ObstacleSpawner


function ObstacleSpawner:New(obsticals)
    local obj = setmetatable({}, ObstacleSpawner)

    obj.spawners = {}


    for key, value in pairs(obsticals) do 
        obj.spawners[key] = {}
        for i = 1,#obsticals[key] do
            if obsticals[key][i].type == "random" then
                table.insert(obj.spawners[key], randomSpawner:New(obsticals[key][i].data))
            elseif obsticals[key][i].type == "timer" then
                table.insert(obj.spawners[key], timerSpawner:New(obsticals[key][i].data, obsticals[key][i].minTime, obsticals[key][i].maxTime))
            elseif obsticals[key][i].type == "difficultyIndependent" then
                table.insert(obj.spawners[key], difficultyIndependentSpawner:New(obsticals[key][i].data, obsticals[key][i].chance))
            end
        end
    end

    obj.lastY = riverBorders.up - 250
    obj.lastZone = riverGenerator:GetZone(obj.lastY).zone

    return obj
end

function ObstacleSpawner:Update()
    local zone = riverGenerator:GetZone(riverBorders.up - 250).zone
    --print(zone)
    if self.spawners[zone] then
        for i = 1,#self.spawners[zone] do

            self.spawners[zone][i]:Update(zone ~= self.lastZone)
        end
    end

    self.lastZone = zone
end

return ObstacleSpawner