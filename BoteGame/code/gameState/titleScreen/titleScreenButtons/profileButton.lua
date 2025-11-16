local textFont = font.getFont({"black", 80})

local buttonText = "Profiles"
local textWidth = textFont:getWidth(buttonText)
local textHeight = textFont:getHeight(buttonText)

local buttonWidth = 420
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
            y = -buttonHeight*0.10+6,
            colour = {0,0,0,0.4},
        },
        {
            type = "textGraphic",
            text = buttonText,
            x = buttonHeight,
            y = -buttonHeight*0.10+1,
            colour = {1,1,1,0.9},
        },
        {
            type = "imageGraphic", --shadow
            ox = -26,
            oy = -26,
            image = assets.image.titleScreenButtons.profile,
            colour = {0,0,0,0.4},
        },
        {
            type = "imageGraphic",
            ox = -22,
            oy = -22,
            image = assets.image.titleScreenButtons.profile,
            colour = {1,1,1,1},
        },
    },
    data = {
        sine = 0,
        pi = math.pi,

        onRelease = function()
            menuManager.openMenu("profileSwapper")
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