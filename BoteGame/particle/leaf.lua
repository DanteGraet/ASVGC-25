local image = love.graphics.newImage("image/leaf.png")
image:setFilter("nearest", "nearest")

local snowParticle = setmetatable({}, { __index = Particle }) 
snowParticle.__index = snowParticle

function snowParticle:New(spawnX,spawnY,spawnAngle,spawnData)
    local obj = Particle:New(spawnX,spawnY,spawnAngle,spawnData)
    setmetatable(obj, self)

    obj.time = spawnAngle --+ math.random(-10, 10)/100
    obj.timeSpeed = math.random(150, 160)/100

    obj.speed = love.math.random(75,125)/100
    obj.yVel = love.math.random(100,200)/1000
    obj.savedWindSpeed = ambiance.windSpeed

    obj.r = math.rad(math.random(1, 360))


    return obj
end

function snowParticle:Update(dt)
    if self.savedWindSpeed < ambiance.windSpeed then
        self.savedWindSpeed = ambiance.windSpeed
    end

   --self.time = self.time + dt*self.timeSpeed

    self.x = self.x + self.speed*self.savedWindSpeed*dt
    self.y = self.y + self.yVel*self.savedWindSpeed*dt 

   -- particle.yVel = particle.yVel + particle.yAccel*dt*particle.savedWindSpeed


    if self.x > love.graphics.getWidth()/2/(GetRiverScale()[1] or screenScale)+100 then
        self.delete = true
    end

    if self.y > riverBorders.down + 100 then
        self.y = riverBorders.up - 100
    end
end

function snowParticle:Draw()
    love.graphics.setColor(1,1,1,0.8)
    local oy 
    local t = love.math.noise(self.x/500, self.y/500)*math.pi*2 + ambiance.globalLeafTimer
    if t%2 > 1 then
        oy = math.cos((t%2)*math.pi/2) + 1
    else
        oy = -math.cos((t%2)*math.pi)/2 + 0.5
    end

    local ox = (math.sin(t/2 * math.pi))
    --love.graphics.circle("fill", , 10)

    love.graphics.draw(image, self.x + ox*self.savedWindSpeed/2 ,self.y - oy*self.savedWindSpeed/5, self.r, 3, 3)
end

return snowParticle