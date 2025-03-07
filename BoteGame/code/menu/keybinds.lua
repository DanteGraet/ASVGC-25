local function touchLeft(x, y)
    local u = love.graphics.getHeight()/8*3

    return y > love.graphics.getHeight() - u and x < u
end
local function touchRight(x, y)
    local u = love.graphics.getHeight()/8*3

    return y > love.graphics.getHeight() - u and x < 2*u and x >= u
end

local function touchAccelerate(x, y)
    local u = love.graphics.getHeight()/8*3

    return y > love.graphics.getHeight() - u and x > love.graphics.getWidth() - u
end
local function touchDecelerate(x, y)
    local u = love.graphics.getHeight()/8*3

    return y > love.graphics.getHeight() - u and x > love.graphics.getWidth() - u*2 and x <= love.graphics.getWidth() - u
end

local function touchPause(x, y)
    local u = love.graphics.getHeight()/8*3
    return y < u and x < love.graphics.getWidth() - u
end

local keybinds = {
    left = {
        keyboard = {"left", "a"},
        touch = {touchLeft}
    },
    right = {
        keyboard = {"right", "d"},
        touch = {touchRight}
    },    
    accelerate = {
        keyboard = {"up", "w"},
        touch = {touchAccelerate}
    },
    decelerate = {
        keyboard = {"down", "s"},
        touch = {touchDecelerate}
    },
    pause = {
        keyboard = {"escape", "p"},
        touch = {touchPause}
    }
}

return keybinds