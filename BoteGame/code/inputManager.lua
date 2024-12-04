local InputManager = {}
InputManager.__index = InputManager

-- consturctor
function InputManager:New(keybinds)
    local obj = setmetatable({}, InputManager)

    obj.keybinds = keybinds

    return obj
end


--getting general input
function InputManager:GetInput()
    local inputs = {}

    for input, methods in pairs(self.keybinds) do
        for method, keys in pairs(methods) do
            local breakOut = false
            if method == "keyboard" then
                for i = 1,#keys do
                    if love.keyboard.isDown(keys[i]) then
                        inputs[input] = true
                        breakOut = true
                        break
                    end
                end

            elseif method == "mouse" then
                for i = 1,#keys do
                    if love.mouse.isDown(keys[i]) then
                        inputs[input] = true
                        breakOut = true
                        break
                    end
                end
            end

            if breakOut then break end

        end
    end
   
    return inputs
end

-- checkign for spesific inputs
function InputManager:Send(type, button)
    for key, input in pairs(self.keybinds) do
        if input[type] then
            for i = 1,#input[type] do
                if input[type][i] == button then
                    return key
                end
            end
        end
    end
end

return InputManager