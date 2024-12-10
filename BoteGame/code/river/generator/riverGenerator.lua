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
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels

    obj:NextSegment()

    return obj
end

function RiverGenerator:GetZone()
    return self.zones[self.currentZone]
end

function RiverGenerator:Update()
    if self.generatingSegment == true then
        local result = self:NextSegment()

        if result then
            -- add it to the end of the actual river
            river:MergePoints(result)
            if #river.canvases <= 0 then
                river:AddNextCanvas()
            end
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

        nextSegment_lastPoints:push(river:GetLastPoints())

        local zoneName = self.zones[self.currentZone].zone
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