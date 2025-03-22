local RiverCanvas = {}
RiverCanvas.__index = RiverCanvas

function RiverCanvas:New(y, fill)
    local pixlesPerPixle = pixlesPerPixle
    local obj = setmetatable({}, RiverCanvas)

    obj.canvas = love.graphics.newCanvas(
        math.ceil(((riverBorders.width + 80)/pixlesPerPixle)) + 4, 
        math.ceil((riverBorders.height/pixlesPerPixle)) + 10
    )
    obj.canvas:setFilter("nearest", "nearest")

    if y then
        obj.y = y - ((obj.canvas:getHeight()-2)*pixlesPerPixle)
    else
        obj.y = 0
    end

    obj.y = math.ceil((obj.y)/3)*3

    obj.x = - obj.canvas:getWidth()/2

    obj.x = math.floor(obj.x/3)*3


    if fill then
        love.graphics.reset()
        love.graphics.setCanvas(obj.canvas)


        for i = 1,obj.canvas:getHeight() do
            obj:FillCanvasY(i, obj.y + i*pixlesPerPixle, obj.x*pixlesPerPixle, riverGenerator:GetZone(obj.y + i*pixlesPerPixle, true))
        end
    else

        for i = obj.canvas:getHeight()-15, obj.canvas:getHeight() do
            obj:FillCanvasY(1, obj.y + i*pixlesPerPixle, obj.x*pixlesPerPixle, riverGenerator:GetZone(obj.y + i*pixlesPerPixle, true))
        end

    end

    return obj  
end

function RiverCanvas:FillCanvasY(canvasY, globalY, canvasX, zone)
    love.graphics.setCanvas(self.canvas)

    local chance
    local zone2

    local colours = {}

    if zone[1] and type(zone[1]) == "table" then

        zone2 = zone[2]
        chance = zone[3]
        zone = zone[1]
    end


    for x = 1,self.canvas:getWidth() do
        local colour
        local num = chance or -1

        --if zone2 and math.random(0, 100)/100 < chance then
        if zone2 and love.math.noise((x + self.x)*3/250, globalY/250) < chance then
            colour = assets.code.river.zone[zone2.zone].GetColourAt((x + self.x)*3, globalY)

        else
            colour = assets.code.river.zone[zone.zone].GetColourAt((x + self.x)*3, globalY)
        end

        local colourName = "c" .. colour[1] .. colour[2] .. colour[3]

        if not colours[colourName] then
            colours[colourName] = {
                colour = colour,
                points = {}
            }
        end
        table.insert(colours[colourName].points, x)
        table.insert(colours[colourName].points, canvasY)

    end

    for key, value in pairs(colours) do
        love.graphics.setColor(value.colour)

        love.graphics.points(value.points)

        colours[key] = nil
    end

    love.graphics.setCanvas()
end

return RiverCanvas