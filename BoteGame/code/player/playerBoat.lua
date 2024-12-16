local PlayerBoat = {}
PlayerBoat.__index = PlayerBoat


function PlayerBoat:New(skin)
    local obj = setmetatable({}, PlayerBoat)

    obj.image = skin or assets.image.player.default
    obj.imageOx = obj.image:getWidth()/2
    obj.imageOy = obj.image:getHeight()/2

    obj.x = 0
    obj.y = 0

    obj.maxHealth = 5
    obj.health = 2


    obj.speed = 100
    obj.acceleration = 10
    obj.maxSpeed = 150
    obj.minSpeed = 0

    obj.turnSpeed = math.pi/3
    obj.dir = -math.rad(90)
    obj.maxAngle = math.rad(120)
    obj.up = -math.rad(90)

    return obj
end

function PlayerBoat:Update(dt, inputs)
    if inputs.left and not inputs.right then
        self.dir = math.max(self.dir - self.turnSpeed*dt * (self.speed/self.maxSpeed), self.up - self.maxAngle/2)
    end
    if inputs.right and not inputs.left then
        self.dir = math.min(self.dir + self.turnSpeed*dt * (self.speed/self.maxSpeed), self.up + self.maxAngle/2 )
    end
    if inputs.accelerate then
        self.speed = math.min(self.speed + self.acceleration*dt, self.maxSpeed)
    elseif inputs.decelerate then
        self.speed = math.max(self.speed - self.acceleration*dt, self.minSpeed)
    end

    self.x = self.x + math.cos(self.dir)*self.speed * dt
    self.y = self.y + math.sin(self.dir)*self.speed * dt

    -- current
    local currentAngle, currentSpeed = river:GetCurrent(self.y)
    if currentAngle then
        self.x = self.x + math.cos(currentAngle)*currentSpeed * dt
        self.y = self.y + math.sin(currentAngle)*currentSpeed * dt

        self.current = currentAngle
    end

    spawnTrail(dt)

end

function PlayerBoat:Draw()
    if river:IsInBounds(self.x, self.y ) then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(1,0,0)
    end

    love.graphics.draw(self.image, self.x, self.y, self.dir, 3, 3, self.imageOx, self.imageOy)

    if self.current then   
        --love.graphics.line(self.x, self.y, self.x+math.cos(self.current)*100, self.y+math.sin(self.current)*100)
    end
end


function PlayerBoat:GetPosition()
    return {x = self.x, y = self.y, dir = self.dir}
end

return PlayerBoat