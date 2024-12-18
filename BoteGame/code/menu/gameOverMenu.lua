local width = 700
local height = 600

local font3 = love.graphics.newFont(40)
local font1 = love.graphics.newFont(50)
local font2 = love.graphics.newFont(75)


GameOverMenu = {}
GameOverMenu.__index = GameOverMenu



function GameOverMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, GameOverMenu)

    obj.isOpen = false
    obj.scroll = 0

    obj.settingsTimer = 0


    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    return obj
end

function GameOverMenu.RestartGame(self)
    self.isOpen = false
    previousGameState = "GetWreked"
end

function GameOverMenu.exit(self)
    -- UPDATE THIS LATER
    gameState = "titleScreen"
end

function GameOverMenu:GenerateButtons()
    --[[
        continue
        restart
        settings
        menu
    ]]
    local colours = {
        {1,1,1},
        {0.9,0.9,0.8},
        {.7,.7,.5}
    }

    self.Ui:AddTextButton("restart", "Retry", "center", font1, -width/4, height/2 - 75, width, colours)
    self.Ui:AddTextButton("exit", "Continue", "center", font1, width/4, height/2 - 75, width, colours)

    self.Ui:GetButtons()["restart"].functions.release = {GameOverMenu.RestartGame, self}
    self.Ui:GetButtons()["exit"].functions.release = {GameOverMenu.exit, self}
end


function GameOverMenu:KeyRelased(key)
    if key == "escape" then
        self.isOpen = false 
    end
end


function GameOverMenu:Click(x, y)
    self.Ui:Click(x - 960, y - 540)
end

function GameOverMenu:Release(x, y)
    self.Ui:Release(x - 960, y - 540)
end


function GameOverMenu:Update(dt, x, y)
    self.Ui:Update(dt, x - 960, y - 540)

    if settingsMenu.isOpen then

        self.settingsTimer = math.min(self.settingsTimer + dt*2, 1)
    else 

        self.settingsTimer = math.max(self.settingsTimer - dt*2, 0)
    end
end


function GameOverMenu:Draw(gs)
    love.graphics.reset()

    love.graphics.setColor(0,0,0,0.5*gs)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
    love.graphics.translate(sox, soy + 1500*(1-gs))

    --Draw a basic outline
    love.graphics.setColor(0.8,0.7,1,1)
    love.graphics.rectangle("fill", -width/2, -height/2, width, height, 25)

    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", -width/2, -height/2, width, height, 25)

    -- line for the high scores
    love.graphics.rectangle("line", 20, -height/2 + 100, width/2-40, height-200, 25)


    love.graphics.setFont(font2)
    love.graphics.printf("Game Over", -width/2, -height/2, width, "center")

    love.graphics.setFont(font1)
    love.graphics.printf("Score:", -width/2, -height/2 + 100, width/2, "center")

    love.graphics.setFont(font3)
    love.graphics.printf("High Scores:", 20, -height/2 + 115, width/2 - 40, "center")

    print(player.y)
    love.graphics.printf(dante.formatNnumber(math.floor(math.abs(player.y)), 2), -width/2, -height/2 + 150, width/2, "center")




    love.graphics.setLineWidth(1)
    self.Ui:Draw()
end