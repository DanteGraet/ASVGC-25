local buttonWidth = 100
local buttonHeight = 100

local newLevelimage = assets.image.levelSelect.pin1
local levelBeatenImage = assets.image.levelSelect.pin2
local stormBeatenImage = assets.image.levelSelect.pin3

return function(level)
    local levelsBeaten = currentProfile.beatenLevels or {}
    local buttonImage

    if levelsBeaten[level .. "Storm"] then
        buttonImage = stormBeatenImage

    elseif levelsBeaten[level] then
        buttonImage = levelBeatenImage

    else
        buttonImage = newLevelimage
    end

    return {
        components = {
            {
                type = "circleCollider",
                x = 0,
                y = 0,
                r = 100,
            },
            {
                type = "imageGraphic",
                image = buttonImage,
                sx = 0.375,
                sy = 0.375,
                ox = buttonImage:getWidth()/2,
                oy = buttonImage:getHeight() - 96/2,
                colour = {1,1,1}
            },
        },
        data = {
            sineEffect = 0,
            sine = 0,
            onRelease = function()
                -- goto level/ open level menu
                menuManager.openMenu("levelMenu", level)
            end,
            update = function(self, button, mx, my, dt)
                if self.mouseState == "clicked" then -- um temporary?
                    self.components[2].colour = {.8,.8,.8}
                else
                    self.components[2].colour = {1,1,1}
                end

                local mx, my = getMouseSoxSoy()
                local dist = 100 - quindoc.pythag(mx, my, self.x, self.y)

                if dist > 0 then
                    dist = math.min(dist*10, 100)
                else
                    dist = 0
                end
                self.sineEffect = quindoc.clamp(dist/10, self.sineEffect-dt*10, self.sineEffect+dt*10)

                if self.sineEffect == 0 then
                    self.sine = 0
                else     
                    self.sine = self.sine+dt*3
                end

                self.components[2].y = -(math.sin(self.sine)+1)*self.sineEffect
            end
        }
    }
end