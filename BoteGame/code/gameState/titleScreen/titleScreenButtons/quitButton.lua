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
        sine = 0,
        pi = math.pi,

        onRelease = function()
            --gameStateManager.setGameState("levelSelect")
        end,
        update = function(self, button, dt)
          -- if self.mouseState ~= "none" then
          --     self.sine = self.sine - dt*self.pi
          -- else
          --     self.sine = math.min(self.sine + dt*self.pi, math.ceil(self.sine/self.pi)*self.pi)
          -- end

          -- self.components[4].y = math.sin(self.sine)*10 - textHeight/2 + shadowOffset
          -- self.components[5].y = math.sin(self.sine)*10 - textHeight/2
        end,
    }
}