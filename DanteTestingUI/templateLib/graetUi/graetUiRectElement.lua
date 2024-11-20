local GraetUiRect = {}
GraetUiRect.__index = GraetUiRect

function GraetUiRect:New(x, y, sx, sy, fill, curve) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, GraetUiRect)

    obj.x = x or 0
    obj.y = y or 0 
    obj.sx = sx or 100
    obj.sy = sy or 100

    obj.curve = curve or 0
    obj.fill = fill or "fill"

    return obj
end


function GraetUiRect:SetColour(colour1, colour2, colour3)
    self.colour1 = colour1
    self.colour2 = colour2 or colour1
    self.colour3 = colour3 or colour2 or colour1
end


function GraetUiRect:Draw(x, y, mouseMode)
    if self.colour1 then
        if mouseMode == "click" then
            love.graphics.setColor(self.colour3)
        elseif mouseMode == "hover" then
            love.graphics.setColor(self.colour2)
        else
            love.graphics.setColor(self.colour1)
        end
    else
        --a default colour
        love.graphics.setColor(1,1,1)
    end

    love.graphics.rectangle(self.fill, self.x, self.y, self.sx, self.sy. self.curve)
end

return GraetUiRect