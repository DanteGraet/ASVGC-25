local Button = require("templateLib.graetUi.GraetUiButton")

GraetUi = {}
GraetUi.__index = GraetUi

function GraetUi:New() -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, GraetUi)

    obj.currentLayer = "default"

    obj.layers = {
        default = {}
    }

    return obj
end

function GraetUi:SetLayer(layer)
    self.currentLayer = layer
    if not self.layers[layer] then
        self.layers[layer] = {}
    end
end
function GraetUi:GetButtons(layer)
    return self.layers[layer] or self.layers[self.currentLayer] 
end



function GraetUi:AddButton(name, x, y, sx, sy, layer)
    local layer = self.layers[layer] or self.layers[self.currentLayer]

    layer[name] = Button:New(x, y, sx, sy)
end




function GraetUi:Update(dt, mx, my, layer)
    local elements = self.layers[layer] or self.layers[self.currentLayer]

    for key, value in pairs(elements) do
        value:Update(dt, mx, my)
    end
end

function GraetUi:Click(mx, my, layer)
    local elements = self.layers[layer] or self.layers[self.currentLayer]

    for key, value in pairs(elements) do
        value:Click(mx, my)
    end
end

function GraetUi:Release(mx, my, layer)
    local elements = self.layers[layer] or self.layers[self.currentLayer]

    for key, value in pairs(elements) do
        value:Release(mx, my)
    end
end

function GraetUi:Draw(layer)
    local elements = self.layers[layer] or self.layers[self.currentLayer]

    for key, value in pairs(elements) do
        value:Draw()
    end
end