local displayTitleCounter
local displayTitleAlpha
savedDisplayName = nil --this needs to be global for various reasons
local savedSubtitle
local savedDistance

function updateZoneTitles(dt)

    if zones.displayName and zones.displayName ~= savedDisplayName then
        savedDisplayName = zones.displayName or ""
        savedSubtitle = zones.subtitle or ""
        savedDistance = zones.distanceTitle or ""
        displayTitleCounter = -1
    end

    if not displayTitleCounter then displayTitleCounter = -1 end

    displayTitleCounter = math.min(displayTitleCounter+dt,5)

    if displayTitleCounter == -1 then
        displayTitleCounter = 0
    elseif displayTitleCounter < 3 then
        displayTitleAlpha = displayTitleCounter*2
    elseif displayTitleCounter >= 3 then
        displayTitleAlpha = 1-(displayTitleCounter-3)/2
    end

end

function drawZoneTitle()
    if savedDisplayName then
        love.graphics.setColor(1,1,1,displayTitleAlpha)
        font.setFont("black", 64)
        love.graphics.printf(savedDisplayName,0,300-tweens.cubicOut(math.min(displayTitleCounter/2,1),0,100),1920,"center")
        font.setFont("black", 24)
        love.graphics.printf(savedSubtitle,0,290-tweens.cubicOut(math.min(displayTitleCounter/2,1),0,100),1920,"center")
        --love.graphics.setColor(1,1,1,displayTitleAlpha/2)
        --love.graphics.setFont(assets.font.fontBlack32)
        --love.graphics.printf(savedDistance,0,380-tweens.cubicOut(math.min(displayTitleCounter/2,1),0,100),1920,"center")
        love.graphics.setColor(1,1,1,1)
    end
end
