local width = 500
local height = 400

local font1 = {"medium", 50}
local font2 = {"black", 75}


PauseMenu = {}
PauseMenu.__index = PauseMenu

function PauseMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, PauseMenu)

    obj.isOpen = false
    obj.hasOpend = false
    obj.scroll = 0

    obj.settingsTimer = 0


    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    return obj
end

function PauseMenu.Close(self)
    self.isOpen = false 
    love.mouse.setVisible(false)
end

function PauseMenu.RestartGame(self)
    player.health = 0
    self.isOpen = false
    self.hasOpend = false
    --game[gameState].unload()
    previousGameState = "GetWreked"
end

function PauseMenu.Settings(self)
    settingsMenu.isOpen = true
end

function PauseMenu.exit(self)
    -- UPDATE THIS LATER
    player.health = 0
    gameState = "levelSelect"
end

function PauseMenu:GenerateButtons()
    local colours = {
        {0,0,0},
        {0,0,0.3},
        {0.2,0.2,0.4},
    }
    self.Ui:AddTextButton("continue", "Continue", "center", font1, 0, -height/2 + 92, width, colours)
    self.Ui:AddTextButton("restart", "Restart", "center", font1, 0, -height/2 + 92 + 75, width, colours)
    self.Ui:AddTextButton("settings", "Settings", "center", font1, 0, -height/2 + 92 + 150, width, colours)
    self.Ui:AddTextButton("exit", "Exit", "center", font1, 0, -height/2 + 92 + 225, width, colours)

    self.Ui:GetButtons()["continue"].functions.release = {PauseMenu.Close, self}
    self.Ui:GetButtons()["restart"].functions.release = {PauseMenu.RestartGame, self}
    self.Ui:GetButtons()["settings"].functions.release = {PauseMenu.Settings, self}
    self.Ui:GetButtons()["exit"].functions.release = {PauseMenu.exit, self}
end



function PauseMenu:KeyRelased(key)
    if key == "escape" then
        self.isOpen = false 
    end
end

function PauseMenu:Click(x, y)
    self.Ui:Click(x - 960, y - 540)
end

function PauseMenu:Release(x, y)
    self.Ui:Release(x - 960, y - 540)
end

function PauseMenu:Update(dt, x, y)
    self.Ui:Update(dt, x - 960, y - 540)
    if settingsMenu.isOpen then

        self.settingsTimer = math.min(self.settingsTimer + dt*2, 1)
    else 

        self.settingsTimer = math.max(self.settingsTimer - dt*2, 0)
    end
end

--Colours: darkwood 45261b, lightwood 743f30

function PauseMenu:Draw(gs)
    if self.hasOpend then
        love.graphics.reset()

        love.graphics.setColor(0,0,0,0.5*gs)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- scaling
        love.graphics.scale(screenScale)
        local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
        local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
        love.graphics.translate(sox, soy + 1500*(1-gs))


        love.graphics.setColor(quindoc.hexcode("743f30")) 
        love.graphics.rectangle("fill", -width/2, -height/2, width, height, 25)

        love.graphics.setColor(0,0,0,1)
        love.graphics.setLineWidth(10)
        love.graphics.rectangle("line", -width/2, -height/2, width, height, 25)

        
        font.setFont(font2)
        love.graphics.printf("Paused", -width/2, -height/2, width, "center")

        love.graphics.setColor(1,1,1)

        local offSet = 25

        -- screws :(
        drawScrew(-width/2+offSet,height/2-offSet,0)
        drawScrew(-width/2+offSet,-height/2+offSet,0.5*math.pi)
        drawScrew(width/2-offSet,height/2-offSet,0.5*math.pi)
        drawScrew(width/2-offSet,-height/2+offSet,0)

        love.graphics.setLineWidth(1)
        self.Ui:Draw()
    end
end

