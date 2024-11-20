local Text = require("templateLib.graetUi.graetUiTextElement")

local GraetButton = {}
GraetButton.__index = GraetButton

local drawHitboxes = true

function GraetButton.toglehitboxes()
    drawHitboxes = not drawHitboxes
end

function GraetButton:New(x, y, sx, sy) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, GraetButton)

    obj.x = x
    obj.y = y
    obj.sx = sx
    obj.sy = sy

    obj.graphics = {}

    obj.functions = {
        click = {},
        hover = {},
        release = {},
    }

    obj.mouseMode = "none"

    return obj
end


function GraetButton:AddText(text, align, font, x, y, limit, pos)
    table.insert(self.graphics, pos or #self.graphics+1, Text:New(text, align, font, x, y))
end

function GraetButton:AddRect(x, y, sx, sy, fill, curve, pos)
    table.insert(self.graphics, pos or #self.graphics+1, Text:New(x, y, sx, sy, fill, curve))
end

function GraetButton:SetElementColour(elementNo, c1, c2, c3)
    self.graphics[elementNo]:SetColour(c1, c2, c3)
end


function GraetButton:Update(dt, mx, my)
    if mx > self.x and mx < self.x + self.sx and my > self.y and my < self.y + self.sy then
        if self.mouseMode == "none" then
            
            self.mouseMode = "hover"
            if #self.functions.hover > 0 then
                for i = 1,#self.functions.hover do
                    self.functions.hover[1](self.functions.hover[2])
                end
            end

        end
    elseif self.mouseMode == "hover" then
        self.mouseMode = "none"
    end
end

function GraetButton:Click(mx, my)
    if mx > self.x and mx < self.x + self.sx and my > self.y and my < self.y + self.sy then
        
        self.mouseMode = "click"
        if #self.functions.click > 0 then
            for i = 1,#self.functions.click do
                self.functions.click[1](self.functions.click[2])
            end
        end

    end
end

function GraetButton:Release(mx, my)
    self.mouseMode = "none"

    if mx > self.x and mx < self.x + self.sx and my > self.y and my < self.y + self.sy then
        
        self.mouseMode = "hover"
        if #self.functions.release > 0 then
            for i = 1,#self.functions.release do
                self.functions.release[1](self.functions.release[2])
            end
        end
        
    end
end



function GraetButton:Draw()
    for i = 1,#self.graphics do
        self.graphics[i]:Draw(self.x, self.y, self.mouseMode)
    end

    if drawHitboxes then
        if self.mouseMode == "click" then
            love.graphics.setColor(0,1,0)
        elseif self.mouseMode == "hover" then
            love.graphics.setColor(0,0,1)
        else 
            love.graphics.setColor(1,0,0)
        end

        love.graphics.rectangle("line", self.x, self.y, self.sx, self.sy)

    end
end



return GraetButton