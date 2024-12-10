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

function River:GetCurrent(yPos) -- returns the average direction angle of each path?
    
end

function River:Draw(scale)
    --love.graphics.setCanvas()

    love.graphics.push()
    --love.graphics.scale(1/scale)

    love.graphics.setColor(1,1,1)
    for i = 1,#self.canvases do
        print(self.canvases[i].x, self.canvases[i].y)
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