local debugColours = {
    none = {0,0,1},
    hover = {0,1,0},
    clicked = {1,0,0},
}

local circleCollider = {}

function circleCollider:new(x, y, r)
    local obj = {
        x = x,
        y = y,
        r = r
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function circleCollider:checkHover(button, x, y)
    return quindoc.pythag(x, y, self.x, self.y) < self.r, quindoc.pythag(x, y, self.x, self.y) - self.r
end

function circleCollider:drawDebug(button, x, y)
    love.graphics.setColor(debugColours[button.mouseState or "none"])
    love.graphics.circle("line", x + self.x, y + self.y, self.r)
end

return circleCollider