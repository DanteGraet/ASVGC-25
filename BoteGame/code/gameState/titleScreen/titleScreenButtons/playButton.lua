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
        },
        {
            type = "textGraphic",
            x = -textWidth/2,
            y = -textHeight/2,
            text = buttonText, 
            font = textFont,
            colour = {1,1,.5}, 
        }
    },
    data = {
        sine = 0,
        pi = math.pi,
        onRelease = function()
            gameStateManager.setGameState("levelSelect")
        end,
        update = function(self, button, dt)
            self.x = self.x + dt*10

            if self.mouseMode ~= "none" then
                self.sine = self.sine + dt*self.pi
            else
                self.sine = self.min(self.sine + dt*self.pi, math.ceil(self.sine/self.pi)*self.pi)
            end

            self.components[3].y = math.sin(self.sine)*10 - textHeight/2
        end,
    }
}