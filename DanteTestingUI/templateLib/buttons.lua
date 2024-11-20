--Currently un the process of being depreciated...
--                                  
--                                                          ...Already
--
-- yea i know but oh well

local drawHitboxes = false
local buttons = {}
local selectedButton = nil

--components ('extra' things buttons can have)
local function setText(name, text, align, font, oy)
    if buttons[name] then
        if text then
            buttons[name].text = {
                text = text,
                align = align,
                font = font,
                oy = oy or 0,
            }
        else
            --empty the thing
        end
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end
end

local function setTextColour(name, c1, c2, c3)
    if buttons[name] and buttons[name].text then
        if c1 == nil then
            buttons[name].text.colours = nil
        else
            buttons[name].text.colours = {
                normal = c1,
                hover =  c2 or c1,
                click =  c3 or c2 or c1
            }
        end
    else
        if not buttons[name] then
            print("[BUTTONS] can't find button '" .. name .. "'")
        else
            print("[BUTTONS] button '" .. name .. "' does not have text")
        end
    end
end

local function setRect(name, fill, x, y, sx, sy, r)
    if buttons[name] then
        if fill then
            buttons[name].rect = {
                x = x or buttons[name].x,
                y = y or buttons[name].y,
                sx = sx or buttons[name].sx,
                sy = sy or buttons[name].sy,
                r = r or 0,
                fill = fill,
            }
        else
            buttons[name].rect = nil
        end
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end
end

local function setRectColour(name, c1, c2, c3)
    if buttons[name] and buttons[name].rect then
        if c1 == nil then
            buttons[name].rect.colours = nil
        else
            buttons[name].rect.colours = {
                normal = c1,
                hover =  c2 or c1,
                click =  c3 or c2 or c1
            }
        end
    else
        if not buttons[name] then
            print("[BUTTONS] can't find button '" .. name .. "'")
        else
            print("[BUTTONS] button '" .. name .. "' does not have text")
        end
    end
end


local function setFunction(name, type, func, param)
    if buttons[name] then
        if type == "click" or type == "hover" or type == "release" then
            if not buttons[name].functions then
                buttons[name].functions = {}
            end

            buttons[name].functions["on" .. type:sub(1, 1):upper() .. type:sub(2)] = func
            buttons[name].functions["on" .. type:sub(1, 1):upper() .. type:sub(2) .. "Param"] = param

        else
            print("[BUTTONS] invalid function type '" .. type .. "'")

        end
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end
end



local function modify(name, values)
    local function goDeeper(current, key)
        return current[key]
    end

    if buttons[name] then
        local b = buttons[name]

        for i = 1, #values do
            local cv = b

            -- Traverse the nested keys except the last one
            for j = 1, #values[i] - 2 do
                cv = goDeeper(cv, values[i][j])
            end

            -- Modify the last key with the new value
            cv[values[i][#values[i] - 1]] = values[i][#values[i]]
        end
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end
end


--Button types
local function remove(name)
    if buttons[name] then
        buttons[name] = nil
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end
end

local function new(name, x, y, sx, sy) --Creates a basic button
    if buttons[name] then
        print("[BUTTONS] button '" .. name .. "' already exists")    
    else
        buttons[name] = {x = x, y = y, sx = sx, sy = sy, selected = false}
    end
end

local function newText(name, text, align, font, x, y, limit) --Creates a basic text button
    local size = font:getWidth(text)
    local height = font:getHeight(text)
    local startX = x

    if align == "center" then
        startX = x + limit/2 - size/2
    elseif align == "left" then
        startX = x
    elseif align == "right" then
        startX = x + limit - size
    end

    new(name, startX, y, size, height)
    setText(name, text, align, font)
end

local function checkMouseHover(name, mouseX, mouseY)
    if buttons[name] then
        local button = buttons[name]
        if mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy then
            return true
        end
    else
        print("[BUTTONS] can't find button '" .. name .. "'")
    end

    return false
end

--General functions 
local function mousepressed(mouseX, mouseY)

    --unselect all buttons
    for name, button in pairs(buttons) do
        button.selected = false
    end

    --check for clicks
    for name, button in pairs(buttons) do
        if mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy then
            if button.functions and button.functions.onClick then
                button.functions.onClick(button.functions.onClickParam)
            end

            button.selected = true
            selectedButton = name
            return name
        end
    end
end

local function mousereleased(mouseX, mouseY)
    for name, button in pairs(buttons) do
        if mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy and name == selectedButton then
            if button.functions and button.functions.onRelease then
                button.functions.onRelease(button.functions.onReleaseParam)
            end
            selectedButton = nil
            return name
        end
    end

    selectedButton = nil
end

local function draw(mouseX, mouseY)
    love.graphics.setLineWidth(1)
    for name, button in pairs(buttons) do

        if button.rect then
            if button.rect.colours then
                if name == selectedButton then
                    love.graphics.setColor(button.rect.colours.click)
                elseif mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy then
                    love.graphics.setColor(button.rect.colours.hover)
                else
                    love.graphics.setColor(button.rect.colours.normal)
                end
            else
                --use a default colour
                love.graphics.setColor(1,1,1)
            end
            love.graphics.rectangle(button.rect.fill, button.rect.x, button.rect.y, button.rect.sx, button.rect.sy, button.rect.r)
        end

        if button.text then
            love.graphics.setFont(button.text.font)
            if button.text.colours then
                if name == selectedButton then
                    love.graphics.setColor(button.text.colours.click)
                elseif mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy then
                    love.graphics.setColor(button.text.colours.hover)
                else
                    love.graphics.setColor(button.text.colours.normal)
                end
            else
                --use a default colour
                love.graphics.setColor(1,1,1)
            end
            love.graphics.printf(button.text.text, button.x, button.y + button.text.oy, button.sx, button.text.align)
        end

        --draww hitbox if drawHitboxes is enabled
        if drawHitboxes then
            love.graphics.setColor(0,1,0)

            if mouseX > button.x and mouseX < button.x + button.sx and mouseY > button.y and mouseY < button.y + button.sy then
                --if highlighting, set colour to red
                love.graphics.setColor(1,0,0)
            end

            love.graphics.rectangle("line", button.x, button.y, button.sx, button.sy)
        end
    end
end

return {
    new = new,
    remove = remove,
    setFunction = setFunction,
    checkMouseHover = checkMouseHover,
    newText = newText,
    modify = modify,
    setText = setText,
    setTextColour = setTextColour,
    setRect = setRect,
    setRectColour = setRectColour,
    mousepressed = mousepressed,
    mousereleased = mousereleased,
    draw = draw,
}