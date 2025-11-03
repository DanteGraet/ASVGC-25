local buttonWidth = 100
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
    },
    data = {
        onRelease = function()
        end,
    }
}