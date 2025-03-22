-- theread to help prevent performance issues

local love = require("love")
love.math = require("love.math")
love.graphics = require("love.graphics")
local math = require("math")
local table = require("table")
local string = require("string")


math.randomseed(os.time() + love.thread.getChannel("background_rSeed"):pop())

local width = love.thread.getChannel("background_width"):pop()

local targetY = 0
local generatedY = 0
local zone = love.thread.getChannel("background_zone"):pop()

while not love.thread.getChannel("background_closeThread"):pop() do

    local y = love.thread.getChannel("background_playerY"):pop()
    if y then
        targetY = y
    end

    local w = love.thread.getChannel("background_playerY"):pop()
    if w then
        width = w
    end

    local z = love.thread.getChannel("background_zone"):pop()
    if z then
        zone = z
    end

    if math.floor(generatedY) < math.floor(targetY) then
        for i = generatedY, targetY do
            local image = love.image.newImageData(1, width)

            love.thread.getChannel("background_layer"):push(image)
        end
    end

    love.timer.sleep(0.001)
end