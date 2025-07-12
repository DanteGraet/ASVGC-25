local randomSpawner = love.filesystem.load("code/river/generator/randomSpawner.lua")()
local timerSpawner = love.filesystem.load("code/river/generator/timerSpawner.lua")()
local difficultyIndependentSpawner = love.filesystem.load("code/river/generator/difficultyIndependentSpawner.lua")()


local ObstacleSpawner = {}
ObstacleSpawner.__index = ObstacleSpawner


function ObstacleSpawner:New(obsticals, lastY)
    local obj = setmetatable({}, ObstacleSpawner)

    obj.spawners = {}


    for key, value in pairs(obsticals) do 
        obj.spawners[key] = {}
        for i = 1,#obsticals[key] do
            local obs = obsticals[key][i]

            if obs.type == "random" then
                table.insert(obj.spawners[key], randomSpawner:New(obs.data, lastY, obs.isFront))
            elseif obs.type == "timer" then
                table.insert(obj.spawners[key], timerSpawner:New(obs.data, obs.minTime, obs.maxTime, lastY, obs.isFront))
            elseif obs.type == "fixedTimer" then
                table.insert(obj.spawners[key], timerSpawner:New(obs.data, obs.minTime, obs.maxTime, lastY, obs.isFront))
            elseif obs.type == "difficultyIndependent" then
                table.insert(obj.spawners[key], difficultyIndependentSpawner:New(obs.data, obs.chance, lastY, obs.isFront))
            end
        end
    end

    obj.lastY = lastY or -500
    obj.lastZone = riverGenerator:GetZone(obj.lastY).zone

    --obj:Update()

    return obj
end

function ObstacleSpawner:Update()
    local zone = riverGenerator:GetZone(riverBorders.up - 500).zone
    if self.spawners[zone] then
        for i = 1,#self.spawners[zone] do

            self.spawners[zone][i]:Update(zone ~= self.lastZone)
        end
    end

    self.lastZone = zone
end

return ObstacleSpawner