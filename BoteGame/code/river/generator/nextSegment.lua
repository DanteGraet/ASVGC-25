-- theread to help prevent performance issues

local love = require("love")
love.math = require("love.math")
local math = require("math")
local table = require("table")
local string = require("string")


local function GenerateLastPoints(zone)
    local lastPoints = {}

    local size = math.random(zone.minWidth, zone.maxWidth)

    table.insert(lastPoints, {})

    table.insert(lastPoints[1], {})

    lastPoints[1][1].x = -size/2
    lastPoints[1][1].y = 0

    table.insert(lastPoints[1], {})

    lastPoints[1][2].x = size/2
    lastPoints[1][2].y = 0

    return lastPoints
end


local function NextSegment(lastPoints, zone) -- {chanel1, chanel2, chanel3, etc.}
    local zone = zone
    local lastPoints = lastPoints
    
    -- the points we generate
    local newPoints = {}

    --loop throigh each channel
    for i = 1,#lastPoints do
        -- generate the important stuff for each segment.
        -- segment legnth is actually negative, the river goes up
        local segLegnth = -math.random(zone.segLenMax, zone.segLenMin)

        -- How wide the river is at certain points point
        local midWidth = math.random(zone.minWidth, zone.maxWidth)      -- dont knoww if im gonna use this value yet
        local endWidth = math.random(zone.minWidth, zone.maxWidth)

        -- how far throught the curve the actual mid point should be (height as percentge)
        local curveMidYPercentage = math.random(30, 70)/100

        -- the end x of the segment
        -- this is based in 1920x1080 screen size (default that we scale around)
        local endX = math.random( -(1900 - endWidth)/2, (1900 - endWidth)/2 )
        --where it starts (used for mid thingss um yea)
        local startX = (lastPoints[i][1].x + lastPoints[i][2].x)/2

        -- save the last positions so i can acsess then quickly
        local lastLeftX = lastPoints[i][1].x
        local lastLeftY = lastPoints[i][1].y

        local lastRightX = lastPoints[i][2].x
        local lastRightY = lastPoints[i][2].y

        -- generate the end positions for each leftCurve
        local endLeftX = lastPoints[i][1].x
        local endLeftY = lastLeftY + segLegnth

        local endRightX = lastPoints[i][2].x
        local endRightY = endLeftY          -- the final y positions are the same so cant' ever get desynced like at all

        -- generate the mid points of each curve
        local midLeftX = (startX - endX - midWidth)/2
        local midLeftY = lastLeftY + endLeftY*curveMidYPercentage

        local midRightX = (startX - endX + midWidth)/2
        local midRightY = lastRightY + endRightY*curveMidYPercentage

        -- adjust the middle sections to reduce the effects of squihsing
            -- imagine the while river is rotated (traveling right) so we flip the x and y axis in atan2
        local angle = math.atan2(startX - endX, -segLegnth)
            -- trun the angle into a percentage (0-100)
        local anglePercentage = angle/(math.pi/2)
            -- finally change the y values
        midLeftY = midLeftY + midWidth*anglePercentage
        midRightY = midRightY + midWidth*anglePercentage


        local leftCurve = love.math.newBezierCurve(
            lastLeftX, lastLeftY,
            lastLeftX, lastLeftY - 0.1, -- make sure it is heading in the right direction
            midLeftX, midLeftY,
            endLeftX, endLeftY + 0.1,
            endLeftX, endLeftY
        )
        local rightCurve = love.math.newBezierCurve(
            lastRightX, lastRightY,
            lastRightX, lastRightY - 0.1, -- make sure it is heading in the right direction
            midRightX, midRightY,
            endRightX, endRightY + 0.1,
            endRightX, endRightY
        )

        table.insert(newPoints, 
            {
                leftCurve:render(4),
                rightCurve:render(4),
            }
        )
    end

    return newPoints
end

-- Get the infomation we need to run the code

local zone = love.thread.getChannel("nextSegment_zone"):pop()

local lastPoints = love.thread.getChannel("nextSegment_lastPoints"):pop()
if lastPoints == nil then
    lastPoints = GenerateLastPoints(zone)
end


local segment = NextSegment(lastPoints, zone)

love.thread.getChannel("nextSegment_return"):push(segment) 