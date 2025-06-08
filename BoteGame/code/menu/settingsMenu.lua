local width = 1000
local height = 660
local y = 50

local font1 = {"medium", 30}
local font2 = {"black", 35}

local changingKeybind = {false}

local function clickKeybind(data)
    --[[data = {
    type, num, 
    }]]
    changingKeybind = {true, data[1], data[2]}
    
end

SettingsMenu = {}
SettingsMenu.__index = SettingsMenu

function saveSettings()
    local savingSettings = {}

    for key, value in pairs(settings) do
        if (key ~= "DEV" or DEV) and key ~= "order" then
            savingSettings[key] = {}

            for setting, data in pairs(value) do

                savingSettings[key][setting] = data.value

            end

        end
    end

    print("saving player settings")
    dante.save(savingSettings, "save", "settings")
end

function SettingsMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, SettingsMenu)

    obj.curentCatagroy = 1
    obj.catagories = {
        {name = "graphics", displayName = "Graphics", targetScroll = 0},
        {name = "audio", displayName = "Audio", targetScroll = 0},
        {name = "keybinds", displayName = "Keybinds", targetScroll = 0},

    }
    if DEV then
        table.insert(obj.catagories, {name = "dev", displayName = "Dev", targetScroll = 0})
    end


    obj.isOpen = false
    obj.scroll = 0

    settings = love.filesystem.load("code/menu/defaultSettings.lua")()

    local savedSettings = dante.load("save/settings")

    if savedSettings then
        -- looping through catagories
        for catagory, settingList in pairs(settings) do
            if (catagory ~= "DEV" or DEV) and catagory ~= "order" then
                if savedSettings[catagory] then
                    -- looking though all saved setting with the current SetCatagory
                    for key, value in pairs(savedSettings[catagory]) do
                        if settings[catagory][key] then
                            settings[catagory][key].value = savedSettings[catagory][key]
                            print(catagory, key)
                        end
                    end
                    
                    --[[for setting, data in pairs(value) do
                        if savedSettings[key][setting] then
                            --print(setting .. "  " .. tostring(savedSettings[key][setting]))
                            settings[key].value = savedSettings[key][setting]
                        end
                    end]]
                end
            end
        end
    end

    if settings.graphics.fullscreen.value then
        love.window.setFullscreen(true)
    end


    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    SettingsMenu.SetCatagory({obj, 1})

    return obj
end

function SettingsMenu:GenerateButtons()
    local xSize = width - 100
    xSize = xSize/#self.catagories

    for i = 1,#self.catagories do
        local c = self.catagories[i]

        self.Ui:AddButton(c.name, -width/2 + (i-1)*xSize, -height/2, xSize, 100)
        self.Ui:GetButtons()[c.name].functions.release = {SettingsMenu.SetCatagory, {self, i}}
        self.Ui:GetButtons()[c.name]:AddText(c.displayName, "center", {"black", 40}, nil, 15, xSize)
    end

    -- create the close button here
    self.Ui:AddButton("close", width/2 - 100, -height/2, 100, 100)
    self.Ui:GetButtons()["close"].functions.release = {SettingsMenu.Close, self}
end

local function sliderFunction(value, slider)
    slider.value = value
end

local function toggleFunction(value, toggle)
    toggle.value = value


    if toggle == settings.graphics.fullscreen then
        settingsMenu:toggleFullscreen()
    end
end

function SettingsMenu:toggleFullscreen()
    local mx, my = love.mouse.getPosition()

    mx, my = mx/screenScale, my/screenScale
    love.window.setFullscreen(not love.window.getFullscreen())
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())

    if self.catagories[self.curentCatagroy].name == "graphics" then
        self.Ui:GetButtons("settings")["fullscreen"].value = love.window.getFullscreen()
    end

    love.mouse.setPosition(mx*screenScale, my*screenScale)
end


function SettingsMenu.SetCatagory(data)
    local self = data[1] 
    self.curentCatagroy = data[2]
    
    
    -- Create the settings buttons here
    local colours = {
        {.9,.9,.9},
        {.7,.9,.7},
        {.6,.6,.6},
    }
    local currentHeight = -height/2 + y + 55
    local currentX = -width/2 + 10
    self.Ui:RemoveAll("settings")

    local f = font.getFont(font1)

    if settings.order[self.catagories[self.curentCatagroy].name] then
        for i = 1,#settings.order[self.catagories[self.curentCatagroy].name] do
            local name = settings.order[self.catagories[self.curentCatagroy].name][i]
            local currentSetting = settings[self.catagories[self.curentCatagroy].name][name]

            if currentSetting.type == "button" then
                self.Ui:AddTextButton(name, currentSetting.displayName, nil, font1, currentX, currentHeight, 400, colours, "settings")
                self.Ui:GetButtons("settings")[name].functions.release = {currentSetting.func}

            elseif currentSetting.type == "keybindButton" then
                self.Ui:AddTextButton(name, currentSetting.displayName, nil, font1, currentX, currentHeight, 400, nil, "settings")
                for i = 1,2 do
                    local h = f:getHeight()
                    --name, x, y, sx, sy, layer
                    self.Ui:AddButton(name .. i, -500 + i*200, currentHeight, 200, h, "settings")
                    self.Ui:GetButtons("settings")[name .. i].functions.release = {clickKeybind, {name, i}}
                    self.Ui:GetButtons("settings")[name .. i]:AddText("[" .. currentSetting.value[i] .. "]", "center", font1, 0, 0, 200)
                    self.Ui:GetButtons("settings")[name .. i]:SetElementColour(colours[1], colours[2], colours[1+2])

                end
            

            elseif currentSetting.type == "slider" then
                self.Ui:AddSlider(name, currentX+f:getWidth(currentSetting.displayName) + 10, currentHeight + 20, 25, 30, 250, 20, currentSetting.value, "settings")

                self.Ui:GetButtons("settings")[name]:AddImageRail(0, -9, assets.image.ui.settings.indicator)
                self.Ui:GetButtons("settings")[name]:AddImage(0, -4, assets.image.ui.settings.bar)
                self.Ui:GetButtons("settings")[name]:SetElementColourRail({.9,.9,.9},{.7,.9,.7},{.6,.6,.6})

                self.Ui:GetButtons("settings")[name]:AddText(currentSetting.displayName, nil, font1, -f:getWidth(currentSetting.displayName) - 10, -20, 1000)
                self.Ui:GetButtons("settings")[name].func = {sliderFunction, currentSetting}



            elseif currentSetting.type == "toggle" then
                self.Ui:AddToggle(name, currentX, currentHeight, f:getWidth(currentSetting.displayName) + 40, f:getHeight(), currentSetting.value, "settings")

                self.Ui:GetButtons("settings")[name].button1:AddText(currentSetting.displayName, nil, font1, 40, 0, 1000)
                self.Ui:GetButtons("settings")[name].button1:AddImage(0, 9, assets.image.ui.settings.check)
                self.Ui:GetButtons("settings")[name].button1:SetElementColour({1,1,1}, {0.9,0.9,0.9}, {0.8,0.8,0.8})

                self.Ui:GetButtons("settings")[name].button2:AddText(currentSetting.displayName, nil, font1, 40, 0, 1000)
                self.Ui:GetButtons("settings")[name].button2:AddImage(0, 9, assets.image.ui.settings.empty)
                self.Ui:GetButtons("settings")[name].button2:SetElementColour({1,1,1}, {0.9,0.9,0.9}, {0.8,0.8,0.8})



                self.Ui:GetButtons("settings")[name].func = {currentSetting.func or toggleFunction, currentSetting}

            elseif currentSetting.type == "header" then
                self.Ui:AddTextButton(name, currentSetting.displayName, nil, font.getFont(font2), currentX, currentHeight + 10, 400, {{1,1,1}}, "settings")

                currentHeight = currentHeight + font.getFont(font2):getHeight() - f:getHeight() + 10
            end

            currentHeight = currentHeight + f:getHeight()
        end
    end
end
function SettingsMenu.Close(self)
    saveSettings()
    self.isOpen = false 
end

function SettingsMenu:KeyRelased(key)
    if key == "escape" and not changingKeybind[1]  then

        self.isOpen = false 

    else
        settings.keybinds[changingKeybind[2]].value[changingKeybind[3]] = key
        self.Ui:GetButtons("settings")[changingKeybind[2] .. changingKeybind[3]].graphics[1].text = "[" .. key .. "]"

        if key == "\\" then
            settings.keybinds[changingKeybind[2]].value[changingKeybind[3]] = "\\\\"
            self.Ui:GetButtons("settings")[changingKeybind[2] .. changingKeybind[3]].graphics[1].text = "[\\]s"
        end

        changingKeybind[1] = false
    end
end

function SettingsMenu:Click(x, y)
    if not changingKeybind[1] then
        self.Ui:Click(x - 960, y - 540)
        self.Ui:Click(x - 960, y - 540, "settings")
    else
        changingKeybind[1] = false
    end
end

function SettingsMenu:Release(x, y)
    self.Ui:Release(x - 960, y - 540)
    self.Ui:Release(x - 960, y - 540, "settings")

end

function SettingsMenu:Update(dt, x, y)
    if not changingKeybind[1] then
        self.Ui:Update(dt, x - 960, y - 540)
        self.Ui:Update(dt, x - 960, y - 540, "settings")
    end
end


--Colours: lightwood 743f30, darkwood 45261b
function SettingsMenu:Draw(gs, dark)
    love.graphics.reset()

    if not dark then
        love.graphics.setColor(0,0,0,0.5*gs)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end


    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
    love.graphics.translate(sox, soy + 1500*(1-gs))

    --this looks quite wierd otherwise
    love.graphics.setColor(0,0,0,1)

    love.graphics.rectangle("fill", -width/2, -height/2-5, width, 100, 25)

    --Draw a basic outline
    love.graphics.setColor(quindoc.hexcode("743f30"))
    love.graphics.rectangle("fill", -width/2, -height/2 + y, width, height, 25)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", -width/2, -height/2 + y, width, height, 25)

    local xSize = width - 100
    xSize = xSize/#self.catagories

    for i = 1,#self.catagories do

        if i == self.curentCatagroy then
            love.graphics.setColor(quindoc.hexcode("743f30"))
            love.graphics.rectangle("fill", -width/2 + (i-1)*xSize, -height/2, xSize, 100, 25)

           love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2 - (height/2 - 75)*screenScale)
           --love.graphics.setColor(1,0,0,0.5)
           --love.graphics.rectangle("fill", -2000, -2000, 5000, 5000)
        else
            love.graphics.setColor(quindoc.hexcode("45261b"))

            love.graphics.rectangle("fill", -width/2 + (i-1)*xSize, -height/2, xSize, 100, 25)
    
        end


        love.graphics.setColor(0,0,0,1)

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

    --screws
    local offSet = 25
    local extraYOffset = 50

    love.graphics.setColor(1,1,1,1)

    drawScrew(-width/2+offSet,height/2-offSet+extraYOffset,0)
    drawScrew(-width/2+offSet,-height/2+offSet+2*extraYOffset,0.5*math.pi)
    drawScrew(width/2-offSet,height/2-offSet+extraYOffset,0.5*math.pi)
    drawScrew(width/2-offSet,-height/2+offSet+2*extraYOffset,0)


    --Draw the close button here to hide graphical isues
    love.graphics.setColor(.8,0,0,1)--temporary only
    love.graphics.rectangle("fill", width/2 - 100, -height/2, 100, 100, 25)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("line", width/2 - 100, -height/2, 100, 100, 25)

    love.graphics.setLineWidth(1)
    self.Ui:Draw()
    self.Ui:Draw("settings", 0, self.scroll)
end

--idk where to put this so i trust you to fix it in the clean-up >:)
menuScrew = love.graphics.newImage("image/ui/settings/screw.png")

function drawScrew(x,y,a)  
    love.graphics.draw(menuScrew,x,y,a,1,1,11,11)
end
--idk where to put this so i trust you to fix it in the clean-up >:)