local image = love.graphics.newImage("image/leaf.png")
image:setFilter("nearest", "nearest")

local snowParticle = setmetatable({}, { __index = Particle }) 
snowParticle.__index = snowParticle

function snowParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.speed = love.math.random(75,150)/100
    obj.yVel = love.math.random(120,150)/1000
    obj.savedWindSpeed = ambiance.windSpeed

    obj.timerOffset = math.random(-10,10)/20

    obj.r = math.rad(math.random(1, 360))

    obj.rSpeed = math.random(-15,15)/10
    obj.rCounter = math.random(1,6)
    
    local red = math.random(70,100)/100
    local green = math.random(85,100/100)
    local blue = math.random(0,1)*0.3+0.7

    obj.colour = {red,green,blue,0.8}

    return obj
end

function snowParticle:Update(dt)
    if self.savedWindSpeed < ambiance.windSpeed then
        self.savedWindSpeed = ambiance.windSpeed
    end

   --self.time = self.time + dt*self.timeSpeed

    self.x = self.x + self.speed*self.savedWindSpeed*dt
    self.y = self.y + self.yVel*self.savedWindSpeed*dt 

    self.rCounter = self.rCounter + dt

   -- particle.yVel = particle.yVel + particle.yAccel*dt*particle.savedWindSpeed


    if self.x > love.graphics.getWidth()/2/(GetRiverScale()[1] or screenScale)+100 then
        self.delete = true
    end

    if self.y > riverBorders.down + 100 then
        self.y = riverBorders.up - 100
    end
end

function snowParticle:Draw()
    love.graphics.setColor(self.colour)
    local oy 
    local t = love.math.noise(self.x/1500, self.y/1500)*math.pi*0.3 + ambiance.globalLeafTimer + self.timerOffset
    local r = math.sin(self.rCounter)*self.rSpeed+self.rCounter/6
    
    if t%2 > 1 then
        oy = math.cos((t%2)*math.pi/2) + 1
    else
        oy = -math.cos((t%2)*math.pi)/2 + 0.5
    end

    local ox = (math.sin(t/2 * math.pi))
    --love.graphics.circle("fill", , 10)

    love.graphics.draw(image, self.x + ox*(20+math.sqrt(self.savedWindSpeed)) ,self.y - oy*(15+math.sqrt(self.savedWindSpeed)), self.r+r, 3, 3)
end

return snowParticle