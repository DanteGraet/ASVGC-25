local width = 700
local height = 600

local font1 = {"medium", 50}
local font2 = {"black", 75}


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
    --game[gameState].unload()
    previousGameState = "GetWreked"
end

function GameOverMenu.exit(self)
    -- UPDATE THIS LATER
    gameState = "levelSelect"
end

function GameOverMenu:GenerateButtons()
    local colours = {
        {0,0,0},
        {0,0,0.3},
        {0.2,0.2,0.4},
    }

    if player and player.health > 0 then
        self.Ui:AddTextButton("restart", "Play Again", "center", font1, -width/4, height/2 - 75, width, colours)
    else
        self.Ui:AddTextButton("restart", "Retry", "center", font1, -width/4, height/2 - 75, width, colours)
    end
    self.Ui:AddTextButton("exit", "Exit", "center", font1, width/4, height/2 - 75, width, colours)

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

    -- a background that fills the screen
    love.graphics.setColor(0,0,0,0.5*gs)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- scaling and offsets
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


    font.setFont(font2)
    if player.health <=0 then
        love.graphics.printf("Game Over", -width/2, -height/2, width, "center")
    else
        love.graphics.printf("You Win!", -width/2, -height/2, width, "center")
    end


    if savedDisplayName then
        font.setFont("medium", 50)
        love.graphics.printf("Biome:", -width/2, -height/2 + 240, width/2, "center")

        font.setFont("medium", 28)
        love.graphics.printf(savedDisplayName,-width/2,-height/2 + 300,width/2,"center")
    end


    font.setFont("medium", 50)
    love.graphics.printf("Score:", -width/2, -height/2 + 100, width/2, "center")

    font.setFont("medium", 40)
    love.graphics.printf("High Scores:", 20, -height/2 + 115, width/2 - 40, "center")

    local displayNum
    if settings.graphics.shortNumbers.value then
        displayNum = dante.formatNnumber(math.floor(math.abs(player.score)), 2)
    else
        displayNum = math.floor(math.abs(player.score))
    end
    love.graphics.printf(displayNum, -width/2, -height/2 + 160, width/2, "center")
    
    -- white is there so if the player gets the same score (unlikely like very unlikey) then there will only on white score
    local white = false
    if assets.save.highscore then
        if not assets.save.highscore[riverName] then
            assets.save.highscore[riverName] = {}
        end
    else
        assets.save.highscore = {riverName = {}}
    end
    for i = 1,#assets.save.highscore[riverName] do
        local pref = ""
        local suf = ""
        if assets.save.highscore[riverName][i] == player.score and not white then
            love.graphics.setColor(0.1,0.1,0.1)
            white = true

            pref = ">"
            suf = "<"
        else
            love.graphics.setColor(0,0,0)   
        end

        local displayNum
        if settings.graphics.shortNumbers.value then
            displayNum = dante.formatNnumber(math.floor(math.abs(assets.save.highscore[riverName][i])), 2)
        else
            displayNum = math.floor(math.abs(assets.save.highscore[riverName][i]))
        end

        love.graphics.printf(pref .. displayNum --[[.."m"]] .. suf, 20, -height/2 + 105 + i*55, width/2 - 40, "center")
    end

    local offSet = 25

    love.graphics.setColor(1,1,1,1)

    -- add screws last
    drawScrew(-width/2+offSet,height/2-offSet,0)
    drawScrew(-width/2+offSet,-height/2+offSet,0.5*math.pi)
    drawScrew(width/2-offSet,height/2-offSet,0.5*math.pi)
    drawScrew(width/2-offSet,-height/2+offSet,0)


    love.graphics.setLineWidth(1)
    self.Ui:Draw()
end