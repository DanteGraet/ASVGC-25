local imageGraphic = {}

function imageGraphic:new(image, x, y, sx, sy, cornerSize, colour)
    local obj = {
        x =             x           or 0,
        y =             y           or 0,
        width =         sx          or 100,
        height =        sy          or 100, 
        colour =        colour      or {1,1,1},
        image =         image       or nil,
        cornerSize =    cornerSize  or 42,
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

    love.graphics.draw(self.image, self.quads[1], self.x + x, self.y + y)
    love.graphics.draw(self.image, self.quads[2], self.x + x2, self.y + y, 0, mw / (iw - self.cornerSize*2), 1)
    love.graphics.draw(self.image, self.quads[3], self.x + x3, self.y + y)

    love.graphics.draw(self.image, self.quads[4], self.x + x, self.y + y2, 0, 1, mh / (ih - self.cornerSize*2))
    love.graphics.draw(self.image, self.quads[5], self.x + x2, self.y + y2, 0, mw / (iw - self.cornerSize*2), mh / (ih - self.cornerSize*2))
    love.graphics.draw(self.image, self.quads[6], self.x + x3, self.y + y2, 0, 1, mh / (ih - self.cornerSize*2))

    love.graphics.draw(self.image, self.quads[7], self.x + x, self.y + y3)
    love.graphics.draw(self.image, self.quads[8], self.x + x2, self.y + y3, 0, mw / (iw - self.cornerSize*2), 1)
    love.graphics.draw(self.image, self.quads[9], self.x + x3, self.y + y3)


    --love.graphics.draw(self.image, x + self.x, y + self.y, self.r, self.sx, self.sy, self.ox, self.oy)
end

return imageGraphic