local GraetUiText = {}
GraetUiText.__index = GraetUiText

function GraetUiText:New(text, align, font, x, y, limit) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, GraetUiText)

    obj.text = text

    obj.align = align or "left"
    obj.font = font or love.graphics.getFont()

    obj.x = x or 0
    obj.y = y or 0 
    obj.limit = limit or math.huge
    
    return obj
end


function GraetUiText:SetColour(colour1, colour2, colour3)
    self.colour1 = colour1
    self.colour2 = colour2 or colour1
    self.colour3 = colour3 or colour2 or colour1
end


function GraetUiText:Draw(x, y, mouseMode)
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

    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, x + self.x, y + self.y, self.limit, self.align)
end

return GraetUiText