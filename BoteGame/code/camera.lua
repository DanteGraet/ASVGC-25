local Camera = {}
Camera.__index = Camera


function Camera:New(x, y, ox, oy)
    local obj = setmetatable({}, Camera)

    obj.x = x or 0
    obj.y = y  or 0

    obj.ox = ox or 0
    obj.oy = oy or 0

    obj.scale = 1

    obj.spdX = 0
    obj.spdY = 0

    return obj
end

function Camera:SetPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end


function Camera:TranslateCanvas()
    love.graphics.translate(-self.x + self.ox, -self.y + self.oy)
end

function Camera:Print()
    print( "x: " .. self.x .. "\ny: " .. self.y)
end

return Camera