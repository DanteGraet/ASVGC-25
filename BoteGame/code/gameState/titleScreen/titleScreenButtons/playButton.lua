local textFont = font.getFont({"black", 150})

local buttonText = "Play"
local textWidth = textFont:getWidth(buttonText)
local textHeight = textFont:getHeight(buttonText)

local buttonWidth = 550
local buttonHeight = 200


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
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight,
            y = -buttonHeight*0.15,
            colour = {1,1,1},
        },
    },
    data = {
        sine = 0,
        pi = math.pi,

        onRelease = function()
            gameStateManager.setGameState("responsiveLoading", false, "levelSelect", "image/loading/title.png")
        end,
        update = function(self, button, dt)
        end,
    }
}