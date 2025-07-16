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

        local elevation = distToEdge/(500)

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.04 then --riverbank
            
            colour = {0.85,0.7,0.34}

        elseif elevation < 0.08 +noiseA/10 then --near riverbank

            colour = {0.88,0.76,0.44}

        --elseif elevation < 0.49*(3) + noiseB - noiseA then --main gtass
        else  
            --local snowPatch = 0.9*love.math.noise(2*x/1600.1,2*y/1600.1) + 0.1*love.math.noise(x/100.1,y/100.1)

            if love.math.noise(x/300.1,y/300.1) < 0.8 then
                colour = {1.0,0.88,0.61}
            else colour = {0.96,0.85,0.58} end

       -- elseif elevation < 0.5*(3) + noiseB - noiseA then --uppergrass
       --     colour = {0.92,0.8,0.36}
       -- else 
       --     if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
       --         colour = {0.97,0.85,0.58}
       ---     else colour = {0.93,0.81,0.55}  end
        end

        return colour

    end
end
    
return GetColourAt  