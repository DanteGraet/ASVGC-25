local imageGraphic = {}

function imageGraphic:new()
    local obj = {
        x = 0,
        y = 0,
        r = 0,
        sx = 1,
        sy = 1, 
        ox = 0,
        oy = 0,
        colour = {1,1,1},
        image = nil,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function imageGraphic:draw(x, y, mouseState)
    love.graphics.setColor(self.colour)
    love.graphics.draw(self.image, x + self.x, y + self.y, self.r, self.sx, self.sy, self.ox, self.oy)
end

return imageGraphic