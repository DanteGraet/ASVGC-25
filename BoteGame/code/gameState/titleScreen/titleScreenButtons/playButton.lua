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
            image = assets.nineslice.button,
            colour = {1,1,1},
            cornerSize = 40
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight+5,
            y = {-buttonHeight*0.15+4, -buttonHeight*0.15 + 4, -buttonHeight*0.15},
            colour = {0,0,0,0.4},
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight,
            y = -buttonHeight*0.15,
            colour = {1,1,1,0.9},
        },
        {
            type = "imageGraphic", --shadow
            ox = -38,
            oy = -23,
            image = assets.image.titleScreenButtons.play,
            colour = {0,0,0,0.4},
        },
        {
            type = "imageGraphic",
            ox = -33,
            oy = -18,
            image = assets.image.titleScreenButtons.play,
            colour = {1,1,1,1},
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