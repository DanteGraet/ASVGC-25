local settingsMenu = {}
local data = {}

local width = 1000
local height = 700

local changingKeybind = {false}

settingsMenu.width = width
settingsMenu.height = height
settingsMenu.transitionIn = 0

settingsMenu.ui = graetUI:newUI()

local function checkToggleSettings()
    love.window.setFullscreen(settings.graphics.fullscreen.value)
end

local buttonTypeFunctions = {
    button = function(settingName, setting, currentFont)
        return {
            components = {
                {
                    type = "rectangleCollider",
                    x = 0,
                    y = 0,
                    sx = currentFont:getWidth(setting.displayName),
                    sy = currentFont:getHeight(),
                },
                {
                    type = "textGraphic",
                    text = setting.displayName,
                    font = currentFont,

                    x = 0,
                    y = 0,
                    colour = {1,1,1},
                },
            },
            data = {
                onRelease = function(obj, button)
                    setting.func()
                    --gameStateManager.setGameState("responsiveLoading", false, "levelSelect", "image/loading/title.png")
                end,
            }
        }
    end,
    keybindButton = function(settingName, setting, currentFont)
        return {
            components = {
                {
                    type = "textGraphic",
                    text = setting.displayName,
                    font = currentFont,

                    x = 0,
                    y = 0,
                    colour = {1,1,1},
                },
            },
            data = {
            }
        }
    end,
    slider = function(settingName, setting, currentFont)
        local buttonX = setting.value * (250-25)
        local initialX = currentFont:getWidth(setting.displayName) + 25
        local maxWidth = currentFont:getWidth(setting.displayName) + 25 + 250-25
        return {
            components = {
                {
                    type = "rectangleCollider",
                    x =  initialX + buttonX,
                    y = 5,
                    sx = 25,
                    sy = currentFont:getHeight()-10,
                },
                {
                    type = "rectangleCollider",
                    x = currentFont:getWidth(setting.displayName) + 25,
                    y = 10,
                    sx = 250,
                    sy = currentFont:getHeight()-20,
                },
                {
                    type = "textGraphic",
                    text = setting.displayName,
                    font = currentFont,

                    x = 0,
                    y = 0,
                    colour = {1,1,1},
                },
                {
                    type = "imageGraphic",
                    x = initialX,
                    y = 12,
                    image = assets.image.ui.settings.bar
                },
                {
                    type = "imageGraphic",
                    x = initialX + buttonX,
                    y = 6,
                    image = assets.image.ui.settings.indicator
                },
            },
            data = {
                initialX = currentFont:getWidth(setting.displayName) + 25,
                ox = 0,
                onClick = function(component, button, mx, my)
                    if component.sx == 25 then
                        button.ox = mx - component.x - 25/2
                    else
                        button.components[1].x = quindoc.clamp(mx-25/2, button.initialX, maxWidth)
                        button.ox = 0
                    end
                end,
                update = function(button)
                    if button.mouseState == "clicked" then
                        local hoverdButton
                        local hoverdComponent
                        local ox, oy 

                        local mx, my = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), "Menu")
                        if not mx or not my then return end

                        local targetWidth, targetHeight, offsetX, offsetY = screen.getScaledSize("Menu")

                        local anchorX, anchorY = targetWidth * button.anchor[1],  targetHeight * button.anchor[2]
                        local x = mx - anchorX - button.x --+ offsetX

                        button.components[1].x = quindoc.clamp((x-25/2) - button.ox, button.initialX, maxWidth)
                        button.components[5].x = button.components[1].x

                        local newValue = (button.components[1].x - button.initialX)/225
                        setting.value = newValue
                    end
                end
                --[[onRelease = function(obj, button)
                    setting.value = not setting.value

                    button.components[3].image = (setting.value and assets.image.ui.settings.check) or assets.image.ui.settings.empty
                    --gameStateManager.setGameState("responsiveLoading", false, "levelSelect", "image/loading/title.png")
                end,]]
            }
        }
    end,
    toggle = function(settingName, setting, currentFont)
        return {
            components = {
                {
                    type = "rectangleCollider",
                    x = 0,
                    y = 0,
                    sx = currentFont:getWidth(setting.displayName) + 50,
                    sy = currentFont:getHeight(),
                },
                {
                    type = "textGraphic",
                    text = setting.displayName,
                    font = currentFont,

                    x = 50,
                    y = 0,
                    colour = {1,1,1},
                },
                {
                    type = "imageGraphic",
                    x = 10,
                    y = 10,
                    image = (setting.value and assets.image.ui.settings.check) or assets.image.ui.settings.empty
                }
            },
            data = {
                onRelease = function(obj, button)
                    setting.value = not setting.value

                    button.components[3].image = (setting.value and assets.image.ui.settings.check) or assets.image.ui.settings.empty

                    checkToggleSettings()
                    --gameStateManager.setGameState("responsiveLoading", false, "levelSelect", "image/loading/title.png")
                end,
            }
        }
    end,
    header = function(settingName, setting)
        local headerFont = font.getFont("black", 35)
        return {
            components = {
                    {
                        type = "textGraphic",
                        text = setting.displayName,
                        x = 0,
                        y = 0,
                        font = headerFont,
                        colour = {1,1,1},
                    },
                },
                data = {
                }
        }, headerFont:getHeight() + 10
    end,
}

function settingsMenu.loadCatagory(catagory)
    settingsMenu.ui = graetUI:newUI()

    local categoryCount = 0
    for i = 1,#settings.order do
        if settings.order[i].isActive() then
            categoryCount = categoryCount + 1
        end
    end

    local widthPerCategory = (width - 100) / categoryCount
    local buttonFont = font.getFont("black", 40)
    for i = 1,#settings.order do
        if settings.order[i].isActive() then
            -- Spawn a button for this category
            local c = settings.order[i]
            local button = {
                components = {
                    {
                        type = "rectangleCollider",
                        x = 0,
                        y = 0,
                        sx = widthPerCategory,
                        sy = 100,
                    },
                    {
                        type = "textGraphic",
                        text = c.displayName,
                        x = (widthPerCategory - buttonFont:getWidth(c.displayName))/2,
                        y = (100 - buttonFont:getHeight())/2,
                        font = buttonFont,
                        colour = {1,1,1},
                    },
                },
                data = {
                    onRelease = function()
                        settingsMenu.loadCatagory(i)
                    end,
                }
            }

            settingsMenu.ui:addCustomObject(c.category .. "Settings", -width/2 + widthPerCategory*(i-1), -height/2, {0,0}, button)
        end
    end

    local button = {
        components = {
            {
                type = "rectangleCollider",
                x = 0,
                y = 0,
                sx = 100,
                sy = 100,
            },
            {
                type = "textGraphic",
                text = "X",
                x = (100 - buttonFont:getWidth("X"))/2,
                y = (100 - buttonFont:getHeight())/2,
                font = buttonFont,
                colour = {1,1,1},
            },
        },
        data = {
            onRelease = function()
                settingsMenu.startClose()
            end,
        }
    }

    settingsMenu.ui:addCustomObject("close" .. "Settings", -width/2 + widthPerCategory*categoryCount, -height/2, {0,0}, button)

    local currentY = - height/2 + 110
    local currentX = - width/2 + 25
    local currentFont = font.getFont("medium", 30)

    local catagoryToLoad = settings.order[catagory]

    for i = 1,#catagoryToLoad.data do
        local settingName = catagoryToLoad.data[i]
        local setting = settings[catagoryToLoad.category][settingName]

        if setting.type == "keybindButton" then
            for i = 1, 2 do
                local button = buttonTypeFunctions["button"](settingName, setting, currentFont)
                button.components[2].text = "[" .. setting.value[i] .. "]"
                button.components[1].sx = currentFont:getWidth("[" .. setting.value[i] .. "]")

                button.data.onRelease = function()
                    changingKeybind = {true, settingName, i}
                end
                if button.components then
                    settingsMenu.ui:addCustomObject(settingName .. "Setting" .. i, currentX + 200*i + 25, currentY, {0,0}, button)
                end
            end
        end

        local button, heightOffset = buttonTypeFunctions[setting.type](settingName, setting, currentFont)
        if button.components then
            settingsMenu.ui:addCustomObject(settingName .. "Setting", currentX, currentY, {0,0}, button)
        end
        currentY = currentY + (heightOffset or currentFont:getHeight())
    end
end

function settingsMenu.load()
    data = {}
    local bg = {}
    bg.image = love.graphics.newImage("image/nineSliceTest.png")
    bg.x = -width/2
    bg.y = -height/2
    bg.sx = width
    bg.sy = height
    bg.cornerSize = 10

    local nineSlice = graetUI:getComponent("nineSliceGraphic")
    data.background = nineSlice:new(bg.image, bg.x, bg.y, bg.sx, bg.sy, bg.cornerSize)
    data.closing = false
    
    data.yOffset = 0 

    settingsMenu.loadCatagory(1)
end

function settingsMenu.update(dt)
    if data.closing then
        settingsMenu.transitionIn = math.max(settingsMenu.transitionIn - dt*2, 0)
    else
        settingsMenu.transitionIn = math.min(settingsMenu.transitionIn + dt*2, 1) 
    end

    local sine = tweens.sineOut(settingsMenu.transitionIn)
    data.yOffset = 1000 - sine*1000

    if data.closing == true and settingsMenu.transitionIn == 0 then
        settingsMenu.remove = true
    end
end

function settingsMenu.keyreleased(key)
    if changingKeybind[1] then
        if key == "escape" then 
            changingKeybind = {false}
            return true
        end

        settings.keybinds[changingKeybind[2]].value[changingKeybind[3]] = key

        local currentFont = font.getFont("medium", 30)
        local button = settingsMenu.ui:getButton(changingKeybind[2] .. "Setting" .. changingKeybind[3])

        button.components[2].text = "[" .. key .. "]"
        button.components[1].sx = currentFont:getWidth("[" .. key .. "]")

        changingKeybind = {false}

        return true
    end

    if key == "escape" then 
        settingsMenu.startClose()
        return true
    end

    return false
end

function settingsMenu.startClose()
    saveManager.saveSettings()

    data.closing = true
end

function settingsMenu.draw()
    data.background:draw(0, 0 + data.yOffset)
    love.graphics.translate(0, data.yOffset)
end

return settingsMenu
