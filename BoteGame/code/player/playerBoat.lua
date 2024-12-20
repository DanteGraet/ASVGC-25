local playerShape = love.physics.newCircleShape(22)

local PlayerBoat = {}
PlayerBoat.__index = PlayerBoat


function PlayerBoat:New(skin)
    local obj = setmetatable({}, PlayerBoat)

    obj.shape = playerShape
    obj.body = love.physics.newBody(world, obj.x, obj.y, "dynamic")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData({type = "player"})

    obj.fixture:setSensor(true)

    obj.image = skin or assets.image.player.default
    obj.imageOx = obj.image:getWidth()/2
    obj.imageOy = obj.image:getHeight()/2

    obj.x = 0
    obj.y = 0
    obj.score = 0

    obj.immunity = 1

    obj.maxHealth = 5
    obj.health = obj.maxHealth
    obj.deathTime = 0

    obj.speed = 150
    obj.acceleration = 150
    obj.maxSpeed = 300
    obj.minSpeed = 0

    obj.turnSpeed = math.pi/3
    obj.dir = -math.rad(90)
    obj.maxAngle = math.rad(120)
    obj.up = -math.rad(90)

    obj.baseTurnSpeed = 1 --WARNING: Deleting or commenting this line or the next will result in immediate loss of spaghettiness
    obj.baseXSpeed = 0 --you wouldn't want that would you? no,because otherwise you will lose the game

    --[[
    --for testing
    obj.immunity = 10000
    obj.speed = 100
    obj.acceleration = 3000
    obj.maxSpeed = 1000
    obj.minSpeed = -1000
    ]]

    return obj
end

function PlayerBoat:Update(dt, inputs)
    if self.immunity > 0 then
        self.immunity = math.max(self.immunity - dt, 0)
    end

    if player.health > 0 then
        if inputs.left and not inputs.right then
            self.dir = math.max(self.dir - self.turnSpeed*dt * (self.speed/self.maxSpeed+self.baseTurnSpeed), self.up - self.maxAngle/2)
        end
        if inputs.right and not inputs.left then
            self.dir = math.min(self.dir + self.turnSpeed*dt * (self.speed/self.maxSpeed+self.baseTurnSpeed), self.up + self.maxAngle/2 )
        end
        if inputs.accelerate then
            self.speed = math.min(self.speed + self.acceleration*dt, self.maxSpeed)
        elseif inputs.decelerate then
            self.speed = math.max(self.speed - self.acceleration*dt, self.minSpeed)
        end

        self.baseXSpeed = 15*math.sqrt(current or 0)

        self.x = self.x + math.cos(self.dir)*(self.speed+self.baseXSpeed) * dt
        self.y = self.y + math.sin(self.dir)*self.speed * dt
        self.score = math.abs(self.y/10)

        -- current
        local currentAngle, currentSpeed = river:GetCurrent(self.y)
        if currentAngle then
            self.x = self.x + math.cos(currentAngle)*currentSpeed * dt
            self.y = self.y + math.sin(currentAngle)*currentSpeed * dt

            self.current = currentAngle
        end

        spawnTrail(dt) --spawning damage smoke is in here also

        if not uiSineCounter then uiSineCounter = 0 end
        uiSineCounter = uiSineCounter + dt
        if uiSineCounter > 2*math.pi then uiSineCounter = 0 end

        self.body:setPosition(self.x, self.y)
    else
        self.deathTime = self.deathTime + dt

        local speedEase = tweens.sineInOut(math.max(1-(self.deathTime/2.5), 0))

        self.x = self.x + (math.cos(self.dir)*(self.speed+self.baseXSpeed) * dt)*speedEase
        self.y = self.y + (math.sin(self.dir)*self.speed * dt) * speedEase

        -- current
        local currentAngle, currentSpeed = river:GetCurrent(self.y)
        if currentAngle then
            self.x = self.x + (math.cos(currentAngle)*currentSpeed * dt) * speedEase
            self.y = self.y + (math.sin(currentAngle)*currentSpeed * dt) * speedEase

            self.current = currentAngle
        end
    end
end

function PlayerBoat:Draw()
    if player.health > 0 then
        love.graphics.draw(self.image, self.x, self.y, self.dir, 3, 3, self.imageOx, self.imageOy)
    end
end


function PlayerBoat:DrawHitbox()
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())

    love.graphics.setColor(1,0,0)
    local x, y = self.body:getLinearVelocity( )
    love.graphics.line(self.body:getX(), self.body:getY(), self.body:getX() +x , self.body:getY()+y)


    love.graphics.setColor(1,1,1)

    if self.current then   
        love.graphics.line(self.x, self.y, self.x+math.cos(self.current)*100, self.y+math.sin(self.current)*100)
    end
end

function PlayerBoat:GetPosition()
    return {x = self.x, y = self.y, dir = self.dir}
end


function PlayerBoat:TakeDamage(amount)
    if self.immunity == 0 then
        self.health = self.health - amount
        self.immunity = 1

        camera:AddScreenShake(30)

        if self.health <= 0 then
            UpdateHighScore(self.score)
        end
    end
end

return PlayerBoat