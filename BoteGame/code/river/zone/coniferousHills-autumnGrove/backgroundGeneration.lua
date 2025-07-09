local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    local distToEdge
    if getDistToEdge then
        distToEdge = getDistToEdge(x, y)
    else
        distToEdge = river:getDistToEdge(x, y)
    end


    if distToEdge < 0 then

        -- water
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

        if zones and zones.zone == "coniferousMountainside" then
            p = quindoc.clamp(riverGenerator:GetPercentageThrough(y)-0.2,0,1)
        else
            if GetPercentageThrough then
                p = quindoc.clamp(GetPercentageThrough(y)-0.2, 0, 1)
            end
        end

        local elevation = distToEdge/(500+500*p)
        local groveElevation = distToEdge/500
        local totalElevation = elevation + (groveElevation-elevation)*p

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        local transitionNoise1 = love.math.noise(y/50.01, x/50.01)/2 + 0.5
        local transitionNoise = quindoc.clamp(love.math.noise(y/750.01, x/750.01)*(p*2)*transitionNoise1, 0, 1) + 1*p
        local groveColour = transitionNoise >= 0.5


        if totalElevation < 0.05 - 0.02*p then --riverbank
            if not groveColour then
                colour = {0.85,0.9,0.25}
            else
                colour = {0.4,0.22,0.19}
            end
        elseif totalElevation < 0.10 - 0.05*p + noiseA/10   then --near riverbank
            if not groveColour then
                colour = {0.59,0.82,0.28}
            else
                colour = {0.68,0.34,0.1}
            end

        elseif totalElevation < (0.97 +0.4*p)*(1) + noiseB - noiseA then --main gtass
            
            --local snowPatch = 0.9*love.math.noise(2*x/1600.1,2*y/1600.1) + 0.1*love.math.noise(x/100.1,y/100.1)

            if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                colour = (groveColour and {0.87,0.44,0.14} ) or {0.45,0.69,0.2}
            else colour = (groveColour and {0.87,0.5,0.21}) or {0.45,0.72,0.14} end


        elseif totalElevation < (1 + 0.4*p)*(1) + noiseB - noiseA then --uppergrass
            colour = (groveColour and {0.8,0.4,0.16} ) or {0.36,0.63,0.07}


        else 
            if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                colour = (groveColour and {0.72,0.4,0.22} ) or {0.4,0.63,0.18}
            else colour = (groveColour and {0.72,0.37,0.18} ) or {0.4,0.66,0.14} end

        end

        return colour

    end    
end
    
return GetColourAt  