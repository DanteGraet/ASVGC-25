local y = 0
local buttons
local textList
local width = 1000
local moveTimer = 0
local scrollSpeed = 2
local maxHeight = 0
local image
local function load()
    local img = "image/loading/title.png"

    if previousGameState == "river" then
        img = "image/loading/clear.png"
    end

    DynamicLoading:New("code/gameStateLoading/creditsLoading.lua", true, img)
end

local function extraLoad()
    river = nil
    y = love.graphics.getHeight()/screenScale
    textList = {}
    buttons = GraetUi:New()

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
                buttons:AddTextButton(text[1][1], text[1][1], "center", text[2], 1920/2 - width/2, height, width, buttonColours)
                buttons:GetButtons()[text[1][1]].functions.click = {love.system.openURL, text[1][1]}
            else
                table.insert(textList, {text[1][1], text[2], "center", height})
            end
        else
            if string.sub(text[1][1], 1, 5) == "https" then
                -- add button
                buttons:AddTextButton(text[1][1], text[1][1], "left", text[2], 1920/2 - width/2, height, width, buttonColours)
                buttons:GetButtons()[text[1][1]].functions.click = {love.system.openURL, text[1][1]}
            else
                table.insert(textList, {text[1][1], text[2], "left", height})
            end

            if string.sub(text[1][2], 1, 5) == "https" then
                -- add button
                buttons:AddTextButton(text[1][2], text[1][2], "right", text[2], 1920/2 - width/2, height, width, buttonColours)
                buttons:GetButtons()[text[1][2]].functions.click = {love.system.openURL, text[1][2]}
            else
                table.insert(textList, {text[1][2], text[2], "right", height})
            end
        end

        height = height + font.getFont(text[2]):getHeight()
    end
    maxHeight = -height

    image = assets.code.creditList.image
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
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2
end

local function mousefocus(f)
    if not f then
        moveTimer = -math.huge
    else
        moveTimer = 0
    end
end

local function update(dt)
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
    y = y - dt*50*tweens.sineInOut(scrollSpeed)

    local mx, my = getMouseSoxSoy()
    buttons:Update(dt, mx, my-y)

    if y + 100 < maxHeight then
        love.keyreleased("escape")
    end
end

local function mousepressed(x, y, button)
    local mx, my = getMouseSoxSoy()
    buttons:Click(mx, my-y)
end

local function mousereleased(x, y, button)
    local mx, my = getMouseSoxSoy()
    buttons:Release(mx, my-y)
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
            love.graphics.printf(textList[i][1], 1920/2 - width/2, textList[i][4], width, textList[i][3])
        end

        for i = 1,#image do
            love.graphics.draw(image[1], image[2], image[3])
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