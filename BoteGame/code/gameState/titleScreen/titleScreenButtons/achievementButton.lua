local buttonWidth = 110
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
            type = "imageGraphic", --shadow
            ox = -25,
            oy = -25,
            image = assets.image.titleScreenButtons.test,
            colour = {0,0,0,0.4},
        },
        {
            type = "imageGraphic",
            ox = -23,
            oy = -23,
            image = assets.image.titleScreenButtons.test,
            colour = {1,1,1,1},
        },
    },
    data = {
        onRelease = function()
        end,
    }
}