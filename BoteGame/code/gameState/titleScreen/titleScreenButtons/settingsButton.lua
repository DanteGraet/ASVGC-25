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
            ox = -26,
            oy = -26,
            image = assets.image.titleScreenButtons.settings,
            colour = {0,0,0,0.4},
        },
        {
            type = "imageGraphic",
            ox = -22,
            oy = -22,
            image = assets.image.titleScreenButtons.settings,
            colour = {1,1,1,1},
        },
    },
    data = {
        onRelease = function()
            menuManager.openMenu("settingsMenu")
        end,
    }
}