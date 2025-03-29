local love = require("love")
love.math = require("love.math")
local math = require("math")
local table = require("table")
local string = require("string")

require("templateLib/quindoc")
require("templateLib/dante")

globals = {}

local threadRunning = true
local playerY = love.thread.getChannel("generator_playerY"):pop() or 0


local lastPoints = nil

--[[assets.code.river.riverData[riverName].zone()]]
local riverName = love.thread.getChannel("generator_riverData"):pop()
local screenWidth = love.thread.getChannel("generatorThread_screenWidthlove"):pop()
local RD = love.filesystem.load("code/river/riverData/" .. riverName .. "/zone.lua")()
local infinite, data = nil, nil
local zoneData = {}

local backgroundY = 0

local tempRiver = {}

--Load these first

-- functions for generating the background
local function FindHighAndLowPoints(channel, side, yPos)
    local high, low

    for point = 1,#tempRiver[channel][side] do
        if tempRiver[channel][side][point].y < yPos then
            low = tempRiver[channel][side][point]
            high = tempRiver[channel][side][point-1] or tempRiver[channel][side][point]
            return high, low
        end
    end

    --just guess at this point
    return tempRiver[channel][1][1], tempRiver[channel][1][2]
end

function getDistToEdge(x, y)    -- global so we can acsess in generating colours scripts
    if tempRiver and #tempRiver > 0 then
        for channel = 1,#tempRiver do
            local leftHight, leftLow = FindHighAndLowPoints(channel, 1, y)
            local rightHight, rightLow = FindHighAndLowPoints(channel, 2, y)

            local leftPercentage = (y - leftLow.y)/(leftHight.y - leftLow.y)
            local rightPercentage = (y - rightLow.y)/(rightHight.y - rightLow.y)

            local leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
            local rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage


            return math.max(leftX - x, (rightX - x)*-1)

        end
    end
end

function GetPercentageThrough(y)
    local distRemaining = math.abs(y)
    for i = 1,zones do
        local zone = zones[i]

        if distRemaining <= zone.distance + zone.transition then
            return distRemaining / (zone.distance + zone.transition)
        end

        distRemaining = distRemaining - zone.distance - zone.transition
        
    end
    return 1
end



-- functions for river generating
local function GetZone(y, extra)
    local y = y or playerY

    local distRemaining = math.abs(y)
    for i = 1,#zones do
        local zone = zones[i]

        if extra then

            distRemaining = distRemaining - zone.distance

            if distRemaining < 0 then
                return zone
            elseif distRemaining < zone.transition then
                return {zone, zones[i+1] or zone, distRemaining/zone.transition}
            end
        else
            distRemaining = distRemaining - zone.distance - zone.transition

            if distRemaining < 0 then
                return zone
            end
        end
    end

    -- return the last zone
    return zones[#zones]
end

local function generateLastPoints(zoneName)
    local zone = zoneData[zoneName].path 
    local lastPoints = {}

    local size = math.random(zone.minWidth, zone.maxWidth)

    local scale = love.thread.getChannel("generatorThread_scale"):peek()

    table.insert(lastPoints, {})

    table.insert(lastPoints[1], {})

    lastPoints[1][1].x = -size/2
    lastPoints[1][1].y = (1080/scale)

    table.insert(lastPoints[1], {})

    lastPoints[1][2].x = size/2
    lastPoints[1][2].y = (1080/scale)

    return lastPoints
end

local function getLegnth()
    local l = 0
    if zones then
        for i = 1,#zones do
            local zone = zones[i]
            l = l + zone.distance + zone.transition
        end
    end

    return l
end

local function addNextZones(y)
    while y > getLegnth() do
        if zones and #zones > 0 then
            local allOptions = zones[#zones].nextZone

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
                        table.insert(zones, self:GenerateZoneData(data[validOptions[i]]))
                        break
                    end
                else
                    no = no - validOptions[i].weight or 1

                    if no < validOptions[i].weight or 1 then
                        table.insert(zones, self:GenerateZoneData(data[validOptions[i]].name))
                        break
                    end
                end
            end
            
        else
            zones = {}
            local foundFirst = false 
            -- add the first zone
            for key, value in pairs(data) do
                if value.isFirst then
                    table.insert(zones, self:GenerateZoneData(value))
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

local function nextSegment(zone) -- {chanel1, chanel2, chanel3, etc.}
    local zone = zoneData[zone.zone].path
    local localLastPoints = lastPoints or generateLastPoints(GetZone(playerY).zone)
    
    -- the points we generate
    local newPoints = {}

    --loop throigh each channel
    for i = 1,#localLastPoints do
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
        local startX = (localLastPoints[i][1].x + localLastPoints[i][2].x)/2

        -- save the last positions so i can acsess then quickly
        local lastLeftX = localLastPoints[i][1].x
        local lastLeftY = localLastPoints[i][1].y

        local lastRightX = localLastPoints[i][2].x
        local lastRightY = localLastPoints[i][2].y

        -- generate the end positions for each leftCurve
        local endLeftX = endX - endWidth/2
        local endLeftY = lastLeftY + segLegnth

        local endRightX = endX + endWidth/2
        local endRightY = endLeftY          -- the final y positions are the same so cant' ever get desynced like at all

        -- generate the mid points of each curve
        --local midLeftX = (startX - endX - midWidth)/2
        local midLeftY = lastLeftY + segLegnth*curveMidYPercentage

        --local midRightX = (startX - endX + midWidth)/2
        local midRightY = lastRightY + segLegnth*curveMidYPercentage

        -- adjust the middle sections to reduce the effects of squihsing
            -- imagine the while river is rotated (traveling right) so we flip the x and y axis in atan2
        local angle = math.atan2(startX - endX, -segLegnth)
            -- trun the angle into a percentage (0-100)
        local anglePercentage = angle/(math.pi/2)
            -- finally change the y values
        midLeftY = midLeftY + midWidth*anglePercentage
        midRightY = midRightY - midWidth*anglePercentage


        local leftCurve = love.math.newBezierCurve(
            lastLeftX, lastLeftY,
            --lastLeftX, lastLeftY - 0.1, -- make sure it is heading in the right direction

            lastLeftX, midLeftY,
            endLeftX, midLeftY,

            --endLeftX, endLeftY + 0.1,
            endLeftX, endLeftY
        )
        local rightCurve = love.math.newBezierCurve(
            lastRightX, lastRightY,
            --lastRightX, lastRightY - 0.1, -- make sure it is heading in the right direction

            lastRightX, midRightY,
            endRightX, midRightY,

            --endRightX, endRightY + 0.1,
            endRightX, endRightY
        )

        table.insert(newPoints, 
            {
                leftCurve:render(4),
                rightCurve:render(4),
            }
        )
    end

    lastPoints = {}
    for channel = 1,#newPoints do
        table.insert(lastPoints, {})
        for side = 1,#newPoints[channel] do
            local s = newPoints[channel][side]
            --add the sides
            table.insert(lastPoints[channel], {})

            --error("thread" .. dante.dataToString(lastPoints) .. s)

            -- s is a table of {x, y, x, y, ...} values
            lastPoints[channel][side].x = s[#s-1]
            lastPoints[channel][side].y = s[#s]
        end
    end

    return newPoints
end

local function mergePoints(newPoints)
    for channel = 1,#newPoints do
        if not tempRiver[channel] then
            tempRiver[channel] = {}
        end

        for side = 1,#newPoints[channel] do

            if not tempRiver[channel][side] then
                tempRiver[channel][side] = {}
            end

            for point = 1,#newPoints[channel][side], 2 do
                local data = {
                    x = newPoints[channel][side][point],
                    y = newPoints[channel][side][point + 1],
                }   
                table.insert(tempRiver[channel][side], data)
            end
        end
    end
end






local layersToGenerate = 25
local function generateImageData(startY)
    local data = {
        y = startY + layersToGenerate*3,
        width = math.ceil(screenWidth/6)*2,
        height = layersToGenerate + 3,
        pixles = {},
    }

    local top = startY + data.height*3
    for y = math.floor(startY/3)+1, math.floor(startY/3) + data.height do
        local relativeY = y-(math.floor(startY/3)+1)
        data.pixles[relativeY] = {}


        local zone = GetZone(y*3, true)
        local zone2
        local chance

        if zone[1] and type(zone[1]) == "table" then
            zone2 = zone[2]
            chance = zone[3]
            zone = zone[1]
        end

        for x = -data.width/2 + 1, data.width/2 do
            local colour
            local num = chance or -1
    
            --if zone2 and math.random(0, 100)/100 < chance then
            if zone2 and love.math.noise((x)*3/250, y*2/250) < chance then
                colour = zoneData[zone2.zone].background(x*3, -top+relativeY*3)
    
            else
                colour = zoneData[zone.zone].background(x*3, -top+relativeY*3)
            end

            table.insert(data.pixles[relativeY], colour)
        end
    end
    backgroundY = backgroundY + layersToGenerate*3

    love.thread.getChannel("generatorThread_backgroundImageData"):push(data)
end



--Get the riverData
for key, value in pairs(RD) do
    zoneData[value.zone] = {
        path = love.filesystem.load("code/river/zone/" .. value.zone .. "/pathGeneration.lua")(),
        background = love.filesystem.load("code/river/zone/" .. value.zone .. "/backgroundGeneration.lua")(),
    }
end

if RD[1] then
    zones = RD
else
    infinite = true
    data = RD
    zones = {}
    addNextZones(10000)
end
love.thread.getChannel("generatorThread_minZones"):clear()
love.thread.getChannel("generatorThread_minZones"):push(zones)

local currentZone = 1
RD = nil


while threadRunning do
    playerY = love.thread.getChannel("generator_playerY"):pop() or playerY
    if infinite then
        addNextZones(playerY + 10000)
    end
    

    -- Generate river segments
    if not lastPoints or lastPoints[1][#lastPoints[1]].y > -(playerY+50 + 5000) then
        local p
        if lastPoints then
            p = nextSegment(GetZone(lastPoints[1][#lastPoints[1]].y))
        else
            p = nextSegment(GetZone(1))
        end
        love.thread.getChannel("generatorThread_riverSegments"):push(p)
        mergePoints(p)
    end

    -- Generate Background images

    if playerY + 1000 > backgroundY then
        generateImageData(backgroundY)
    end

    --remove un-nessesary river points
    for channel = 1,#tempRiver do
        --loop though each side
        for side = 1,#tempRiver[channel] do
            for i = 1,#tempRiver[channel][side] do
                local point = tempRiver[channel][side][2]

                if point and -point.y < backgroundY then
                    table.remove(tempRiver[channel][side], 1)
                else
                    -- no longer check this side of this channel
                    break
                end
            end
        end
    end
end
