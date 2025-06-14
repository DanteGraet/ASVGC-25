local playerShape = love.physics.newCircleShape(22)
-- we use math alot so it should be faster
local math = math

local PlayerBoat = {}
PlayerBoat.__index = PlayerBoat

function PlayerBoat:New(skin)
    local obj = setmetatable({}, PlayerBoat)

    obj.shape = playerShape
    obj.body = love.physics.newBody(world, obj.x, obj.y, "dynamic")
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData({type = "player"})
    if settings.dev.ab_playerCollision.value then
        obj.fixture:setSensor(true)
    end

    obj.image = skin or assets.image.player.default
    obj.image:setFilter("nearest", "nearest")
    obj.imageOx = obj.image:getWidth()/2
    obj.imageOy = obj.image:getHeight()/2

    -- gameOver related
    obj.score = 0
    obj.runTime = 0
    obj.winTimer = 0

    -- health
    obj.maxHealth = 5--00
    obj.health = obj.maxHealth
    obj.deathTime = 0

    -- beaching data
    obj.immunity = 1
    obj.beachTimer = 1  -- 0 means the player has been beached
    obj.shameTimer = 1

    -- acceleration/deecleration
    obj.speed = 150
    obj.acceleration = 150
    obj.maxSpeed = 300
    obj.autoSpeed = 71.3*3
    obj.minSpeed = 0

    -- position
    obj.x = 0
    obj.y = 0
    obj.dir = -math.rad(90)

    -- Turning
    obj.turnSpeed = math.pi/2
    obj.visualDir = obj.dir
    obj.maxAngle = math.rad(150)
    obj.up = -math.rad(90)

    obj.baseTurnSpeed = 1   --WARNING: Deleting or commenting this line or the next will result in immediate loss of spaghettiness
    obj.baseXSpeed = 50     --              you wouldn't want that would you? no,because otherwise you will lose the game

    -- audio tracks
    audioPlayer.NewLoopingSound("motor1", assets.audio.player["Motor-Motor"], "player", 0)
    audioPlayer.NewLoopingSound("motor2", assets.audio.player["Motor-Noise"], "player", 0)
    audioPlayer.NewLoopingSound("motor3", assets.audio.player["Motor-Quindoc"], "player", 0)


    return obj
end

function PlayerBoat:UpdateBeached(dt)
    -- check if it is the first frame the player is beached
    if self.beachTimer == 1 then
        -- forces the ability to take damage from beaching
        self.immunity = 0
        self:TakeDamage(2, false)
    end

    -- update related timers
    self.beachTimer = math.max(self.beachTimer - 2*dt, 0)
    self.shameTimer = self.shameTimer - 0.5*dt

    -- cheeck if thee player is no-longer moving
    if self.beachTimer == 0 and self.shameTimer < 0 and self.health > 0 then
        -- the player is beached
        self:moveToCenter()
        self.beachTimer = 1
        self.immunity = 2
    end
end

function PlayerBoat:UpdateAuto()
    local center = river:getCenter(self.y - 100)
    local dir = nil
    
    if math.abs(center - self.x) > 100 then
        if center - self.x > 0 then
            return {right = true}
        else
            return {left = true}
        end
    else
        local angle = math.atan2(self.y - 100, self.x-center)
        if math.abs(angle - self.dir) > self.winTimer/2 then
            if angle - self.dir > 0 then
                return {right = true}
            else
                return {left = true}
            end
        end
    end

    return {}
end

function PlayerBoat:UpdateDead(dt, bt)
    -- slow down the scrolling for a smooth finnish
    self.deathTime = self.deathTime + dt

    local speedEase = tweens.sineInOut(math.max(1-(self.deathTime/2.5), 0))

    self.x = self.x + (math.cos(self.dir)*(self.speed+self.baseXSpeed) * dt)*speedEase * bt
    self.y = self.y + (math.sin(self.dir)*self.speed * dt) * speedEase * bt

    -- current
    local currentAngle, currentSpeed = river:GetCurrent(self.y)
    if currentAngle then
        self.x = self.x + (math.cos(currentAngle)*currentSpeed * dt) * speedEase * bt
        self.y = self.y + (math.sin(currentAngle)*currentSpeed * dt) * speedEase * bt

        self.current = currentAngle
    end
end

function PlayerBoat:ManageInputs(dt, inputs, bt)
    if -self.y >= riverGenerator:GetLegnth() then
        -- player has won, override inputs
        inputs = self:UpdateAuto(dt)
        if not self.winY then
            self.winY = self.y
            self:UpdateScore()
            love.filesystem.load("code/player/checkUnlocks.lua")()
        end
        self.winTimer = math.min(self.winTimer + dt, 1)
    end

    if inputs.left and not inputs.right then
        self.dir = math.max(self.dir - self.turnSpeed*dt * (self.speed/self.maxSpeed+self.baseTurnSpeed) * bt, self.up - self.maxAngle/2)
    end
    if inputs.right and not inputs.left then
        self.dir = math.min(self.dir + self.turnSpeed*dt * (self.speed/self.maxSpeed+self.baseTurnSpeed) * bt, self.up + self.maxAngle/2 )
    end
    
    if inputs.accelerate then
        self.speed = math.min(self.speed + self.acceleration*dt, self.maxSpeed)
    elseif inputs.decelerate then
        self.speed = math.max(self.speed - self.acceleration*dt, self.minSpeed)
    elseif self.speed > self.autoSpeed then
        self.speed = math.max(
            self.speed - math.min( (( 2 * math.abs(self.speed - self.autoSpeed) + 0.01*self.acceleration)) ,self.acceleration)*dt 
            , self.autoSpeed)
    end
end

function PlayerBoat:MoveWithCurrent(dt, bt)
    local currentXSpeed = currentPlayerPos.current/10+math.sqrt(currentPlayerPos.current)

    self.x = self.x + math.cos(self.dir)*(self.speed+currentXSpeed+self.baseXSpeed) * dt * bt
    self.y = self.y + math.sin(self.dir)*self.speed * dt * (math.sqrt(self.beachTimer))

    -- current
    local currentAngle, currentSpeed = river:GetCurrent(self.y)
    if currentAngle then
        self.x = self.x + math.cos(currentAngle)*currentSpeed * dt  * bt
        self.y = self.y + math.sin(currentAngle)*currentSpeed * dt  * bt

        self.current = currentAngle
    end
end

function PlayerBoat:Update(dt, inputs, gameSpeed)
    self.runTime = self.runTime + dt
    self.x, self.y = self.body:getPosition()

    -- immunity
    if self.immunity > 0 then self.immunity = math.max(self.immunity - dt, 0) end

    --Beaching
    if river:IsInBounds(self.x, self.y) then self.beachTimer = 1; self.shameTimer = 1
    else self:UpdateBeached(dt) end
    local bt = tweens.sineInOut(self.beachTimer)

    
    if self.health > 0 and self.y > riverBorders.up - 100 then
        self:ManageInputs(dt, inputs, bt)

        self:MoveWithCurrent(dt, bt)

        spawnTrail(dt) --spawning damage smoke is in here also

        if not uiSineCounter then uiSineCounter = 0 end
        uiSineCounter = uiSineCounter + dt
        if uiSineCounter > 2*math.pi then uiSineCounter = uiSineCounter - (2*math.pi) end

        self.body:setPosition(self.x, self.y)

        -- Update the audio
        audioPlayer.ModifyLoopingSound("motor3", {volume = ((self.speed/self.maxSpeed)/4 + 0.2) * gameSpeed*self.beachTimer*0.4, pitch = 1+ self.speed/self.maxSpeed/4 })
        audioPlayer.ModifyLoopingSound("motor2", {volume = 0.4*gameSpeed*self.beachTimer*0.4 })
        audioPlayer.ModifyLoopingSound("motor1", {volume = (1- (self.speed/self.maxSpeed)/4 + 0.2)*gameSpeed*self.beachTimer*0.4, pitch = self.speed/self.maxSpeed/2 + .5})
    else
        self:UpdateDead(dt, bt)
    end

    self.visualDir = self.visualDir + (self.dir-self.visualDir)*math.min(10*dt, 1)
end

function PlayerBoat:Draw()
    if self.health > 0 then
        local alpha = 1

        if uiSineCounter and self.immunity > 0 and math.sin(uiSineCounter*30) < 0 and self.beachTimer == 1 then
            alpha = 0.5
        end

        if self.health ~= self.maxHealth then
            love.graphics.setColor(1,tweens.sineOut(1-self.immunity),tweens.sineOut(1-self.immunity),alpha)
        else
            love.graphics.setColor(1,1,1,alpha)
        end

        love.graphics.draw(self.image, self.x, self.y, self.visualDir, 3, 3, self.imageOx, self.imageOy)
    end
end

function PlayerBoat:UpdateScore()
    self.score = math.abs(self.y/10) - self.runTime + self.health*1000
    UpdateHighScore(self.score)
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
    if self.winTimer == 0 then
        return {x = self.x, y = self.y, dir = self.dir}
    else
        return {x = self.x, y = (self.winY or self.y), dir = self.dir}
    end
end

function PlayerBoat:moveToCenter()
    local leftPoint = river:FindHighAndLowPoints(1, 1, self.y)
    local rightPoint = river:FindHighAndLowPoints(1, 2, self.y)
    local midPoint = (leftPoint.x + rightPoint.x)/2

    local newAngle = river:GetCurrent(self.y)
    self.x = midPoint
    self.body:setPosition(self.x, self.y)

    self.dir = newAngle
    self.visualDir = newAngle
    --self.wasBeached = true
end

function PlayerBoat:TakeDamage(amount, noShake)
    if self.immunity == 0 then
        self.health = self.health - amount
        self.immunity = 1

        for i = 1, 7*settings.graphics.particles.value do
            particles.spawnParticle("scrap",player.x+math.random(-8,8),player.y+math.random(-8,8),math.rad(math.random(1,360)), nil, "top")
        end

        if not noShake then
            camera:AddScreenShake(30)
        end

        if self.health <= 0 then
            self:UpdateScore()

            for i = 1, 5*settings.graphics.particles.value do
                particles.spawnParticle("scrap",player.x+math.random(-8,8),player.y+math.random(-8,8),math.rad(math.random(1,360)), nil, "top")
            end

            -- stop playing sounds
            audioPlayer.RemoveLoopingSound("motor3")
            audioPlayer.RemoveLoopingSound("motor2")
            audioPlayer.RemoveLoopingSound("motor1")
        end
    end
end

return PlayerBoat