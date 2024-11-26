ParallaxImage = {}
ParallaxImage.__index = ParallaxImage

function ParallaxImage:New(sx, sy, data) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, ParallaxImage)

    obj.canvas = love.graphics.newCanvas(sx or 100, sy or 100)

    local formatedData = {}
    for key, value in pairs(data) do
        local temp = {}

        if type(value[1]) == "string" then
            temp[1] = love.graphics.newImage(value[1])
        elseif type(value[1]) == "userdata" then
            temp[1] = value[1]
        end

        if temp ~= {} then
            temp[2] = value[2] or 0
            table.insert(formatedData, temp)
        end
    end

    obj.data = formatedData
    obj.hovering = 0

    obj.x = 0
    obj.y = 0

    obj:Sort()

    return obj
end


function ParallaxImage:Sort()
    table.sort(self.data, function(a, b)
        return a[2] < b[2]
    end)
end


function ParallaxImage:Update(dt, mx, my)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    local cx = self.canvas:getWidth()/2
    local cy = self.canvas:getHeight()/2

    local mx = mx - self.x - sox
    local my = my - self.y

    if mx >= 0 and mx <= self.canvas:getWidth() and my >= 0 and my <= self.canvas:getHeight() then
        self.hovering = quindoc.clamp(self.hovering + dt, 0, 1)
    else
        self.hovering = quindoc.clamp(self.hovering - dt, 0, 1)
    end
end


function ParallaxImage:Draw(x, y, mx, my)

    local cx = self.canvas:getWidth()/2
    local cy = self.canvas:getHeight()/2

    local mx = mx - x - cx
    local my = my - y - cy

    love.graphics.push()
    love.graphics.reset()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    for i = 1,#self.data do
        local img = self.data[i][1]
        local layer = self.data[i][2]
        love.graphics.draw(img, cx + mx*layer*tweens.sineInOut(self.hovering), cy + my*layer*tweens.sineInOut(self.hovering), 0, 1, 1, img:getWidth()/2, img:getHeight()/2)
    end

    love.graphics.setCanvas()
    love.graphics.pop()

    love.graphics.draw(self.canvas, x, y, 0, 1, 1)

    self.x = x
    self.y = y
end
