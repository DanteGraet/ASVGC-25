local font = love.graphics.newFont(100)

local UI = {}


function UI.Draw()

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    -- UiLock, false     Side, False
    local x, y = 0 + 10, 1080 + soy - 10

    local side = 0

    local scale = ((settings.graphics.uiScale.value) + 0.5)/4

    if settings.graphics.uiSide.value then
        if settings.graphics.uiLock.value then
            x = 1920 - 10
        else
            x = 1920 - 10 + sox
        end
    
        side = 1
    end

    if settings.graphics.uiLock.value then
        y = 1080 - 10
    end

    love.graphics.draw(assets.image.ui.currentBar, x, y, 0, scale, scale, assets.image.ui.currentBar:getWidth()*side + 520 - 1040*(1-side), assets.image.ui.currentBar:getHeight())
    love.graphics.draw(assets.image.ui.speedometer, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())

    love.graphics.setColor(.9,.1,.2)
    local angle1 = math.rad(0 - (215*(1-(player.health/player.maxHealth)))) 
    local angle2 = -math.rad(215)
    love.graphics.arc("fill", x - 480*scale + 960*(1-side)*scale, y - 320*scale, 480*scale, angle1, angle2)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(assets.image.ui.speedometerFront, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())


    local playerSpeedPercentage = player.speed/player.maxSpeed
    local dir = playerSpeedPercentage*math.rad(210) - math.rad(30)
    love.graphics.draw(assets.image.ui.needle, x - 480*scale, y - 320*scale, dir, scale, scale, (assets.image.ui.needle:getWidth())-32*side, assets.image.ui.needle:getHeight()/2)
end

return UI