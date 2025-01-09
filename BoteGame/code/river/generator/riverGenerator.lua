local RiverGenerator = {}
RiverGenerator.__index = RiverGenerator

local nextSegment_lastPoints = love.thread.getChannel("nextSegment_lastPoints")
local nextSegment_zone = love.thread.getChannel("nextSegment_zone")

local nextSegment_return = love.thread.getChannel("nextSegment_return")
local nextSegment_rSeed = love.thread.getChannel("nextSegment_rSeed")



function RiverGenerator:New(riverData)
    local obj = setmetatable({}, RiverGenerator)

    if riverData[1] then

        obj.zones = riverData
    else

        obj.infinite = true
        obj.data = riverData

        obj.zones = {}



        obj:AddNextZones(10000)
    end
    obj.currentZone = 1
    obj.zoneDist = 0
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels

    obj:NextSegment()

    return obj
end

function RiverGenerator:AddNextZones(y)
    while y > self:GetLegnth() do
        if self.zones and #self.zones > 0 then
            local allOptions = self.zones[#self.zones].nextZone

            local validOptions = {}
            local weight = 0

            for i = 1,#allOptions do
                if type(allOptions[i]) == "string" then
                    weight = weight + 1
                    table.insert(validOptions, allOptions[i])
                else
                    if allOptions[i].validityFunction and allOptions[i].validityFunction() then
                        weight = weight + (allOptions[i].weight or 1)
                        table.insert(validOptions, allOptions[i])
                    else
                        weight = weight + (allOptions[i].weight or 1)
                        table.insert(validOptions, allOptions[i])
                    end
                end
            end

            local no = math.random(1, weight)

            for i = 1,#validOptions do
                if type(validOptions[i]) == "string" then
                    no = no -1

                    if no < 1 then
                        table.insert(self.zones, self:GenerateZoneData(self.data[validOptions[i]]))
                        break
                    end
                else
                    no = no - validOptions[i].weight or 1

                    if no < validOptions[i].weight or 1 then
                        table.insert(self.zones, self:GenerateZoneData(self.data[validOptions[i]].name))
                        break
                    end
                end
            end
            
        else
            self.zones = {}
            local foundFirst = false 
            -- add the first zone
            for key, value in pairs(self.data) do
                if value.isFirst then
                    table.insert(self.zones, self:GenerateZoneData(value))
                    foundFirst = true
                    break
                end
            end

            if not foundFirst then
                error("no zone with 'isFirst' flag :(")
            end
        end
    end

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
    if not y then
        return self.zones[self.currentZone]
    else
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
    if self.infinite then
        self:AddNextZones(-player.y + 10000)
    end

    if self.generatingSegment == true then
        local result = self:NextSegment()

        if result then
            -- add it to the end of the actual river
            river:MergePoints(result)
        end


    else

    end
end

function RiverGenerator:NextSegment()

    if self.generatingSegment == false then
        -- run if we are not already
        self.generatingSegment = true

        self.nextSegmentThread = love.thread.newThread("code/river/generator/nextSegment.lua")

        local lastPoints = river:GetLastPoints()

        nextSegment_lastPoints:push(lastPoints)

        local zoneName
        if lastPoints and lastPoints[1] and lastPoints[1][1] and lastPoints[1][1].y then
            local zone = self:GetZone(lastPoints[1][1].y)
            zoneName = zone.zone

        else
            zoneName = self.zones[self.currentZone].zone
        end

        nextSegment_zone:push(assets.code.river.zone[zoneName].pathGeneration())

        nextSegment_rSeed:push(math.random(-100, 100))

        self.nextSegmentThread:start()
    else


        local result = nextSegment_return:pop()
        
        if result then
            self.generatingSegment = false
            return result
        end
    end


    return nil
end

return RiverGenerator