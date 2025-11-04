local imageGraphic = {}

function imageGraphic:new()
    local obj = {
        x = 0,
        y = 0,
        width = 100,
        height = 100, 
        colour = {1,1,1},
        image = nil,
        cornerSize = 10,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function imageGraphic:draw(x, y, mouseState)
    -- create the quads from the image
    if not self.quads then
        local imageWidth, imageHeight = self.image:getDimensions()
        self.quads = {
            love.graphics.newQuad(0,                            0, self.cornerSize,                 self.cornerSize, imageWidth, imageHeight),
            love.graphics.newQuad(self.cornerSize,              0, imageWidth-self.cornerSize*2,    self.cornerSize, imageWidth, imageHeight),
            love.graphics.newQuad(imageWidth - self.cornerSize, 0, self.cornerSize,                 self.cornerSize, imageWidth, imageHeight),


            love.graphics.newQuad(0,                            self.cornerSize, self.cornerSize,                 imageHeight - self.cornerSize * 2, imageWidth, imageHeight),
            love.graphics.newQuad(self.cornerSize,              self.cornerSize, imageWidth-self.cornerSize*2,    imageHeight - self.cornerSize * 2, imageWidth, imageHeight),
            love.graphics.newQuad(imageWidth - self.cornerSize, self.cornerSize, self.cornerSize,                 imageHeight - self.cornerSize * 2, imageWidth, imageHeight),


            love.graphics.newQuad(0,                            imageHeight - self.cornerSize, self.cornerSize,                 self.cornerSize, imageWidth, imageHeight),
            love.graphics.newQuad(self.cornerSize,              imageHeight - self.cornerSize, imageWidth-self.cornerSize*2,    self.cornerSize, imageWidth, imageHeight),
            love.graphics.newQuad(imageWidth - self.cornerSize, imageHeight - self.cornerSize, self.cornerSize,                 self.cornerSize, imageWidth, imageHeight),
        }
    end

    love.graphics.setColor(self.colour)

    local iw, ih = self.image:getDimensions()

    -- positions
    local x2, x3 = x + self.cornerSize, x + self.width - self.cornerSize
    local y2, y3 = y + self.cornerSize, y + self.height - self.cornerSize

    -- widths & heights of stretch areas
    local mw, mh = self.width - self.cornerSize*2, self.height - self.cornerSize*2

    love.graphics.draw(self.image, self.quads[1], x, y)
    love.graphics.draw(self.image, self.quads[2], x2, y, 0, mw / (iw - self.cornerSize*2), 1)
    love.graphics.draw(self.image, self.quads[3], x3, y)

    love.graphics.draw(self.image, self.quads[4], x, y2, 0, 1, mh / (ih - self.cornerSize*2))
    love.graphics.draw(self.image, self.quads[5], x2, y2, 0, mw / (iw - self.cornerSize*2), mh / (ih - self.cornerSize*2))
    love.graphics.draw(self.image, self.quads[6], x3, y2, 0, 1, mh / (ih - self.cornerSize*2))

    love.graphics.draw(self.image, self.quads[7], x, y3)
    love.graphics.draw(self.image, self.quads[8], x2, y3, 0, mw / (iw - self.cornerSize*2), 1)
    love.graphics.draw(self.image, self.quads[9], x3, y3)


    --love.graphics.draw(self.image, x + self.x, y + self.y, self.r, self.sx, self.sy, self.ox, self.oy)
end

return imageGraphic