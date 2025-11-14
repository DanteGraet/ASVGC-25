local pauseMenu = {}
local data = {}

local width = 450
local height = 500

pauseMenu.width = width
pauseMenu.height = height
pauseMenu.transitionIn = 0

pauseMenu.ui = graetUI:newUI()

local function getButton(text, func, ...)
    local currentFont = font.getFont("medium", 50)
    local width = currentFont:getWidth(text)
    local height = currentFont:getHeight(text)
    local button = {
        components = {
            {
                type = "rectangleCollider",
                x = -width/2,
                y = 0,
                sx = currentFont:getWidth(text),
                sy = currentFont:getHeight(),
            },
            {
                type = "textGraphic",
                text = text,
                font = currentFont,

                x = -width/2,
                y = 0,
                colour = {1,1,1},
            },
        },
        data = {
            onRelease = function(obj, button)
                func()
            end,
        }
    }

    return button
end


function pauseMenu.load()
    data = {}
    local bg = {}
    bg.image = love.graphics.newImage("image/nineSliceTest.png")
    bg.x = -width/2
    bg.y = -height/2
    bg.sx = width
    bg.sy = height
    bg.cornerSize = 84

    local nineSlice = graetUI:getComponent("nineSliceGraphic")
    data.background = nineSlice:new(bg.image, bg.x, bg.y, bg.sx, bg.sy, bg.cornerSize)
    data.closing = false
    
    data.yOffset = 0 

    local b = getButton("Continue", pauseMenu.startClose)
    pauseMenu.ui:addCustomObject("continue", 0, -200+92, {0,0},      getButton("Continue", pauseMenu.startClose))
    pauseMenu.ui:addCustomObject("restart", 0, -200+92+75, {0,0},       getButton("Restart",  function() gameStateManager.setGameState("responsiveLoading", nil, "river") end))
    pauseMenu.ui:addCustomObject("settings", 0, -200+92+150, {0,0},      getButton("Settings",  function() menuManager.openMenu("settingsMenu") end))
    pauseMenu.ui:addCustomObject("exit", 0, -200+92+225, {0,0},          getButton("Exit",  function() player.health = 0; gameStateManager.setGameState("responsiveLoading", nil, "levelSelect") end))



   -- self.Ui:AddTextButton("continue", "Continue", "center", font1, 0, -height/2 + 92, width, colours)
   -- self.Ui:AddTextButton("restart", "Restart", "center", font1, 0, -height/2 + 92 + 75, width, colours)
   -- self.Ui:AddTextButton("settings", "Settings", "center", font1, 0, -height/2 + 92 + 150, width, colours)
   -- self.Ui:AddTextButton("exit", "Exit", "center", font1, 0, -height/2 + 92 + 225, width, colours)
end

function pauseMenu.update(dt)
    if data.closing then
        pauseMenu.transitionIn = math.max(pauseMenu.transitionIn - dt*2, 0)
    else
        pauseMenu.transitionIn = math.min(pauseMenu.transitionIn + dt*2, 1) 
    end

    local sine = tweens.sineOut(pauseMenu.transitionIn)
    data.yOffset = 1000 - sine*1000

    if data.closing == true and pauseMenu.transitionIn == 0 then
        pauseMenu.remove = true
    end
end

function pauseMenu.startClose()
    data.closing = true
end

function pauseMenu.draw()
    love.graphics.translate(0, data.yOffset)

    data.background:draw(0, 0)

    font.setFont("black", 75)
    love.graphics.printf("Paused", -width/2, -height/2+40, width, "center")
end

function pauseMenu.keyreleased(key)
    if key == "escape" then 
        pauseMenu.startClose()
    end

    return true
end


return pauseMenu
