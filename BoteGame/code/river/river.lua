local River = {}
River.__index = River


function River:New()
    local obj = setmetatable({}, River)

    obj.points = {}
    obj.callNextSegment = true

    return obj
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
end

function River:IsInBounds(x, y)
    
end

function River:GetCurrent(yPos) -- returns the average direction angle of each path?
    
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