local width = 500
local height = 400

local font1 = love.graphics.newFont(50)
local font2 = love.graphics.newFont(75)


PauseMenu = {}
PauseMenu.__index = PauseMenu



function PauseMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, PauseMenu)

    obj.isOpen = false
    obj.scroll = 0

    obj.settingsTimer = 0


    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    return obj
end

function PauseMenu.Close(self)
    self.isOpen = false 
end

function PauseMenu.RestartGame(self)
    self.isOpen = false
    previousGameState = "GetWreked"
end

function PauseMenu.Settings(self)
    settingsMenu.isOpen = true
end

function PauseMenu.exit(self)
    -- UPDATE THIS LATER
    gameState = "titleScreen"
end

function PauseMenu:GenerateButtons()
    --[[
        continue
        restart
        settings
        menu
    ]]
    local colours = {
        {0,0,0},
        {0,0,0.3},
        {0.2,0.2,0.4},
    }
    self.Ui:AddTextButton("continue", "Continue", "center", font1, 0, -height/2 + 100, width, colours)
    self.Ui:AddTextButton("restart", "Restart", "center", font1, 0, -height/2 + 100 + 75, width, colours)
    self.Ui:AddTextButton("settings", "Settings", "center", font1, 0, -height/2 + 100 + 150, width, colours)
    self.Ui:AddTextButton("exit", "Quit to Menu", "center", font1, 0, -height/2 + 100 + 225, width, colours)

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
    love.graphics.reset()

    love.graphics.setColor(0,0,0,0.5*gs)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.scale(screenScale)

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
    love.graphics.translate(sox, soy + 1500*(1-gs))

    --Draw a basic outline
   -- love.graphics.setColor(quindoc.hexcode("45261b")) 
    --love.graphics.rectangle("fill", -width/2, -height/2, width, height, 25)

    love.graphics.setColor(quindoc.hexcode("743f30")) 
    love.graphics.rectangle("fill", -width/2, -height/2, width, height, 25)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", -width/2, -height/2, width, height, 25)

    
    love.graphics.setFont(font2)
    love.graphics.printf("Paused", -width/2, -height/2, width, "center")

    love.graphics.setColor(1,1,1)

    local offSet = 25

    drawScrew(-width/2+offSet,height/2-offSet,0)
    drawScrew(-width/2+offSet,-height/2+offSet,0.5*math.pi)
    drawScrew(width/2-offSet,height/2-offSet,0.5*math.pi)
    drawScrew(width/2-offSet,-height/2+offSet,0)

    love.graphics.setLineWidth(1)
    self.Ui:Draw()
end

