local width = 1000
local height = 660
local y = 50

SettingsMenu = {}
SettingsMenu.__index = SettingsMenu



function SettingsMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, SettingsMenu)

    obj.curentCatagroy = 1
    obj.catagories = {
        {name = "graphics", displayName = "Graphics"},
        {name = "audio", displayName = "Audio"},
        {name = "keybinds", displayName = "Keybinds"},
        {name = "dev", displayName = "Dev"},
    }
    obj.isOpen = false

    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    return obj
end

function SettingsMenu:GenerateButtons()
    local xSize = width - 100
    xSize = xSize/#self.catagories

    for i = 1,#self.catagories do
        local c = self.catagories[i]

        self.Ui:AddButton(c.name, -width/2 + (i-1)*xSize, -height/2, xSize, 100)
        self.Ui:GetButtons()[c.name].functions.release = {SettingsMenu.SetCatagory, {self, i}}
        self.Ui:GetButtons()[c.name]:AddText(c.displayName, "center", love.graphics.newFont(40), nil, 25, xSize)
    end

    -- create the close button here
    self.Ui:AddButton("close", width/2 - 100, -height/2, 100, 100)
    self.Ui:GetButtons()["close"].functions.release = {SettingsMenu.Close, self}
end


function SettingsMenu.SetCatagory(data)
    data[1].curentCatagroy = data[2]
end
function SettingsMenu.Close(self)
    self.isOpen = false 
end



function SettingsMenu:KeyRelased(key)
    if key == "escape" then
        self.isOpen = false 
    end
end

function SettingsMenu:Click(x, y)
    self.Ui:Click(x - 960, y - 540)
end

function SettingsMenu:Release(x, y)
    self.Ui:Release(x - 960, y - 540)
end

function SettingsMenu:Update(dt, x, y)
    self.Ui:Update(dt, x - 960, y - 540)
end


function SettingsMenu:Draw()
    love.graphics.reset()

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
    love.graphics.translate(sox, soy)

    --Draw a basic outline
    love.graphics.setColor(0.8,0.7,1,1)
    love.graphics.rectangle("fill", -width/2, -height/2 + y, width, height, 25)

    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", -width/2, -height/2 + y, width, height, 25)




    local xSize = width - 100
    xSize = xSize/#self.catagories

    for i = 1,#self.catagories do
        love.graphics.setColor(0.8,0.7,1,1)

        love.graphics.rectangle("fill", -width/2 + (i-1)*xSize, -height/2, xSize, 100, 25)

        if i == self.curentCatagroy then
           love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2 - (height/2 - 75)*screenScale)
           --love.graphics.setColor(1,0,0,0.5)
           --love.graphics.rectangle("fill", -2000, -2000, 5000, 5000)
        end

        love.graphics.setColor(1,1,1,1)

        love.graphics.rectangle("line", -width/2 + (i-1)*xSize, -height/2, xSize, 100, 25)

        if i == self.curentCatagroy then
           love.graphics.setScissor() 
            if i == 1 then
                love.graphics.line( -width/2, -height/2 + 50, -width/2, 0)
            else
                love.graphics.rectangle("line", -width/2 + (i-2)*xSize, -height/2, xSize, 100, 25)
            end
        end
    end

    --Draw the close button here to hide graphical isues
    love.graphics.setColor(1,0.6,.8,1)
    love.graphics.rectangle("fill", width/2 - 100, -height/2, 100, 100, 25)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", width/2 - 100, -height/2, 100, 100, 25)

    love.graphics.setLineWidth(1)
    self.Ui:Draw()
end