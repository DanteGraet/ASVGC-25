local textFont = font.getFont({"black", 75})

local buttonText = "Quit"
local textWidth = textFont:getWidth(buttonText)
local textHeight = textFont:getHeight(buttonText)

local buttonWidth = 270
local buttonHeight = 100


return {
    components = {
        {
            type = "rectangleCollider",
            x = 0,
            y = 0,
            sx = buttonWidth,
            sy = buttonHeight,
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight,
            y = -buttonHeight*0.10,
            colour = {1,1,1},
        },
    },
    data = {
        onRelease = function()
            love.event.quit()
        end,
        update = function(self, button, dt)
        end,
    }
}