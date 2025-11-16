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
        keyboard = {"a", "left"},
        touch = {touchLeft}
    },
    right = {
        keyboard = {"d", "right"},
        touch = {touchRight}
    },    
    accelerate = {
        keyboard = {"w", "up"},
        touch = {touchAccelerate}
    },
    decelerate = {
        keyboard = {"s", "down"},
        touch = {touchDecelerate}
    },
    pause = {
        keyboard = {"escape", "p"},
        touch = {touchPause}
    }
}

return keybinds