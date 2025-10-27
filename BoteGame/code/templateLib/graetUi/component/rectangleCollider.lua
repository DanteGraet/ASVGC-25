local debugColours = {
    none = {0,0,1},
    hover = {0,1,0},
    clicked = {1,0,0},
}

local rectangleCollider = {}

function rectangleCollider:new(x, y, sx, sy)
    local obj = {
        x = x or 0,
        y = y or 0,
        sx = sx or 100,
        sy = sy or 100,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function rectangleCollider:checkHover(x, y)
    return x > self.x and  x < self.x + self.sx and y > self.y and y < self.y + self.sy
end

function rectangleCollider:drawDebug(x, y, button)
    love.graphics.setColor(debugColours[button.mouseState or "none"])
    love.graphics.rectangle("line", x + self.x, y + self.y, self.sx, self.sy)
end

return rectangleCollider