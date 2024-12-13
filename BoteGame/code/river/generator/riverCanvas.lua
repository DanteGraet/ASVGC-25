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
        obj.y = y - ((obj.canvas:getHeight()-2)*pixlesPerPixle)
    else
        obj.y = 0
    end

    obj.y = math.floor(obj.y/3)*3

    obj.x = - obj.canvas:getWidth()/2

    obj.x = math.floor(obj.x/3)*3


    if fill then
        love.graphics.reset()
        love.graphics.setCanvas(obj.canvas)

        love.graphics.setColor(1,1,1, 0.5)
        love.graphics.rectangle("fill", -100, -100, 100000, 100000)

        for i = 1,obj.canvas:getHeight() do
            obj:FillCanvasY(i, obj.y + i*pixlesPerPixle, obj.x*pixlesPerPixle, riverGenerator:GetZone(obj.y + i*pixlesPerPixle, true))
        end
    else

        -- removes flickering, height is already +2
        obj:FillCanvasY(1, obj.y + pixlesPerPixle, obj.x*pixlesPerPixle, riverGenerator:GetZone(obj.y + pixlesPerPixle, true))

    end


    return obj  
end

function RiverCanvas:FillCanvasY(canvasY, globalY, canvasX, zone)
    love.graphics.setCanvas(self.canvas)

    local chance
    local zone2

    if zone[1] and type(zone[1]) == "table" then

        zone2 = zone[2]
        chance = zone[3]
        zone = zone[1]
    end

    for x = 1,self.canvas:getWidth() do
        local colour
        local num = chance or -1

        if zone2 and math.random(0, 100)/100 < chance then
            colour = assets.code.river.zone[zone2.zone].GetColourAt((x + self.x)*3, globalY)

        else
            colour = assets.code.river.zone[zone.zone].GetColourAt((x + self.x)*3, globalY)
        end

        if love.graphics.getColor() ~= colour then
            love.graphics.setColor(colour)
        end

        love.graphics.points(x, canvasY)
    end

    love.graphics.setCanvas()
end

return RiverCanvas