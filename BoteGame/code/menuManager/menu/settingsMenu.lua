local settingsMenu = {}
local data = {}

local width = 1000
local height = 600

settingsMenu.width = width
settingsMenu.height = height
settingsMenu.transitionIn = 0

settingsMenu.ui = graetUI:newUI()

local buttonTypeFunctions = {
    button = function(settingName, setting)
        return {

        }
    end,
    keybindButton = function(settingName, setting)
        return {

        }
    end,
    slider = function(settingName, setting)
        return {

        }
    end,
    toggle = function(settingName, setting)
        return {

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

        local button, heightOffset = buttonTypeFunctions[setting.type](settingName, setting)
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

function settingsMenu.startClose()
    data.closing = true
end

function settingsMenu.draw()
    data.background:draw(0, 0 + data.yOffset)
end

return settingsMenu
