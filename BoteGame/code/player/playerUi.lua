local font = love.graphics.newFont(100)

local storedHealth = player.health

local UI = {}

local currentColours = {
    {0, 199/255, 0},
    {180/255, 199/255, 0},
    {233/255, 132/255, 0},
    {199/255, 52/255, 0},

    {116/255, 63/255, 48/255},

}

function UI:Update(dt)
    if storedHealth > player.health then
        storedHealth = math.max(storedHealth - dt*3, player.health)
    end
    updateZoneTitles(dt)
end

function UI.Draw()

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    -- UiLock, false     Side, False
    local x, y = 0 + 10, 1080 + soy - 10

    local side = 0

    local scale = ((settings.graphics.uiScale.value) + 0.5)/4

    --PLACEHOLDER STORM EFFECT
    --hopefully one day i will replace this with a shader - but not today. :)
--[[
    love.graphics.push()

    love.graphics.reset()

    love.graphics.scale(screenScale)
    
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    love.graphics.translate(sox, soy)


    --this box needs to be big enough as to fill the whole screen

    local scaleX = love.graphics.getWidth() / 1920
    local scaleY = love.graphics.getHeight() / 1080

    love.graphics.setColor(1,1,1,1)]]
--[[]]

    --END PLACEHOLDER

    if settings.graphics.zoneTitles.value then
        drawZoneTitle()
    end

    if settings.graphics.uiSide.value then
        if settings.graphics.uiLock.value then
            x = 1920 - 10
        else
            x = 1920 - 10 + sox
        end
    
        side = 1
    elseif not settings.graphics.uiLock.value then
        x = -sox + 10
    end

    if settings.graphics.uiLock.value then
        y = 1080 - 10
    end

    if player.health < 3 and uiSineCounter then 
        love.graphics.setColor(1,1,1,0.5*math.sin(uiSineCounter*3)/player.health)
        love.graphics.draw(assets.image.ui.ouchGlow, x+12.5, y+12.5, 0, scale, scale, assets.image.ui.ouchGlow:getWidth()*side, assets.image.ui.ouchGlow:getHeight()) 
        love.graphics.setColor(1,1,1,1)
    end

    local tweendHealth = math.floor(storedHealth) + tweens.sineInOut(storedHealth%1)

    healthColour = {.9,.1,.2}
    if player.health == 1 and math.sin(uiSineCounter*30) > 0 then
        healthColour = {1,0.6,0.6}
    elseif tweendHealth and tweendHealth > player.health and math.sin(uiSineCounter*30) > 0 then
        healthColour = {1,0.6,0.6}
    end

    love.graphics.draw(assets.image.ui.currentBar, x, y, 0, scale, scale, assets.image.ui.currentBar:getWidth()*side + 520 - 1040*(1-side), assets.image.ui.currentBar:getHeight())
    love.graphics.draw(assets.image.ui.speedometer, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())

    for i = 1,riverGenerator:GetZone(player.y).currentIcons or 1 do
        love.graphics.setColor(currentColours[i])
        if side == 1 then
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, scale, 1580 - (i*120), assets.image.ui.currentBar:getHeight())
        else
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, -scale, -830 - (i*120))
        end
    end

    for i = riverGenerator:GetZone(player.y).currentIcons or 1, 4 do
        love.graphics.setColor(currentColours[5])
        if side == 1 then
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, scale, 1580 - (i*120), assets.image.ui.currentBar:getHeight())
        else
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, -scale, -830 - (i*120))
        end
    end

    love.graphics.setColor(healthColour)

    local angle1 = math.rad(35 - ((215 + 35)*(1-(tweendHealth/player.maxHealth)))) 
    local angle2 = -math.rad(215)
    love.graphics.arc("fill", x - 480*scale + 960*(1-side)*scale, y - 320*scale, 480*scale, angle1, angle2)

    love.graphics.setColor(healthColour)
    local angle1 = math.rad(35 - ((215 + 35)*(1-(player.health/player.maxHealth)))) 
    local angle2 = -math.rad(215)
    love.graphics.arc("fill", x - 480*scale + 960*(1-side)*scale, y - 320*scale, 480*scale, angle1, angle2)
    love.graphics.setColor(1,1,1)
    
    if player.health < 2 then
        love.graphics.draw(assets.image.ui.speedometerFrontVeryDamage, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())
    elseif player.health < 3 then
        love.graphics.draw(assets.image.ui.speedometerFrontDamage, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())
    else love.graphics.draw(assets.image.ui.speedometerFront, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight()) end

    local playerSpeedPercentage = player.speed/player.maxSpeed
    local dir = playerSpeedPercentage*math.rad(210) - math.rad(30)
    love.graphics.draw(assets.image.ui.needle, x - 480*scale + 960*(1-side)*scale, y - 320*scale, dir, scale, scale, (assets.image.ui.needle:getWidth())-32, assets.image.ui.needle:getHeight()/2)
end

return UI