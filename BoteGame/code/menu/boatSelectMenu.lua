local width = 625
local height = 500

local font1 = love.graphics.newFont("font/fontMedium.ttf", 50)
local font2 = love.graphics.newFont("font/fontBlack.ttf", 75)

local BoatSelectMenu = {}
BoatSelectMenu.__index = BoatSelectMenu

function setSelectedShip(path)
    selectedBoat = path
end

function BoatSelectMenu:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, BoatSelectMenu)

    obj.isOpen = false
    obj.scroll = 0

    obj.Ui = GraetUi:New()

    obj:GenerateButtons()

    return obj
end

function BoatSelectMenu.Close(self)
    self.isOpen = false 
end


function BoatSelectMenu:GenerateButtons()
    local colours = {
        {0,0,0},
        {0,0,0.3},
        {0.2,0.2,0.4},
    }

    self.Ui:AddTextButton("exit", "close", "center", font1, 0, height/2 - 90, width, colours)
    self.Ui:GetButtons()["exit"].functions.release = {BoatSelectMenu.Close, self}

--    dante.printTable(assets.code.player.playerData.data)

    for i = 1, 6 do

        for j = 1,4 do

            self.Ui:AddButton("boat" .. i .. j, i*100 - 400 + 25/2, j*100 - 325, 75, 75)

            self.Ui:GetButtons()["boat" .. i .. j]:AddImage(0, 0, assets.code.player.playerData.data[i][j].skin, 2, 2)
            self.Ui:GetButtons()["boat" .. i .. j]:SetElementColour({1,1,1}, {.8,.8,.8}, {.9,.9,.9})


            self.Ui:GetButtons()["boat" .. i .. j].functions.release = {setSelectedShip, {i, j}}
        end
    end
end



function BoatSelectMenu:KeyRelased(key)
    if key == "escape" then
        self.isOpen = false 
    end
end

function BoatSelectMenu:Click(x, y)
    self.Ui:Click(x - 960, y - 540)
end

function BoatSelectMenu:Release(x, y)
    self.Ui:Release(x - 960, y - 540)
end

function BoatSelectMenu:Update(dt, x, y)
    self.Ui:Update(dt, x - 960, y - 540)
end

--Colours: darkwood 45261b, lightwood 743f30

function BoatSelectMenu:Draw(gs)
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

    --[[
    love.graphics.setFont(font2)
    love.graphics.printf("Bote", -width/2, -height/2, width, "center")
]]
    love.graphics.setColor(1,1,1)

    local offSet = 25

    -- screws :(
    drawScrew(-width/2+offSet,height/2-offSet,0)
    drawScrew(-width/2+offSet,-height/2+offSet,0.5*math.pi)
    drawScrew(width/2-offSet,height/2-offSet,0.5*math.pi)
    drawScrew(width/2-offSet,-height/2+offSet,0)

    love.graphics.setLineWidth(1)


    for i = 1, 6 do 
        for j = 1,4 do
            love.graphics.setColor(.4,.2,.1)

            if i == selectedBoat[1] and j == selectedBoat[2] then
                love.graphics.setColor(.7,.5,.3)
            end

            love.graphics.rectangle("fill", i*100 - 400 + 25/2, j*100 - 325, 75, 75, 25)

        end
    end

    self.Ui:Draw()

end

return BoatSelectMenu