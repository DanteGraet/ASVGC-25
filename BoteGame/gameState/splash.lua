local textList = {
    string.upper("Jaraph"),
}
local image
local font 

local timer

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local function load()
    timer = 0
    image = love.graphics.newImage("splash/jaraph.png")
    font = love.graphics.newFont("font/fontBlack.ttf", 512)
end

local function resize()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
end

local function unload()
    
end

local function update(dt)
    --if love.keyboard.isDown("return") then timer = 0 end 
    timer = timer + dt
    if timer >= 5.5 then
        --previousGameState = ""
        gameState = "titleScreen"
    end
end

local function draw()
    local scaleAll = math.min(width/1920, height/1080)
    local scaleAlleY = height/1080
    love.graphics.translate(width/2, height/2)


    love.graphics.setFont(font)
    love.graphics.setColor(0/255, 183/255, 239/255)

    local cps = 10
    local legnth = timer*cps
    local text = " "
    if legnth > cps then
        text = string.sub(textList[1], 0, math.floor(legnth)-cps)
    end
    local textScaleX = width/font:getWidth(text)
    local textScaleY = 1--height/(font:getHeight(text))
    if legnth < 100 then
        local ox = font:getWidth(text)*math.min(textScaleX, scaleAlleY)
        love.graphics.print(text, math.max(width/2 - ox, -width/2), -50*scaleAlleY, 0, math.min(textScaleX, scaleAlleY), scaleAlleY, 0, font:getHeight(text)/2)
    end
    if legnth > #textList[1] + cps and legnth < #textList[1] + cps*2 then
        local r = math.pow((legnth  - (#textList[1] + cps)), 3)
        love.graphics.circle("fill", 0, 0, r)
    end


     

    if legnth >= #textList[1] + cps*2 then
        local p = math.max((-math.pow((((legnth-(#textList[1] + cps*2))/50*cps) - 2), 3) + 1)/50*cps, 0)
        local r = quindoc.pythag(width/2, height/2)*p

        local cX = (590 - 512)*(1-p)
        local cY = (330 - 512)*(1-p)
        love.graphics.circle("fill", cX*scaleAll*0.5, cY*scaleAll*0.5, r)
    end

    love.graphics.setColor(1, 1, 1, tweens.sineOut(math.min(timer, 1)))
    love.graphics.draw(image, 0, 70 - tweens.sineOut(math.min(timer, 1))*70, 0, scaleAll*0.5, scaleAll*0.5, image:getWidth()/2, image:getHeight()/2)

    if legnth >= #textList[1] + cps*2 then
        local p = math.max((-math.pow((((legnth-(#textList[1] + cps*2))/50*cps) - 2), 3) + 1)/50*cps, 0)
        local r = quindoc.pythag(width/2, height/2)*p

        local cX = (590 - 512)*(1-p)
        local cY = (330 - 512)*(1-p)
        --local lineW = p*500*scaleAll

        love.graphics.setColor(0,0,0)
        love.graphics.setLineWidth(1024)

        love.graphics.circle("line", cX*scaleAll*0.5, cY*scaleAll*0.5, r + 1024/2)
    end
end


return {
    load = load,
    resize = resize,
    unload = unload, 
    update = update,
    draw = draw,

    isFirst = true,
    noTransform = true,
}