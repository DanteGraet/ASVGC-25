local River = {}
River.__index = River

pixlesPerPixle = 3

function River:New()
    local obj = setmetatable({}, River)

    obj.points = {}
    obj.callNextSegment = true

    obj.canvasGenerator = assets.code.river.generator.riverCanvas()
    obj.canvases = {}
    obj.canvasFillY = 0

    obj.fakeCanvases = {}

    obj.farAhead = false


    --{"code/river/generator/riverCanvas.lua"},
    --

    return obj
end

function River:AddNextCanvas(y)
    if #self.canvases > 0 then
        table.insert(self.canvases, self.canvasGenerator:New(y, false, riverGenerator:GetZone(y, true)))
    else
        table.insert(self.canvases, self.canvasGenerator:New(175, true, riverGenerator:GetZone(nil, true)))
        self.canvasFillY = self.canvases[#self.canvases].y
    end
end

function River:HasPoints()
    return self.farAhead
end


function River:MergePoints(newPoints)
    for channel = 1,#newPoints do
        if not self.points[channel] then
            self.points[channel] = {}
        end

        for side = 1,#newPoints[channel] do
            if not self.points[channel][side] then
                self.points[channel][side] = {}
            end

            for point = 1,#newPoints[channel][side], 2 do
                local data = {
                    x = newPoints[channel][side][point],
                    y = newPoints[channel][side][point + 1],
                }
                table.insert(self.points[channel][side], data)
            end
        end
    end
    --self.farAhead = true
    self.callNextSegment = true
end

function River:GetLastPoints()
    local lastPoints = nil
    if #self.points > 0 then
        lastPoints = {}
        for channel = 1,#self.points do
            table.insert(lastPoints, {})
            for side = 1,#self.points[channel] do
                local s = self.points[channel][side]
                --add the sides
                table.insert(lastPoints[channel], {})

                lastPoints[channel][side].x = s[#s].x
                lastPoints[channel][side].y = s[#s].y

            end
        end
    end

    return lastPoints
end

function River:checkNextSegment()
    -- check if we need to generate the next segment
    if #self.points > 0 then
        if self.points[1][1][#self.points[1][1]].y > player.y+50 - 5000 then
            --River
            if self.callNextSegment then
                riverGenerator:NextSegment()
                self.callNextSegment = false
            end
        else
            if not self.farAhead then
                river:AddNextCanvas()
            end
            self.farAhead = true
            self.callNextSegment = true
        end
    end
end


function River:Update()
    -- local variable so it runs slightly faster
    local playerY = player.y + 50

    if self.points and #self.points > 0 then

        for channel = 1,#self.points do
            --loop though each side
            for side = 1,#self.points[channel] do
                for i = 1,#self.points[channel][side] do
                    local point = self.points[channel][side][2]

                    if point.y > playerY then
                        table.remove(self.points[channel][side], 1)
                    else
                        -- no longer check this side of this channel
                        break
                    end
                end
            end
        end

        self:checkNextSegment()

    end

    --Canvases :D
    if self.canvases and #self.canvases > 0 and self.canvases[#self.canvases].y >= playerY-camera.oy-50 then
        local y = self.canvases[#self.canvases].y --+ riverBorders.up
        print(self.canvases[1].y, self.canvases[#self.canvases].y)
        self:AddNextCanvas(y)
        print("new canvas --------------------------------------")
    end

    if camera.y- camera.oy < self.canvasFillY then

        local currentCanvasNo = #self.canvases
        local currentCanvas = self.canvases[currentCanvasNo]

        if currentCanvas then
            for i = math.floor(camera.y - camera.oy), math.floor(self.canvasFillY) , 3 do
                local relativeY = math.floor((currentCanvas.y - i))



                currentCanvas:FillCanvasY(math.abs(relativeY)/3, i, nil, riverGenerator:GetZone(i, true))

                if relativeY + 3 > currentCanvas.canvas:getHeight() then
                    currentCanvasNo = currentCanvasNo - 1
                    if currentCanvasNo > 0 then
                        currentCanvas = self.canvases[currentCanvasNo]

                        currentCanvas:FillCanvasY(math.abs(relativeY)/3, i, nil, riverGenerator:GetZone(i, true))
                    end
                end

            end
        end

        self.canvasFillY = camera.y- camera.oy
    end

    -- delete old canvases
    for i = 1,#self.canvases do
        if self.canvases[1].y > riverBorders.down then
            table.remove(self.canvases, 1)
        end
    end

    for i = 1,#self.fakeCanvases do
        if self.fakeCanvases[1].y > riverBorders.down then
            table.remove(self.fakeCanvases, 1)
        end
    end
end

function River:AddFakeCanvases()
    -- reset the current canvases
    self.fakeCanvases = {}

    local left = math.floor(riverBorders.left/3) - 2
    local right = math.floor(riverBorders.right/3) - 2

    for i = 1,#self.canvases do
        local canvasToCopy = self.canvases[i]
        if canvasToCopy.x > left then
            local xDiff = canvasToCopy.x - left

            local leftCanvas = self.canvasGenerator:New()
            leftCanvas.canvas = love.graphics.newCanvas(xDiff + 4, canvasToCopy.canvas:getHeight())
            leftCanvas.canvas:setFilter("nearest","nearest")
            leftCanvas.y = canvasToCopy.y
            leftCanvas.x = left

            local rightCanvas = self.canvasGenerator:New()
            rightCanvas.canvas = love.graphics.newCanvas(xDiff + 8, canvasToCopy.canvas:getHeight())
            rightCanvas.canvas:setFilter("nearest","nearest")

            rightCanvas.y = canvasToCopy.y
            rightCanvas.x = right - xDiff - 3

            for i = 1,leftCanvas.canvas:getHeight() do
                leftCanvas:FillCanvasY(i, leftCanvas.y + i*pixlesPerPixle, leftCanvas.x*pixlesPerPixle, riverGenerator:GetZone(leftCanvas.y + i*pixlesPerPixle, true))
                rightCanvas:FillCanvasY(i, rightCanvas.y + i*pixlesPerPixle, rightCanvas.x*pixlesPerPixle, riverGenerator:GetZone(rightCanvas.y + i*pixlesPerPixle, true))

            end

            table.insert(self.fakeCanvases, leftCanvas)
            table.insert(self.fakeCanvases, rightCanvas)
        else
            -- addd the canvas to the bottom    
            local canvasToCopy = self.canvases[1]

            if canvasToCopy.y + canvasToCopy.canvas:getHeight()*pixlesPerPixle < riverBorders.down then
                local newCanvas = self.canvasGenerator:New()
                newCanvas.canvas:setFilter("nearest","nearest")

                newCanvas.y = canvasToCopy.y + canvasToCopy.canvas:getHeight()*pixlesPerPixle - 3
                for i = 1,newCanvas.canvas:getHeight() do
                    newCanvas:FillCanvasY(i, newCanvas.y + i*pixlesPerPixle, newCanvas.x*pixlesPerPixle, riverGenerator:GetZone(newCanvas.y + i*pixlesPerPixle, true))
                end

                table.insert(self.fakeCanvases, newCanvas)

            end
        end
    end
end

function River:IsInBounds(x, y)
    if self.points and #self.points > 0 then
        for channel = 1,#self.points do
            local leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, y)
            local rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, y)

            local leftPercentage = (y - leftLow.y)/(leftHight.y - leftLow.y)
            local rightPercentage = (y - rightLow.y)/(rightHight.y - rightLow.y)

            local leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
            local rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage
            if x > leftX and x < rightX then
                return true
            end
        end
    end

    return false
end

function River:GetCurrent(yPos, xPos) -- returns the average direction angle of each path?
    local angle, speed
    speed = 100  -- A temporary value TRUST :D

    if self.points and #self.points > 0 then

        for channel = 1,#self.points do
            --[[local leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos)
            local rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos)

            local leftPercentage = (leftLow.y - yPos)/(leftHight.y - leftLow.y)
            local rightPercentage = (rightLow.y - yPos)/(rightHight.y - rightLow.y)

            local leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
            local rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage

            local centerPos = {x = (leftX + rightX)/2, y = yPos}

            if xPos then
                if leftX < xPos and rightX > xPos then
                    -- we can overwrite these values now
                        -- Could be adding a smaller number but a largr value will make it "smoother"
                    leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos - 25)
                    rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos - 25)
        
                    leftPercentage = (leftLow.y - yPos)/(leftHight.y - leftLow.y)
                    rightPercentage = (rightLow.y - yPos)/(rightHight.y - rightLow.y)
        
        
                    leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
                    rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage
                    
                    -- this one has to be another variable
                    local centerPos2 = {x = (leftX + rightX)/2, y = yPos - 25}
                    angle = math.atan2(centerPos2.y - centerPos.y, centerPos2.x - centerPos.x)   

                    print("angle" .. angle)

                    return angle, speed
                else
                    print("DAM", leftX, xPos, rightX)
                    return
                end
            end

                    -- we can overwrite these values now
            -- Could be adding a smaller number but a largr value will make it "smoother"
            leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos - 25)
            rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos - 25)

            leftPercentage = (leftLow.y - yPos)/(leftHight.y - leftLow.y)
            rightPercentage = (rightLow.y - yPos)/(rightHight.y - rightLow.y)

            leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
            rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage
            
            -- this one has to be another variable
            local centerPos2 = {x = (leftX + rightX)/2, y = yPos - 25}
            local angle

            angle = math.atan2(centerPos2.y - centerPos.y, centerPos2.x - centerPos.x)   

            --print("aaangle" .. angle)

            print(angle, centerPos2.y - centerPos.y,  centerPos2.x - centerPos.x,  rightPercentage, leftPercentage)]]


            -- its been like 5 hrs so im trying a simpler thing
            local leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos)
            local rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos)

            local avgXLow = (leftLow.x + rightLow.x)/2
            local avgXHigh = (leftHight.x + rightHight.x)/2

            local avgYLow = (leftLow.y + rightLow.y)/2
            local avgYHigh = (leftHight.y + rightHight.y)/2

            local angle = math.atan2(avgYLow- avgYHigh, avgXLow - avgXHigh)

            return angle, speed
        end
    end

    return angle, speed
end

function River:FindHighAndLowPoints(channel, side, yPos)
    local high, low

    for point = 1,#self.points[channel][side] do
        if self.points[channel][side][point].y < yPos then
            low = self.points[channel][side][point]
            high = self.points[channel][side][point-1] or self.points[channel][side][point]
            return high, low
        end
    end

    --just guess at this point
    return self.points[channel][1][2], self.points[channel][1][1]
end

function River:Draw(scale)
    --love.graphics.setCanvas()

    love.graphics.push()
    --love.graphics.scale(1/scale)

    love.graphics.setColor(1,1,1)
    for i = 1,#self.canvases do

        love.graphics.draw(self.canvases[i].canvas, self.canvases[i].x*pixlesPerPixle, self.canvases[i].y, 0, pixlesPerPixle, pixlesPerPixle)

    end

    for i = 1,#self.fakeCanvases do
        love.graphics.draw(self.fakeCanvases[i].canvas, self.fakeCanvases[i].x*pixlesPerPixle, self.fakeCanvases[i].y, 0, pixlesPerPixle, pixlesPerPixle)
    end

    love.graphics.pop()

end

function River:DrawPoints()
    if #self.points > 0 then
        for channel = 1,#self.points do
            for side = 1,#self.points[channel] do
                for point = 1,#self.points[channel][side] do
                    local obj = self.points[channel][side][point]

                    love.graphics.circle("fill", obj.x, obj.y, 5)
                end
            end
        end
    end    
end

return River