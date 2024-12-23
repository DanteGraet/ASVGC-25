local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    if river:IsInBounds(x, y) then

        local noiseA = love.math.noise(y/300.01)/100
        local noiseB = love.math.noise(y/2000.01)/30
        local noiseC = love.math.noise(y/10000.01)/20
       -- noiseD = love.math.noise(y/20.01)/200

        local mega = quindoc.round(((1-river:getDistToEdge(x, y)/-1500+noiseA+noiseB+noiseC))*1.96,1)/1.96

        colour = quindoc.clamp(mega,0.815,1)
        return {53*colour/255,81*colour/255,147*colour/255}
        
    else
        elevation = river:getDistToEdge(x, y)/500

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.05 then --riverbank
            colour = {0.25,0.24,0.23}
        elseif elevation < 0.15 +noiseA + noiseB - noiseC then --near riverbank
            colour = {0.41,0.41,0.41}
        elseif elevation < 0.75 + noiseB - noiseA then --main stone
            
            if love.math.noise(x/500.1,y/500.1) < 0.3 then
                colour = {0.45,0.45,0.45}
            else colour = {0.47,0.48,0.48} end


        elseif elevation < 0.80 + noiseB - noiseA then --snow's edge
            colour = {0.79,0.85,0.98}
        else --snow
            colour = {0.9,0.97,1.0}
        end

        return colour

    end    
end

return GetColourAt