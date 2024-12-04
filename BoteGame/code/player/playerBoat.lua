local PlayerBoat = {}
PlayerBoat.__index = PlayerBoat


function PlayerBoat:New(skin)
    local obj = setmetatable({}, PlayerBoat)

    obj.image = skin or assets.image.player.default
    obj.imageOx = obj.image:getWidth()/2
    obj.imageOy = obj.image:getHeight()/2

    obj.x = 0
    obj.y = 0

    obj.speed = 100
    obj.turnSpeed = math.pi/3
    obj.acceleration = 10

    obj.dir = -math.rad(90)

    return obj
end

function PlayerBoat:Update(dt, inputs)

    if inputs.left and not inputs.right then
        self.dir = self.dir - self.turnSpeed*dt
    end
    if inputs.right and not inputs.left then
        self.dir = self.dir + self.turnSpeed*dt
    end

    self.x = self.x + math.cos(self.dir)*self.speed * dt
    self.y = self.y + math.sin(self.dir)*self.speed * dt

end

function PlayerBoat:Draw()
    love.graphics.draw(self.image, self.x, self.y, self.dir, 1, 1, self.imageOx, self.imageOy)
end


function PlayerBoat:getPosition()
    return {x = self.x, y = self.y, dir = self.dir}
end

return PlayerBoat