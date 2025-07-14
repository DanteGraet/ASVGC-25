local levelMenu = {}
levelMenu.__index = levelMenu


local typeData = {
    frostedChannel = {
        displayName = "Great Valley",
        stage = 1,
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
    },
    autumnGrove = {
        displayName = "Autumn Grove",
        stage = 2,
        yfunc = function(gs)
            return 1500*(gs - 1)
        end,
        extDir = 2,
    },
    derelictDam = {
        displayName = "The Dam",
        stage = 3,
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
    },
    endless = {
        displayName = "Endless",
        stage = "Infinity",       --?
        yfunc = function(gs)
            return 1500*(1-gs)
        end,
        extDir = 1,
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
    self.isOpen = false 
end


function levelMenu:GenerateButtons()
    self.Ui:RemoveAll()
    -- play button
    if self.type ~= "endless" then
        print(riverName)
        self.Ui:AddButton("play", 1920/2 - 128, 1080/2 + 32, 256, 256)
        self.Ui:GetButtons()["play"]:AddImage(0, 0, assets.image.levelSelect.sign.play)
        self.Ui:GetButtons()["play"].functions.release = {function() gameState = "river" end}

        self.Ui:AddButton("playStorm", 1920/2 + 128*1.5, 1080/2 + 32, 256, 256)
        if assets.code.player.unlocks.levels[riverName .. "Storm"] then
            self.Ui:GetButtons()["playStorm"]:AddImage(0, 0, assets.image.levelSelect.sign.storm)
            self.Ui:GetButtons()["playStorm"].functions.release = {function() riverName = riverName .. "Storm"; gameState = "river" end}
        else
            self.Ui:GetButtons()["playStorm"]:AddImage(0, 0, assets.image.levelSelect.sign.lock)
        end

        -- back button
        self.Ui:AddButton("back", 1920/2 - 128*3.5, 1080/2  + 32, 256, 256)
        self.Ui:GetButtons()["back"]:AddImage(0, 0, assets.image.levelSelect.sign.back)
        self.Ui:GetButtons()["back"].functions.release = {levelMenu.Close, self}
    else
        self.Ui:AddButton("play", 1920/2 + 128*0.75, 1080/2 + 32, 256, 256)
        self.Ui:GetButtons()["play"]:AddImage(0, 0, assets.image.levelSelect.sign.play)
        self.Ui:GetButtons()["play"].functions.release = {function() gameState = "river" end}

        -- back button
        self.Ui:AddButton("back", 1920/2 - 128*2.75, 1080/2  + 32, 256, 256)
        self.Ui:GetButtons()["back"]:AddImage(0, 0, assets.image.levelSelect.sign.back)
        self.Ui:GetButtons()["back"].functions.release = {levelMenu.Close, self}
    end
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
    love.graphics.printf("Stage: " .. typeData[self.type].stage, 0, 350 - 64, 1920, "center")

    font.setFont("black", 128)
    love.graphics.printf(typeData[self.type].displayName, 0, 350 - 64, 1920, "center")

    -- Highscore
    font.setFont("black", 64)
    local displayNum = 0
    if assets.save.highscore[riverName] and assets.save.highscore[riverName][1] then
        if settings.graphics.shortNumbers.value then
            displayNum = dante.formatNnumber(math.floor(math.abs(assets.save.highscore[riverName][1] or 0)), 2)
        else
            displayNum = math.floor(math.abs(assets.save.highscore[riverName][1] or 0))
        end
        love.graphics.printf("" .. displayNum, 1920/2 - 128*2, 350+128, 128*4, "center")
    end

        --👑 is temporary, trust me
    --love.graphics.printf("👑" .. displayNum, 1920/2, 1080/2 + 50, 128*5, "center")
    

    if assets.save.highscore[riverName .. "Storm"] and assets.save.highscore[riverName .. "Storm"][1] then
        if settings.graphics.shortNumbers.value then
            displayNum = dante.formatNnumber(math.floor(math.abs(assets.save.highscore[riverName .. "Storm"][1] or 0)), 2)
        else
            displayNum = math.floor(math.abs(assets.save.highscore[riverName .. "Storm"][1] or 0))
        end

        love.graphics.printf("" .. displayNum, 1920/2, 350+128, 128*5, "center")
    end
    


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
    local image = assets.image.levelSelect.sign[self.type .. "Ext"]

    local extraHeight = math.ceil((soy-540)/(image:getHeight() - 10))
    for i = 1, extraHeight do
        local h = image:getHeight() - 10
        if typeData[self.type].extDir == 1 then
            love.graphics.draw(image, -1920/2, 1080/2 + (i-1)*h )
        elseif typeData[self.type].extDir == 2 then
            love.graphics.draw(image, -1920/2, -1080/2 - (i)*h + 10)
        end
    end

end

return levelMenu