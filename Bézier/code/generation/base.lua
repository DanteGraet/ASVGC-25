local riverGenerator = {}
local genS = {}

function riverGenerator.Load() -- loads or reloads the settings
    genS = require("settings/generation/base")
end

local function generateRandomPoints()
    --generate a random garbage here if the last points doesnt exist.
    --  Only one channel for now. 
    local lastPoints = {{{},{}}}       --a table with 1 empty channel

    local spawnWidth = math.random(genS.minWidth, genS.maxWidth)
    local spawnMid = math.random(0+spawnWidth/2, 1920-spawnWidth/2)

    local pos1 = {x = spawnMid - spawnWidth/2, y = 0}
    local pos2 = {x = spawnMid + spawnWidth/2, y = 0}

    table.insert(lastPoints[1][1], pos1)
    table.insert(lastPoints[1][2], pos2)

    return lastPoints
end

function riverGenerator.nextSegment(lastPoints)       --Previous should be a table, {channel = {side1[1], side2[1]}}
    local lastPoints = lastPoints

    if not lastPoints then
        lastPoints = generateRandomPoints()
    end

    local segments = lastPoints
    for i = 1,#segments do
        local spawnWidth = math.random(genS.minWidth, genS.maxWidth)
        local spawnMid = math.random(0+spawnWidth/2, 1920-spawnWidth/2)


        local segmentLegnth = math.random(genS.segLenMin, genS.segLenMax)
        local curvePercentage = math.random(25, 75)/100


        --Left hand side curve
        local curve1X = lastPoints[i][1][1].x
        local curve1Y = lastPoints[i][1][1].y

        local curve1BendY = curve1Y + segmentLegnth*curvePercentage
        local curve1BendX = spawnMid - spawnWidth/2

        --Right curve
        local curve2X = lastPoints[i][2][1].x
        local curve2Y = lastPoints[i][2][1].y

        local curve2BendY = curve2Y + segmentLegnth*curvePercentage
        local curve2BendX = spawnMid + spawnWidth/2

        local midpointX = (curve1X + curve2X)/2

        --Y is last so we can imaging it rotated to achive the deireed effect easily.
        local angle = math.atan2(midpointX - spawnMid, segmentLegnth)
        print(angle/(math.pi/2))

        local percent = angle/(math.pi/2)

        curve1BendY = curve1BendY - percent*spawnWidth
        curve2BendY = curve2BendY + percent*spawnWidth



        --Generate the actual curves
        curveLeft = love.math.newBezierCurve(curve1X, curve1Y, curve1X, curve1BendY, curve1BendX, curve1BendY, curve1BendX, curve1Y + segmentLegnth)        
        curveRight = love.math.newBezierCurve(curve2X, curve2Y, curve2X, curve2BendY, curve2BendX, curve2BendY, curve2BendX, curve2Y + segmentLegnth)



        return segment
    end
end


return riverGenerator