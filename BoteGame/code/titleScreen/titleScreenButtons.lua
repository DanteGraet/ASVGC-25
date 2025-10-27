local tsb = {}
local fontBlack72 = love.graphics.newFont("font/fontBlack.ttf",100)--get trolled

function tsb.CreateButtons(UI)
    local width = love.graphics.getWidth()/screenScale

    local f = font.getFont({"black", 100})
    print(f:getHeight())
    --Font is temporary i hope.
    UI:AddTextButton("quitButton",      "Quit",     "center",    {"black", 100}, width*0.3 - 2.5, 30+490 + f:getHeight()*2.5, 1920,   {{1,1,1}, {1, 0.6, 0.6}, {1, 0.4, 0.4}})
    UI:AddTextButton("settingsButton",  "Settings", "center",    {"black", 100}, width*0.3 - 2.5, 30+490 + f:getHeight()*0.5,   1920,   {{1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45}})
    UI:AddTextButton("playButton",      "Play",     "center",    {"black", 100}, width*0.3 - 2.5, 30+490 + f:getHeight()*-0.5, 1920,   {{1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45}})
    UI:AddTextButton("creditButton", "Credits",     "center",    {"black", 100}, width*0.3 - 2.5, 30+490 + f:getHeight()*1.5, 1920,   {{1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45}})

    --Temporary fix for adding functions to buttons :D
    UI:GetButtons()["quitButton"].functions.release =       {tsb.quitButtonRelease}
    UI:GetButtons()["settingsButton"].functions.release =   {tsb.settingsButtonRelease}
    UI:GetButtons()["playButton"].functions.release =       {tsb.playButtonRelease}
    UI:GetButtons()["creditButton"].functions.release =       {tsb.creditButtonRelease}

    UI:GetButtons()["creditButton"]:AddText("Credits", "center", {"black", 100}, 12 - (870 - 68), 6, 1920, 1)
    UI:GetButtons()["creditButton"]:AddImage(-100- 45/2, 45/2 + 5, love.graphics.newImage("image/titleScreen/titleIco4.png"), 1, 1)
    UI:GetButtons()["creditButton"]:AddImage(-100- 45/2 + 6, 45/2+ 6 + 5, love.graphics.newImage("image/titleScreen/titleIco4.png"), 1, 1, 1)

    UI:GetButtons()["creditButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 1)
    UI:GetButtons()["creditButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 2)
    UI:GetButtons()["creditButton"]:SetElementColour({1,1,1}, nil, nil, 4)
    UI:GetButtons()["creditButton"].functions.hover = {
    function(dt, self)
            if not self.graphics[1].sin then
                self.graphics[1].sin = 0

                -- first time
                self.graphics[1].ox = 50
                self.graphics[4].ox = 50

                self.graphics[1].oy = 50
                self.graphics[4].oy = 50

                self.graphics[1].x = self.graphics[1].x + 50
                self.graphics[4].x = self.graphics[4].x + 50

                self.graphics[1].y = self.graphics[1].y + 50
                self.graphics[4].y = self.graphics[4].y + 50

            end
        end,
        UI:GetButtons()["creditButton"]
    }
    UI:GetButtons()["creditButton"].functions.update = {
        function(dt, self)
            if self.graphics[1].sin then

                if self.mouseMode ~= "none" then
                    self.graphics[1].sin = self.graphics[1].sin + dt*math.pi
                else
                    self.graphics[1].sin = math.min(self.graphics[1].sin + dt*math.pi, math.ceil(self.graphics[1].sin/math.pi)*math.pi)
                end

                self.graphics[1].sy = 1 + math.sin(self.graphics[1].sin)*0.1
                self.graphics[4].sy = 1 + math.sin(self.graphics[1].sin)*0.1

                self.graphics[1].sx = 1 + math.sin(self.graphics[1].sin)*0.1
                self.graphics[4].sx = 1 + math.sin(self.graphics[1].sin)*0.1

            end
        end,

        UI:GetButtons()["creditButton"]
    }


    UI:GetButtons()["quitButton"]:AddText("Quit", "center", {"black", 100}, 12 - 870, 6, 1920, 1)
    UI:GetButtons()["quitButton"]:AddImage(-100- 45/2, 45/2 + 5, love.graphics.newImage("image/titleScreen/titleIco3.png"), 1, 1)
    UI:GetButtons()["quitButton"]:AddImage(-100- 45/2 + 6, 45/2+ 6 + 5, love.graphics.newImage("image/titleScreen/titleIco3.png"), 1, 1, 1)

    UI:GetButtons()["quitButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 1)
    UI:GetButtons()["quitButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 2)
    UI:GetButtons()["quitButton"]:SetElementColour({1,1,1}, nil, nil, 4)
    
    UI:GetButtons()["quitButton"].functions.hover = {
        function(dt, self)
            if not self.graphics[1].timer then
                self.graphics[1].timer = 0
                --25, 25
                self.graphics[1].ox = 25
                self.graphics[1].oy = 25

                self.graphics[4].ox = 25
                self.graphics[4].oy = 25

                self.graphics[1].x = self.graphics[1].x + 25
                self.graphics[1].xStore = self.graphics[1].x
                self.graphics[1].y = self.graphics[1].y + 25
                self.graphics[1].yStore = self.graphics[1].y

                self.graphics[4].x = self.graphics[4].x + 25
                self.graphics[4].y = self.graphics[4].y + 25

                self.graphics[1].r = 0
                self.graphics[4].r = 0

            end
        end,
        UI:GetButtons()["quitButton"]
    }
    UI:GetButtons()["quitButton"].functions.update = {
        function(dt, self)
            if self.graphics[1].timer then
                if self.mouseMode ~= "none" and self.graphics[1].timer >= 0 then
                    self.graphics[1].timer = self.graphics[1].timer + dt/3
                    
                    self.graphics[1].r = 0 + (math.pi*(0.40)*math.sin(self.graphics[1].timer*5))
                    self.graphics[4].r = 0 + (math.pi*(0.40)*math.sin(self.graphics[1].timer*5))

                    self.graphics[1].y = self.graphics[1].yStore + 98*math.pow(math.max(self.graphics[1].timer*5 - 1, 0), 2)
                    self.graphics[4].y = self.graphics[1].yStore + 98*math.pow(math.max(self.graphics[1].timer*5 - 1, 0), 2) - 6

                else
                    -- reset anchor
                    self.graphics[1].r = 0
                    self.graphics[4].r = 0

                    self.graphics[1].y = self.graphics[1].yStore
                    self.graphics[4].y = self.graphics[1].yStore - 6

                    if self.graphics[1].timer <= 0 then
                        self.graphics[1].timer = math.min(self.graphics[1].timer + dt*2, 0)
                    else
                        self.graphics[1].timer = -1
                    end

                    self.graphics[4].colour1[4] = (self.graphics[1].timer + 1)*2
                    self.graphics[4].colour2[4] = (self.graphics[1].timer + 1)*2
                    self.graphics[4].colour3[4] = (self.graphics[1].timer + 1)*2

                    self.graphics[1].colour1[4] = (self.graphics[1].timer + 0.5)
                    self.graphics[1].colour2[4] = (self.graphics[1].timer + 0.5)
                    self.graphics[1].colour3[4] = (self.graphics[1].timer + 0.5)



                end

            end
        end,

        UI:GetButtons()["quitButton"]
    }




    UI:GetButtons()["settingsButton"]:AddText("Settings", "center", {"black", 100}, 12 - 780, 6, 1920, 1)
    UI:GetButtons()["settingsButton"]:AddImage(-100- 45/2, 45/2 + 5, love.graphics.newImage("image/titleScreen/titleIco2.png"), 1, 1)
    UI:GetButtons()["settingsButton"]:AddImage(-100- 45/2 + 6, 45/2+ 6+ 5, love.graphics.newImage("image/titleScreen/titleIco2.png"), 1, 1, 1)

    UI:GetButtons()["settingsButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 1)
    UI:GetButtons()["settingsButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 2)
    -- Big sad code here, no peeking 
    UI:GetButtons()["settingsButton"].functions.hover = {
        function(dt, self)
            if not self.graphics[1].r then
                -- first time
                self.graphics[1].ox = 50
                self.graphics[4].ox = 50

                self.graphics[1].oy = 50
                self.graphics[4].oy = 50

                self.graphics[1].x = self.graphics[1].x + 50
                self.graphics[4].x = self.graphics[4].x + 50

                self.graphics[1].y = self.graphics[1].y + 50
                self.graphics[4].y = self.graphics[4].y + 50
                
                self.graphics[1].speed = 0

                self.graphics[1].r = 0
                self.graphics[4].r = 0
            end
        end,
        UI:GetButtons()["settingsButton"]
    }
    UI:GetButtons()["settingsButton"].functions.update = {
        function(dt, self)
            if self.graphics[1].speed then
                local speed = tweens.sineInOut(self.graphics[1].speed)
                if self.mouseMode ~= "none" then
                    self.graphics[1].speed = math.min(self.graphics[1].speed + dt, 1)
                else
                    self.graphics[1].speed = math.max(self.graphics[1].speed - dt, 0)
                end

                self.graphics[1].r = (self.graphics[1].r or 0) + dt*speed*1.5
                self.graphics[4].r = (self.graphics[1].r or 0 ) + dt*speed*1.5
            end
        end,

        UI:GetButtons()["settingsButton"]
    }
    --UI:GetButtons()["settingsButton"]:SetElementColour({1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45})


    UI:GetButtons()["playButton"]:AddText("Play", "center", {"black", 100}, 12 - 870, 6, 1920, 1)
    UI:GetButtons()["playButton"]:AddImage(-100 - 45/2, 45/2 + 5, love.graphics.newImage("image/titleScreen/titleIco1.png"), 1, 1)
    UI:GetButtons()["playButton"]:AddImage(-100- 45/2 + 6, 45/2+ 6 + 5, love.graphics.newImage("image/titleScreen/titleIco1.png"), 1, 1, 1)

    UI:GetButtons()["playButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 1)
    UI:GetButtons()["playButton"]:SetElementColour({0.0,0.0,0.0, 0.5}, nil, nil, 2)
    --UI:GetButtons()["playButton"]:SetElementColour({1,1,1}, {0.7, 0.7, 0.725}, {0.4, 0.4, 0.45})

    UI:GetButtons()["playButton"].functions.hover = {
        function(dt, self)
            if not self.graphics[1].sin then
                self.graphics[1].sin = 0
            end
        end,
        UI:GetButtons()["playButton"]
    }
    UI:GetButtons()["playButton"].functions.update = {
        function(dt, self)
            if self.graphics[1].sin then

                if self.mouseMode ~= "none" then
                    self.graphics[1].sin = self.graphics[1].sin + dt*math.pi
                else
                    self.graphics[1].sin = math.min(self.graphics[1].sin + dt*math.pi, math.ceil(self.graphics[1].sin/math.pi)*math.pi)
                end

                self.graphics[1].y = 45/2 + 5 + math.sin(self.graphics[1].sin)*10 + 6
                self.graphics[4].y = 45/2 + 5 + math.sin(self.graphics[1].sin)*10

                --self.graphics[4].r = (self.graphics[1].r or 0 ) + dt*speed*1.5
            end
        end,

        UI:GetButtons()["playButton"]
    }

    --bootleg fix
    local function fixButton(name)
        local b = UI:GetButtons()[name]
        local diff = 100 + 45/2
        b.x = b.x - diff
        b.sx = b.sx + diff

        for i = 1,#b.graphics do
            b.graphics[i].x = b.graphics[i].x + diff
        end
    end

    fixButton("quitButton")
    fixButton("settingsButton")
    fixButton("playButton")


    -- these buttons can't be acsessed by normal players.
    if DEV then
        --UI:AddTextButton("devDeleteSaveButton", "Lose the game (save file)", "right", love.graphics.newFont(32), 0, 100, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        UI:AddTextButton("devRiverButton", "Dev River", "right", love.graphics.newFont(32), 0, 200, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        --UI:AddTextButton("devUnlockAllButton", "Unlocak All", "right", love.graphics.newFont(32), 0, 300, 1800, {{1,.5,.5}, {0.8, 0.4, 0.4}, {0.6, 0.2, 0.2}})
        
        UI:GetButtons()["devRiverButton"].functions.release =       {tsb.devRiverButtonRelease}
    end
end


function tsb.quitButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    love.event.quit()
end

function tsb.settingsButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    settingsMenu.SetCatagory({settingsMenu, 1})
    settingsMenu.isOpen = true
end

function tsb.playButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    gameState = "levelSelect"

    gameStateManager.setGameState("responsiveLoading", false, "levelSelect")

    --[[riverName = "mvpRiver"
    gameState = "river"]]
end


function tsb.creditButtonRelease()
    -- Could just be stuffed into the function but this is better when looking for what this does trust. 50%
    gameState = "credits"

    --[[riverName = "mvpRiver"
    gameState = "river"]]
end

function tsb.devRiverButtonRelease()
    riverName = "devRiver"
    gameState = "river"
    print("--set dev river")
end





return tsb