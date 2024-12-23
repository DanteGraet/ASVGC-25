local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    if river:IsInBounds(x, y) then

        local noiseA = love.math.noise(y/300.01)/100
        local noiseB = love.math.noise(y/2000.01)/30
        local noiseC = love.math.noise(y/10000.01)/20
       -- noiseD = love.math.noise(y/20.01)/200

        local mega = quindoc.round(((1-river:getDistToEdge(x, y)/-2000+noiseA+noiseB+noiseC))*1.6,1)/1.6

        colour = quindoc.clamp(mega,0.815,1)
        return {53*colour/255,81*colour/255,147*colour/255}
        
    else
        colour = river:getDistToEdge(x, y)/500
        return {colour,colour,colour}
    end

    return colour
end

return GetColourAt