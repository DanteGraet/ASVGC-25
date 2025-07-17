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

        if elevation < 0.05 then --riverbank
            if love.math.noise(x/2000.1,y/2000.1) < 0.5 then --gray gravel
                colour = {0.28,0.28,0.2}
            else --red gravel
                colour = {0.35,0.23,0.2}
            end
        elseif elevation < 0.10 +noiseA/10 then --near riverbank

            if love.math.noise(x/2000.1,y/2000.1) < 0.5 then --gray gravel
                colour = {0.38,0.38,0.3}
            else --red gravel
                colour = {0.50,0.33,0.3}
            end

        elseif elevation < 0.97*(3*p+1) + noiseB - noiseA then --main grass
            
            if love.math.noise(x/2000.1,y/2000.1) < 0.48 then --gray gravel

                if love.math.noise(x/400.1,y/400.1) < 0.3 then
                    colour = {0.5,0.5,0.38}
                else
                    colour = {0.53,0.53,0.4}
                end

            elseif love.math.noise(x/2000.1,y/2000.1) < 0.5 then --transition between gray and red, gray side
                colour = {0.47,0.47,0.35}
            elseif love.math.noise(x/2000.1,y/2000.1) < 0.52 then --transition between gray and red, red side
                colour = {0.63,0.39,0.35}
            else

                if love.math.noise(x/400.1,y/400.1) < 0.3 then
                    colour = {0.67,0.40,0.37}
                else
                    colour = {0.70,0.43,0.4}
                end

            end

        elseif elevation < 1*(3*p+1) + noiseB - noiseA+0.03 then --uppergrass
            colour = {0.26,0.53,0.07}
        else 
            if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                colour = {0.4,0.63,0.18}
            else colour = {0.4,0.66,0.14} end
        end

        return colour

    end    
end
    
return GetColourAt  