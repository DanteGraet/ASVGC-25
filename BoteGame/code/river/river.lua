local River = {}
River.__index = River

pixlesPerPixle = 3

function River:New()
    local obj = setmetatable({}, River)

    obj.points = {}
    obj.callNextSegment = true

    obj.canvasGenerator = assets.code.river.generator.riverCanvas()
    obj.canvases = {}


    --{"code/river/generator/riverCanvas.lua"},
    --

    return obj
end

function River:AddNextCanvas()
    if #self.canvases > 0 then
        
    else
        table.insert(self.canvases, self.canvasGenerator:New(camera.oy, true, riverGenerator:GetZone()))
    end
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

        -- check if we need to generate the next segment
        if self.points[1][1][#self.points[1][1]].y > playerY - 1000 then
            --River
            if self.callNextSegment then
                riverGenerator:NextSegment()
                self.callNextSegment = false
            end
        else
            self.callNextSegment = true
        end
    end

    --Canvases :D
    if self.canvases and #self.canvases > 0 and self.canvases[#self.canvases].y <= playerY then
        
    end
end

function River:IsInBounds(x, y)
    
end

function River:GetCurrent(yPos, xPos) -- returns the average direction angle of each path?
    local angle, speed
    speed = 10  -- A temporary value TRUST :D

    if self.points and #self.points > 0 then

        for channel = 1,#self.points do
            --[[local leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos)
            local rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos)

            local leftPercentage = (leftHight.y - leftLow.y)/(leftLow.y - yPos)
            local rightPercentage = (rightHight.y - rightLow.y)/(rightLow.y - yPos)

            local leftX = (leftLow.x) + ((leftHight.x-leftLow.x)*leftPercentage)
            local rightX = (rightLow.x) + ((rightHight.x-rightLow.x)*rightPercentage)

            local centerPos = {x = (leftX + rightX)/2, y = yPos}

            if xPos then
                if leftX < xPos and rightX > xPos then
                    -- we can overwrite these values now
                        -- Could be adding a smaller number but a largr value will make it "smoother"
                    leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, yPos - 25)
                    rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, yPos - 25)
        
                    leftPercentage = (leftHight.y - leftLow.y)/(leftLow.y - yPos)
                    rightPercentage = (rightHight.y - rightLow.y)/(rightLow.y - yPos)
        
                    leftX = (leftLow.x) + ((leftHight.x-leftLow.x)*leftPercentage)
                    rightX = (rightLow.x) + ((rightHight.x-rightLow.x)*rightPercentage)
                    
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

            leftPercentage = (leftHight.y - leftLow.y)/(leftLow.y - yPos)
            rightPercentage = (rightHight.y - rightLow.y)/(rightLow.y - yPos)

            leftX = (leftLow.x) + ((leftHight.x-leftLow.x)*leftPercentage)
            rightX = (rightLow.x) + ((rightHight.x-rightLow.x)*rightPercentage)
            
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
            low = self.points[channel][1][point]
            high = self.points[channel][1][point-1] or self.points[channel][1][point]
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
        love.graphics.draw(self.canvases[i].canvas, self.canvases[i].x*pixlesPerPixle, self.canvases[i].y*pixlesPerPixle, 0, pixlesPerPixle, pixlesPerPixle)

        love.graphics.setLineWidth(5)
        love.graphics.circle("line", self.canvases[i].x*pixlesPerPixle, self.canvases[i].y*pixlesPerPixle, 100)
        love.graphics.circle("line", self.canvases[i].x*pixlesPerPixle, self.canvases[i].y*pixlesPerPixle, 1000)
        love.graphics.circle("line", self.canvases[i].x*pixlesPerPixle, self.canvases[i].y*pixlesPerPixle, 500)

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