local Camera = {}
Camera.__index = Camera


function Camera:New(x, y, ox, oy)
    local obj = setmetatable({}, Camera)

    obj.x = x or 0
    obj.y = y  or 0

    obj.ox = ox or 0
    obj.oy = oy or 0

    obj.sx = 0
    obj.sy = 0


    obj.scale = 1

    obj.spdX = 0
    obj.spdY = 0

    return obj
end

function Camera:SetPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function Camera:AddScreenShake(amount, angle)
    local angle = angle
    if not angle then
        angle = math.rad(math.random(1, 360))
    end

    self.sx = self.sx + math.cos(angle)*amount
    self.sy = self.sy + math.sin(angle)*amount
end

function Camera:Update(dt)
    self.sx = math.max(math.abs(self.sx) - dt*10, 0)*quindoc.sign(self.sx)
    self.sy = math.max(math.abs(self.sy) - dt*10, 0)*quindoc.sign(self.sy)
end

function Camera:TranslateCanvas()
    love.graphics.translate(-self.x + self.ox + self.sx, -self.y + self.oy + self.sy)
end

function Camera:GetShake()
    return self.sx, self.sy
end

function Camera:Print()
    print( "x: " .. self.x .. "\ny: " .. self.y)
end

return Camera