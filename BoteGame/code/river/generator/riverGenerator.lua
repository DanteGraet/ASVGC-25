local RiverGenerator = {}
RiverGenerator.__index = RiverGenerator

local nextSegment_lastPoints = love.thread.getChannel("nextSegment_lastPoints")
local nextSegment_zone = love.thread.getChannel("nextSegment_zone")

local nextSegment_return = love.thread.getChannel("nextSegment_return")
local nextSegment_error = love.thread.getChannel("nextSegment_error")


function RiverGenerator:New(riverData)
    local obj = setmetatable({}, RiverGenerator)

    dante.printTable(riverData)

    obj.zones = riverData
    obj.currentZone = 1
    obj.zoneDist = 0
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels

    obj:NextSegment()

    return obj
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
                    print("transsition" .. distRemaining)
                    return {zone, self.zones[i+1] or zone, distRemaining/zone.transition}
                end
            else
                distRemaining = distRemaining - zone.distance - zone.transition

                if distRemaining < 0 then
                    print(zone.zone)
                    return zone
                end
            end
            
        end
    end
    -- return the last zone
    return self.zones[#self.zones]
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
    if nextSegment_error:pop() ~= nil then
        print(nextSegment_error:pop())
    end

    if self.generatingSegment == false then
        print("starting generating")
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


        self.nextSegmentThread:start()
    else
        print("generating ...")

        local result = nextSegment_return:pop()
        
        if result then
            self.generatingSegment = false
            return result
        end
    end

    return nil
end

return RiverGenerator