local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    local distToEdge
    if getDistToEdge then
        distToEdge = getDistToEdge(x, y)
    else
        distToEdge = river:getDistToEdge(x, y)
    end


    if distToEdge < 0 then

        local noiseA = love.math.noise(y/300.01)/100
        local noiseB = love.math.noise(y/2000.01)/30
        local noiseC = love.math.noise(y/10000.01)/20
       -- noiseD = love.math.noise(y/20.01)/200

        local mega = quindoc.round(((1-distToEdge/-1500+noiseA+noiseB+noiseC))*1.96,1)/1.96

        colour = quindoc.clamp(mega,0.815,1)
        return {53*colour/255,81*colour/255,147*colour/255}
        
    else

        local p = 0
        
        --if p > 0.9 then p = 0 end

        local elevation = distToEdge/(500+500*p)

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.03 then --riverbank
            colour = {0.4,0.4,0.45}
        elseif elevation < 0.06 +noiseA/10 then --near riverbank

            colour = {0.5,0.5,0.55}

        elseif elevation < 1.37 then --main concrete

            colour = {0.7,0.7,0.7}

        elseif elevation < 1.4 then

            colour = {0.5,0.5,0.55}

        else

            colour = {0.6,0.6,0.6}

        end

        return colour

    end    
end
    
return GetColourAt  