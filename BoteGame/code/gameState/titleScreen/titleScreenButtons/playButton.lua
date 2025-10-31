local textFont = font.getFont({"black", 100})

local buttonText = "Play"
local textWidth = textFont:getWidth(buttonText)
local textHeight = textFont:getHeight(buttonText)

return {
    components = {
        {
            type = "rectangleCollider",
            x = -textWidth/2,
            y = -textHeight/2,
            sx = textWidth,
            sy = textHeight,
        },
        {
            type = "textGraphic",
            x = -textWidth/2,
            y = -textHeight/2,
            text = buttonText, 
            font = textFont,
            colour = {1,1,1}, 
        }
    },
    data = {
        onRelease = function()
            gameStateManager.setGameState("levelSelect")
        end
    }
}