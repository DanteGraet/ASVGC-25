local textGraphic = {}

function textGraphic:new(text, font, x, y, colour, anchor)
    local font = font or love.graphics.getFont()

    local obj = {
        x = x,
        y = y,
        text = text,
        colour = colour,
        font = font
    }


    local textWidth = font:getWidth(text or "")
    local textHeight = font:getHeight(text or "")
    anchor = anchor or {0,0}
    obj.x = (x or 0) - textWidth * (anchor[1] or 0)
    obj.y = (x or 0) - textHeight * (anchor[2] or 0)


    setmetatable(obj, self)
    self.__index = self
    return obj, textWidth, textHeight
end

function textGraphic:draw(x, y, mouseState)
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colour)
    love.graphics.print(self.text, x + self.x, y + self.y)
end

return textGraphic