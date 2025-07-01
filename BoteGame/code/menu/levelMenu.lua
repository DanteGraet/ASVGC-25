local levelMenu = {}
levelMenu.__index = levelMenu


local typeData = {
    frostedChannel = {
        displayName = "Frosted Channel",
        stage = 1,
        yfunc = function(gs)
            return 1500*(1-gs)
        end
    },
    autumnGrove = {
        displayName = "Autumn Grove",
        stage = 2,
        yfunc = function(gs)
            return 1500*(gs - 1)
        end
    },
    derelictDam = {
        displayName = "Derilect Dam",
        stage = 3,
        yfunc = function(gs)
            return 1500*(1-gs)
        end
    },
    endless = {
        displayName = "Endless",
        stage = 0,       --?
        yfunc = function(gs)
            return 1500*(1-gs)
        end
    },
}

function levelMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, levelMenu)

    obj.isOpen = false
    obj.type = ""
    obj.scroll = 0

    obj.Ui = GraetUi:New()

    obj.canvas = love.graphics.newCanvas(1920, 1080)

    obj:GenerateButtons()

    return obj
end

function levelMenu.Close(self)
    print("ahhh")
    self.isOpen = false 
end


function levelMenu:GenerateButtons()
    -- play button
    self.Ui:AddButton("play", 1920/2 - 128, 1080/2, 256, 256)
    self.Ui:GetButtons()["play"]:AddImage(0, 0, assets.image.levelSelect.sign.button1)
    self.Ui:GetButtons()["play"].functions.release = {function() gameState = "river" end}

    -- back button
    self.Ui:AddButton("back", 1920/2 - 128*3.5, 1080/2, 256, 256)
    self.Ui:GetButtons()["back"]:AddImage(0, 0, assets.image.levelSelect.sign.button1)
    self.Ui:GetButtons()["back"].functions.release = {levelMenu.Close, self}
end

function levelMenu:KeyRelased(key)
end

function levelMenu:Click(x, y)
    self.Ui:Click(x, y)
end

function levelMenu:Release(x, y)
    self.Ui:Release(x, y)
end

function levelMenu:Update(dt, x, y)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    self.Ui:Update(dt, x - sox, y - soy)
end


function levelMenu:Draw(gs)

    love.graphics.reset()
    -- Canvas fixed "odd" transparancy issues
    love.graphics.setCanvas(self.canvas)

    love.graphics.clear()

    love.graphics.draw(assets.image.levelSelect.sign[self.type])

            -- prehapse chaneg form pure balck later
    love.graphics.setColor(0.1,0.1,0.2, 0.9)
    font.setFont("black", 32)
    love.graphics.printf("Stage: " .. typeData[self.type].stage, 0, 350, 1920, "center")

    font.setFont("black", 128)
    love.graphics.printf(typeData[self.type].displayName, 0, 350, 1920, "center")

    -- Highscore
    local displayNum
    if settings.graphics.shortNumbers.value then
        displayNum = dante.formatNnumber(math.floor(math.abs(assets.save.highscore[riverName][1])), 2)
    else
        displayNum = math.floor(math.abs(assets.save.highscore[riverName][1]))
    end
    font.setFont("black", 64)
        --👑 is temporary, trust me
    love.graphics.printf("👑" .. displayNum, 1920/2, 1080/2 + 50, 128*5, "center")

    self.Ui:Draw()
    --Ok back to normal
    love.graphics.setCanvas()


    -- darken background
    love.graphics.setColor(0,0,0,0.5*gs)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- scaling
    love.graphics.scale(screenScale)
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2 + 960
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2 + 540
    love.graphics.translate(sox, soy + typeData[self.type].yfunc(gs))



    love.graphics.setColor(1,1,1, gs*5)
    love.graphics.draw(self.canvas, -1920/2, -1080/2)
        -- Draw extentions for poles/beams of qhatever later tm
    

end

return levelMenu