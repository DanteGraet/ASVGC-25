local textFont = font.getFont({"black", 75})

local buttonText = "Quit"
local textWidth = textFont:getWidth(buttonText)
local textHeight = textFont:getHeight(buttonText)

local buttonWidth = 280
local buttonHeight = 110


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
            type = "nineSliceGraphic",
            x = 0,
            y = 0,
            width = buttonWidth,
            height = buttonHeight,
            image = love.graphics.newImage("image/nineSliceTest.png"),
            colour = {1,1,1},
            image = assets.nineslice.button,
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight+4,
            y = -buttonHeight*0.10+8,
            colour = {0,0,0,0.4},
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight,
            y = -buttonHeight*0.10+3,
            colour = {1,1,1,0.9},
        },
        {
            type = "imageGraphic", --shadow
            ox = -26,
            oy = -26,
            image = assets.image.titleScreenButtons.quit,
            colour = {0,0,0,0.4},
        },
        {
            type = "imageGraphic",
            ox = -22,
            oy = -22,
            image = assets.image.titleScreenButtons.quit,
            colour = {1,1,1,1},
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