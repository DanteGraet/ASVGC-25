local RiverGenerator = {}
RiverGenerator.__index = RiverGenerator


function RiverGenerator:New(riverData)
    local obj = setmetatable({}, RiverGenerator)

    obj.zones = riverData
    obj.currentZone = riverData[1].zone
    obj.distance = 0


    obj.generatingSegment = false

    -- load these channels
    obj.nextSegment_lastPoints = love.thread.getChannel("nextSegment_lastPoints")
    obj.nextSegment_zone = love.thread.getChannel("nextSegment_zone")

    obj.nextSegment_return = love.thread.getChannel("nextSegment_return")


    obj:NextSegment()

    return obj
end

function RiverGenerator:Update(dt)


end

function RiverGenerator:NextSegment()
    if self.generatingSegment == false then
        -- run if we are not already
        self.generatingSegment = true

        self.nextSegmentThread = love.thread.newThread("code/river/generator/nextSegment.lua")

        self.nextSegment_lastPoints:push(river:GetLastPoints())
        self.nextSegment_zone:push(self.zones[self.currentZone])
    else
        
    end
end

return RiverGenerator