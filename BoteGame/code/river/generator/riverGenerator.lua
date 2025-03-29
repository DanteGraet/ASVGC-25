local RiverGenerator = {}
RiverGenerator.__index = RiverGenerator

-- Load channels
local generatorThread_playerY = love.thread.getChannel("generator_playerY")
local generatorThread_riverData = love.thread.getChannel("generator_riverData")
local generatorThread_scale = love.thread.getChannel("generatorThread_scale")

local generatorThread_backgroundImageData = love.thread.getChannel("generatorThread_backgroundImageData")
local generatorThread_riverSegments = love.thread.getChannel("generatorThread_riverSegments")

local generatorThread_minZones = love.thread.getChannel("generatorThread_minZones")

local generatorThread_screenWidth = love.thread.getChannel("generatorThread_screenWidthlove")
generatorThread_screenWidth:push((riverBorders.right + 15)*2)

function RiverGenerator:New(name)
    local obj = setmetatable({}, RiverGenerator)

    local RD = assets.code.river.riverData[name].zone()
    if RD[1] then
        obj.zones = RD
    else
        for key, value in pairs(RD) do
            if value.isFirst then
                table.insert(self.zones, self:GenerateZoneData(value))
                break
            end
        end
    end
    obj.currentZone = 1
    obj.zoneDist = 0
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels


    obj.generatorThread = love.thread.newThread("code/river/generator/generatorThread.lua")

    generatorThread_playerY:push(0)
    generatorThread_riverData:push(name)
    generatorThread_scale:push(screenScale)

    obj.generatorThread:start()

    return obj
end


function RiverGenerator:GenerateZoneData(zone)
    local tempZone = {}

    for key, value in pairs(zone) do
        if type(value) == "table" then
            if key ~= "nextZone" then
                if value[1] then
                    -- pick a random one
                    tempZone[key] = value[math.random(1, #value)]
                else
                    -- min, max garbage
                    tempZone[key] = math.random(value.min, value.max)
                end
            else
                tempZone[key] = value
            end
        else
            tempZone[key] = value
        end
    end

    return tempZone
end

function RiverGenerator:GetLegnth()
    local l = 0
    if self.zones then
        for i = 1,#self.zones do
            local zone = self.zones[i]
            l = l + zone.distance + zone.transition
        end
    end

    return l
end

function RiverGenerator:GetZone(y, extra)
    local y = y or player.y
    self.zones = generatorThread_minZones:peek() or self.zones

    local distRemaining = math.abs(y)
    for i = 1,#self.zones do
        local zone = self.zones[i]

        if extra then

            distRemaining = distRemaining - zone.distance

            if distRemaining < 0 then
                return zone
            elseif distRemaining < zone.transition then
                return {zone, self.zones[i+1] or zone, distRemaining/zone.transition}
            end
        else
            distRemaining = distRemaining - zone.distance - zone.transition

            if distRemaining < 0 then
                return zone
            end
        end
    end
    
    -- return the last zone
    return self.zones[#self.zones]
end

function RiverGenerator:GetPercentageThrough(y)
    local distRemaining = math.abs(y)
    for i = 1,#self.zones do
        local zone = self.zones[i]

        if distRemaining <= zone.distance + zone.transition then
            return distRemaining / (zone.distance + zone.transition)
        end

        distRemaining = distRemaining - zone.distance - zone.transition
        
    end
    return 1
end

function RiverGenerator:Update()
    generatorThread_playerY:clear()
    generatorThread_playerY:push(-player.y)

    local newPoints = generatorThread_riverSegments:pop()
    if newPoints then
        river:MergePoints(newPoints)
    end
end

return RiverGenerator