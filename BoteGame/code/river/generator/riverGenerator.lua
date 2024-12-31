local RiverGenerator = {}
RiverGenerator.__index = RiverGenerator

local nextSegment_lastPoints = love.thread.getChannel("nextSegment_lastPoints")
local nextSegment_zone = love.thread.getChannel("nextSegment_zone")

local nextSegment_return = love.thread.getChannel("nextSegment_return")
local nextSegment_error = love.thread.getChannel("nextSegment_error")
local nextSegment_rSeed = love.thread.getChannel("nextSegment_rSeed")



function RiverGenerator:New(riverData)
    local obj = setmetatable({}, RiverGenerator)


    obj.zones = riverData
    obj.currentZone = 1
    obj.zoneDist = 0
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels

    obj:NextSegment()

    return obj
end

function RiverGenerator:GetLegnth()
    local l = 0
    for i = 1,#self.zones do
        local zone = self.zones[i]
        l = l + zone.distance + zone.transition
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