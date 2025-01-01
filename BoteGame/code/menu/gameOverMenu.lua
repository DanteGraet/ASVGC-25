local width = 700
local height = 600

local font4 = love.graphics.newFont("font/fontMedium.ttf", 28)
local font3 = love.graphics.newFont("font/fontMedium.ttf", 40)
local font1 = love.graphics.newFont("font/fontMedium.ttf", 50)
local font2 = love.graphics.newFont("font/fontBlack.ttf", 75)


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
        {0,0,0},
        {0,0,0.3},
        {0.2,0.2,0.4},
    }

    self.Ui:AddTextButton("restart", "Retry", "center", font1, -width/4, height/2 - 75, width, colours)
    self.Ui:AddTextButton("exit", "Quit", "center", font1, width/4, height/2 - 75, width, colours)

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
    love.graphics.setColor(quindoc.hexcode("743f30"))
    love.graphics.rectangle("fill", -width/2, -height/2, width, height, 25)

    love.graphics.setColor(0,0,0,1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", -width/2, -height/2, width, height, 25)

    -- line for the high scores
    love.graphics.rectangle("line", 20, -height/2 + 100, width/2-40, height-195, 25)


    love.graphics.setFont(font2)
    if player.health <=0 then
        love.graphics.printf("Game Over", -width/2, -height/2, width, "center")
    else
        love.graphics.printf("You Win!", -width/2, -height/2, width, "center")
    end

    if savedDisplayName then

        love.graphics.setFont(font1)
        love.graphics.printf("Biome:", -width/2, -height/2 + 240, width/2, "center")

        love.graphics.setFont(font4)
        love.graphics.printf(savedDisplayName,-width/2,-height/2 + 300,width/2,"center")
    end

    love.graphics.setFont(font1)
    love.graphics.printf("Score:", -width/2, -height/2 + 100, width/2, "center")

    love.graphics.setFont(font3)
    love.graphics.printf("High Scores:", 20, -height/2 + 115, width/2 - 40, "center")

    love.graphics.printf(dante.formatNnumber(math.floor(math.abs(player.score)), 2).."m", -width/2, -height/2 + 160, width/2, "center")
    
    -- white is there so if the player gets the same score (unlikely like very unlikey) then there will only on white score
    local white = false
    for i = 1,#assets.save.highscore do
        local pref = ""
        local suf = ""
        if assets.save.highscore[i] == player.score and not white then
            love.graphics.setColor(0.1,0.1,0.1)
            white = true
        else
            love.graphics.setColor(0,0,0)
                
        end
        love.graphics.printf(pref .. dante.formatNnumber(math.floor(math.abs(assets.save.highscore[i])), 2).."m" .. suf, 20, -height/2 + 105 + i*55, width/2 - 40, "center")
    end

    local offSet = 25

    love.graphics.setColor(1,1,1,1)

    drawScrew(-width/2+offSet,height/2-offSet,0)
    drawScrew(-width/2+offSet,-height/2+offSet,0.5*math.pi)
    drawScrew(width/2-offSet,height/2-offSet,0.5*math.pi)
    drawScrew(width/2-offSet,-height/2+offSet,0)


    love.graphics.setLineWidth(1)
    self.Ui:Draw()
end