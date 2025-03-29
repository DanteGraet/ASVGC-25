local River = {}
River.__index = River

pixlesPerPixle = 3

function River:New()
    local obj = setmetatable({}, River)

    obj.points = {}

    obj.backgroundImages = {}

    obj.movedPlayer = false


    return obj
end

function River:HasPoints()
    return self.points[1][1]
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
    local playerY = (player.winY or player.y) + 50

    if self.points and #self.points > 0 then
        for channel = 1,#self.points do
            --loop though each side
            for side = 1,#self.points[channel] do
                for i = 1,#self.points[channel][side] do
                    local point = self.points[channel][side][2]

                    if point and point.y > playerY then
                        table.remove(self.points[channel][side], 1)
                    else
                        -- no longer check this side of this channel
                        break
                    end
                end
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

function River:getCenter(y)     -- MERICA 🦅🦅🦅
    local leftHight, leftLow = self:FindHighAndLowPoints(1, 1, y)
    local rightHight, rightLow = self:FindHighAndLowPoints(1, 2, y)

    local leftPercentage = (y - leftLow.y)/(leftHight.y - leftLow.y)
    local rightPercentage = (y - rightLow.y)/(rightHight.y - rightLow.y)

    local leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
    local rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage

    return (leftX + rightX)/2 
end

function River:FindHighAndLowPoints(channel, side, yPos)
    local high, low

    for point = 1,#self.points[channel][side] do
        if self.points[channel][side][point].y < yPos then
            low = self.points[channel][side][point]
            high = self.points[channel][side][point-1] or self.points[channel][side][point]
            return high, low or high
        end
    end

    --just guess at this point
    local h = self.points[channel][side][1]
    local l =self.points[channel][side][2]
    return h, l or h
end


function River:getDistToEdge(x, y)
    if self.points and #self.points > 0 then
        for channel = 1,#self.points do
            local leftHight, leftLow = self:FindHighAndLowPoints(channel, 1, y)
            local rightHight, rightLow = self:FindHighAndLowPoints(channel, 2, y)

            local leftPercentage = (y - leftLow.y)/(leftHight.y - leftLow.y)
            local rightPercentage = (y - rightLow.y)/(rightHight.y - rightLow.y)

            local leftX = leftLow.x + (leftHight.x - leftLow.x)*leftPercentage
            local rightX = rightLow.x + (rightHight.x - rightLow.x)*rightPercentage


            return math.max(leftX - x, (rightX - x)*-1)

        end
    end
end

function River:GetCurrent(yPos, xPos) -- returns the average direction angle of each path?
    local angle, speed

    local p = riverGenerator:GetPercentageThrough(player.y)
    

    if type(zones[1]) == "table" then --if we are in a transition

        current = (quindoc.runIfFunc(zones[1].current,p) or 0)*(1-zones[3]) + (quindoc.runIfFunc(zones[2].current,0) or 0)*zones[3] 

    else --just set the snow amount to what it needs to be

        current = quindoc.runIfFunc(zones.current,p) or 0 --current is a GLOBAL VALUE for a reason btw

    end    

    speed = currentPlayerPos.current

    if self.points and #self.points > 0 then
        for channel = 1,#self.points do

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


function River:addBackgorundFromData(imageData)
    local tempImage = love.image.newImageData(imageData.width, imageData.height+1)

    for y = 1,#imageData.pixles do
        for x = 1,#imageData.pixles[y] do
            local c = imageData.pixles[y][x]

            tempImage:setPixel(x-1, y-1, c[1], c[2], c[3], 1)
        end
    end
    local finalImage = love.graphics.newImage(tempImage)
    finalImage:setFilter("nearest", "nearest")

    table.insert(self.backgroundImages, {y = -imageData.y, image = finalImage, x = -(imageData.width/2)*pixlesPerPixle})
end

function River:Draw(scale)
    love.graphics.push()
    --love.graphics.scale(1/scale)


    for i = 1,#self.backgroundImages do
        local image = self.backgroundImages[i]
        love.graphics.draw(image.image, image.x, image.y, 0, 3, 3)
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