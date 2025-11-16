local y = 0
local buttons = GraetUi:New()
local textList
local width = 1000
local moveTimer = 0
local scrollSpeed = 4
local maxHeight = 0
local image
local paused = false


local function extraLoad()
    local screenScale = screen.getScale()

    river = nil
    y = love.graphics.getHeight()/screenScale
    textList = {}
    --buttons = GraetUi:New()

    local buttonColours = {
        {1,1,1},
        {.8,.8,.8},
        {.5,.5,.5},
    }

    local height = 0
    for i = 1,#assets.code.creditList.text do
        local text = assets.code.creditList.text[i]

        if #text[1] == 1 then
            if string.sub(text[1][1], 1, 5) == "https" then
                --buttons:AddTextButton(text[1][1], text[1][1], "center", text[2], 1920/2 - width/2, height, width, buttonColours)
                --buttons:GetButtons()[text[1][1]].functions.click = {love.system.openURL, text[1][1]}
--
                --buttons:GetButtons()[text[1][1]]:AddText(text[1][1], "left", text[2], 4, 4, 1000, 1)
                --buttons:GetButtons()[text[1][1]]:SetElementColour({0,0,0,0.7}, nil, nil, 1)


            else
                table.insert(textList, {text[1][1], text[2], "center", height})
            end
        else
            if string.sub(text[1][1], 1, 5) == "https" then
                -- add button
                --buttons:AddTextButton(text[1][1], text[1][1], "left", text[2], 1920/2 - width/2, height, width, buttonColours)
                --buttons:GetButtons()[text[1][1]].functions.click = {love.system.openURL, text[1][1]}
--
                --buttons:GetButtons()[text[1][1]]:AddText(text[1][1], "left", text[2], 4, 4, 1000, 1)
                --buttons:GetButtons()[text[1][1]]:SetElementColour({0,0,0,0.7}, nil, nil, 1)
                --love.graphics.setColor()
                
            else
                table.insert(textList, {text[1][1], text[2], "left", height})
            end

            if string.sub(text[1][2], 1, 5) == "https" then
                -- add button
                --buttons:AddTextButton(text[1][2], text[1][2], "right", text[2], 1920/2 - width/2, height, width, buttonColours)
                --buttons:GetButtons()[text[1][2]].functions.click = {love.system.openURL, text[1][2]}
--
                --buttons:GetButtons()[text[1][2]]:AddText(text[1][2], "left", text[2], 4, 4, 1000, 1)
                --buttons:GetButtons()[text[1][2]]:SetElementColour({0,0,0,0.7}, nil, nil, 1)


            else
                table.insert(textList, {text[1][2], text[2], "right", height})
            end
        end

        height = height + font.getFont(text[2]):getHeight()
    end
    maxHeight = -height

    image = assets.code.creditList.image

    zones.displayName = "Credits"
end

local function load()
    local img = "image/loading/title.png"

    if previousGameState == "river" then
        img = "image/loading/clear.png"
    end

    music.load({
        crossFadeSpeed = 1,
        tracks = {  -- Starting Values
            [1] = "music/bonusBoteGame.mp3",
        },
        zones = {
            ["Credits"] =        {1},
        }
    })
    zones.displayName = "Credits"

    paused = false

    extraLoad()
end



local function unload()
    textList = nil
    buttons = nil
    image = nil
end

local function mousemoved(x, y)
    --moveTimer = -1
    love.mouse.setVisible(true)
end


local function resize()
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
end

local function update(dt)
    music.update(dt)
    --[[if love.mouse.isDown(1) or love.mouse.isDown(2) then
        moveTimer = -1
    end]]
    if moveTimer < 0 then
        moveTimer = moveTimer + dt
        scrollSpeed = math.max(scrollSpeed - dt, 0)

        if moveTimer >= 0 then
            love.mouse.setVisible(false)
        end
    else
        scrollSpeed = math.min(scrollSpeed + dt, 1)
    end
    y = y - dt*65*tweens.sineInOut(scrollSpeed)

    if y < 70 and paused == false then
        paused = true
        moveTimer = -3
    end

    if y + 50 < maxHeight then
        gameStateManager.setGameState("responsiveLoading", nil, "titleScreen")
    end
end

local function mousepressed(x, y, button)

end

local function mousereleased(x, y, button)

end


local function keyreleased(key)
    if key == "escape" then
        gameState = "titleScreen"
    end
end


local function draw()
    love.graphics.push()
    
    love.graphics.reset()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(assets.image.ui.creditsBackground, 0, 0, 0, love.graphics.getWidth()/1920, love.graphics.getHeight()/1080)

    love.graphics.pop()
    love.graphics.translate(0, y)

    -- Background
    love.graphics.setColor(1,1,1)
    if buttons then
        buttons:Draw()
    end

    love.graphics.setColor(1,1,1)
    local height
    if textList then
        for i = 1,#textList do
            font.setFont(textList[i][2])
            love.graphics.setColor(0,0,0,0.7)
            love.graphics.printf(textList[i][1], 1920/2 - width/2+4, textList[i][4]+4, width, textList[i][3])
            love.graphics.setColor(1,1,1)
            love.graphics.printf(textList[i][1], 1920/2 - width/2, textList[i][4], width, textList[i][3])
        end

        for i = 1,#image do
            love.graphics.draw(image[i][1], image[i][2], image[i][3])
        end
    end
end


return {
    load = load,
    extraLoad = extraLoad,
    unload = unload,
    mousefocus = mousefocus,

    resize = resize,
    mousemoved = mousemoved,
    
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    keyreleased = keyreleased,
    update = update,
    draw = draw,
}