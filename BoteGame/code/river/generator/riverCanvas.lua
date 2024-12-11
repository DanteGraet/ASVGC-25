local RiverCanvas = {}
RiverCanvas.__index = RiverCanvas

function RiverCanvas:New(y, fill, zone)
    local obj = setmetatable({}, RiverCanvas)

    obj.canvas = love.graphics.newCanvas(
        math.ceil((love.graphics.getWidth()/GetRiverScale()[1]/pixlesPerPixle)) + 2, 
        math.ceil((love.graphics.getHeight()/GetRiverScale()[1]/pixlesPerPixle))
    )
    obj.canvas:setFilter("nearest", "nearest")

    if y then
        obj.y = y - (obj.canvas:getHeight()-2)*pixlesPerPixle
    else
        obj.y = 0
    end

    obj.x = - obj.canvas:getWidth()/2

    if fill then
        love.graphics.reset()
        love.graphics.setCanvas(obj.canvas)

        love.graphics.setColor(1,1,1, 0.5)
        love.graphics.rectangle("fill", -100, -100, 100000, 100000)

        for i = 1,obj.canvas:getHeight() do

            obj:FillCanvasY(i, obj.y + i*pixlesPerPixle, obj.x*pixlesPerPixle, zone)
        end
    end


    return obj  
end

function RiverCanvas:FillCanvasY(canvasY, globalY, canvasX, zone, zone2, chance)
    love.graphics.setCanvas(self.canvas)

    for x = 1,self.canvas:getWidth() do
        local colour
        local num = chance or -1
        if zone2 and math.random(0, 100)/100 >= num then
            colour = assets.code.river.zone[zone2.zone].GetColourAt(globalY, x + canvasX)
            print("Death, the destroyer of worlds")
        else
            colour = assets.code.river.zone[zone.zone].GetColourAt(globalY, x + canvasX)
        end

        if love.graphics.getColor() ~= colour then
            love.graphics.setColor(colour)
        end

        love.graphics.points(x, canvasY)
    end

    love.graphics.setCanvas()
end

return RiverCanvas