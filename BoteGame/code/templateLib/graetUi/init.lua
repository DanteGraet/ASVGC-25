--local drawDebug = true
--local mouseControll = true

--local clicked = false

--local ui = {}

graetUI = {}

-- load all components
local components = {}
components.rectangleCollider =    require("code/templateLib/graetUi/component/rectangleCollider")
components.circleCollider =       require("code/templateLib/graetUi/component/circleCollider")
components.textGraphic =          require("code/templateLib/graetUi/component/textGraphic")
components.imageGraphic =          require("code/templateLib/graetUi/component/imageGraphic")
components.nineSliceGraphic =          require("code/templateLib/graetUi/component/nineSliceGraphic")




--[[local objects = {}
objects.textbox =               require("code/templateLib/graetUi/object/textbox")
objects.custom =               require("code/templateLib/graetUi/object/textbox")
objects.rectangleButton =       require("code/templateLib/graetUi/object/rectangleButton")
objects.textButton =            require("code/templateLib/graetUi/object/textButton")]]

local function runButtonFunction(obj, func, button, mx, my)
    if func == nil then return nil end

    if type(func) ~= "table" then
        return func(obj, button, mx, my)
    end
    if type(func[2]) == "table" then
        if func[1] then
            return func[1](obj, button, mx, my, unpack(func[2]))
        end
    else
        return func[1](obj, button, mx, my, func[2])
    end
end

function graetUI:getButton(id)
    for i = 1,#self.ui do
        if self.ui[i].id == id then
            return self.ui[i]
        end
    end

    return nil
end

function graetUI:getComponent(component)
    if not components[component] then
        print("GraetUi Error: No component '" .. component .. "'")
    end
    return components[component]
end

-- function
function graetUI:newUI(screenLayer)
    local obj = {
        ui = {},

        screenLayer = screenLayer,

        drawDebug = true,
        mouseControll = true,
        clicked = false,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function graetUI:addCustomObject(id, x, y, anchor, button)
    --local b = objects[type]:new(components, ...)
    --b.id = id

    local b = {
        id = id,
        x = x or 0,
        y =  y or 0,
        anchor = anchor or {.5, .5},
        mouseState = "none",

        components = {}
    }

    local buttonComponents = button.components
    for i = 1,#buttonComponents do
        local c = buttonComponents[i]
        local componentName = c.type

        c.interpolators = {}

        for key, value in pairs(c) do
            if key ~= "interpolators" then
                if key == "colour" then
                    if type(value[1]) == "table" then
                        c.interpolators[key] = value
                        c[key] = value[1]
                    end
                else
                    if type(value) == "table" then
                        c.interpolators[key] = value
                        c[key] = value[1]
                    end
                end
            end
        end

        if components[componentName] then
            local newComponent = components[componentName]:new()
            newComponent = dante.mergeTables(newComponent, c, false)
            table.insert(b.components, newComponent)
        else
            print("no such button component " .. componentName)
        end
    end

    for key,value in pairs(button.data) do
        b[key] = value
    end

    table.insert(self.ui, b)
end

function graetUI:reset(layer)
    if self.ui.mouseState == "clicked" then
        self.clicked = false
    end

    self.ui = {}
end

function graetUI:toggleClick(pressed, screenLayer)
    local hoverdButton, component, mx, my = self:checkHover(screenLayer, true)
    if pressed == true and hoverdButton then
        hoverdButton.mouseState = "clicked"
        self.clicked = true 
        runButtonFunction(component, hoverdButton.onClick, hoverdButton, mx, my)

        return
    else
        if hoverdButton and hoverdButton.mouseState == "clicked" then
            runButtonFunction(hoverdButton, hoverdButton.onRelease, hoverdButton, mx, my)
        end

        self.clicked = false
        self:checkHover(screenLayer)

        return
    end
end

function graetUI:checkHover(screenLayer, doNotUpdate)
    if self.clicked == false or doNotUpdate then
        local hoverdButton
        local hoverdComponent
        local ox, oy 

        local mx, my = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), screenLayer or "")
        if not mx or not my then return end

        local targetWidth, targetHeight, offsetX, offsetY = screen.getScaledSize(screenLayer or "")

        if not doNotUpdate then
            for i = #self.ui, 1, -1 do
                local b = self.ui[i]    
                b.mouseState = "none"
            end
        end

        for i = #self.ui, 1, -1 do
            local b = self.ui[i]    

            local anchorX, anchorY = targetWidth * b.anchor[1],  targetHeight * b.anchor[2]
            local x = mx - anchorX - b.x --+ offsetX
            local y = my - anchorY - b.y --+ offsetY

            for j = 1,#b.components do
                local component = b.components[j]

                if not component.checkHover then
                    goto nextComponent
                end

                local checkHover = {
                    component.checkHover, {x, y}
                }
                if runButtonFunction(component, checkHover, b, x, y) == true then
                    hoverdButton = b
                    hoverdComponent = component
                    ox, oy = x, y

                    if doNotUpdate then goto nextButton end

                    b.mouseState = "hover"

                    runButtonFunction(component, b.onHover, b, x, y)

                    return hoverdButton, hoverdComponent, ox, oy
                    --goto nextButton

                    --break
                end

                --if doNotUpdate then
                --    goto nextButton
                --end

                
                ::nextComponent::
                --runButtonFunction(component, b.onReleased, b)

            end
            ::nextButton::

        end

        return hoverdButton, hoverdComponent, ox, oy
    end
end

function graetUI:draw(layer)
    if not layer then layer = "" end

    local targetWidth, targetHeight, offsetX, offsetY = screen.getScaledSize(layer)

    -- draw the object
    for i = 1,#self.ui do
        local b = self.ui[i]

        local x = b.x + targetWidth * b.anchor[1] -- offsetX
        local y = b.y + targetHeight * b.anchor[2] --- offsetY

        for i = 1,#b.components do 
            if b.components[i].draw then
                b.components[i]:draw(x, y, b)
            end
        end
    end

    -- draw all the debug later (here)
    if self.drawDebug then
        for i = 1,#self.ui do
            local b = self.ui[i]

            local x = b.x +  targetWidth * b.anchor[1] -- offsetX
            local y = b.y + targetHeight * b.anchor[2] -- offsetY

            for i = 1,#b.components do 
                if b.components[i].drawDebug then

                    b.components[i]:drawDebug(b, x or 0, y or 0)
                end
            end
        end
    end
end

local lerpFloat = function(dt, currentValue, targetValue) 
    local diff = targetValue - currentValue

    local clamp = math.min
    if diff < 0 then
        clamp = math.max
    end
    local value = clamp((currentValue + diff*dt*10), targetValue)

    return value
end

function graetUI:update(dt, ...)
    for i = 1,#self.ui do
        local b = self.ui[i]

        local u = {
            b.update,
            {dt,
            ...}
        }

        runButtonFunction(b, u, b)

        local target = (((b.mouseState == "clicked" and 3) or b.mouseState == "hover" and 2 ) or 1)
        for j = 1,#b.components do
            if b.components[j].interpolators then
                for component, data in pairs(b.components[j].interpolators) do
                    
                    local func = b.interpolationFunction or lerpFloat
                    local new

                    if type(data[1]) == "table" then
                        -- table
                        new = {}
                        for i = 1,#data do
                            table.insert(new, func(dt, b.components[j][component][i], data[target][i]))
                        end
                    else
                        new = func(dt, b.components[j][component], data[target])
                    end
                    b.components[j][component] = new
                end
            end
        end
    end
end


function graetUI:generalCallback(callback, ...)
    for i = 1,#self.ui do
        local b = self.ui[i]

        for i = 1,#b.components do 
            if b.components[i][callback] then
                b.components[i][callback](b, ...)
            end
        end
    end
end
