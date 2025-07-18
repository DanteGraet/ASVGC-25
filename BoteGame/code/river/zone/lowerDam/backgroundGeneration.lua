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

        local elevation = distToEdge/(500)

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.03 then --riverbank
            colour = {0.3,0.3,0.35}
        elseif elevation < 0.06 +noiseA/10 then --near riverbank

            colour = {0.401,0.4,0.45}

        else --main concrete



            local u = (x + y) / math.sqrt(2)
            local b = u % 100    

            local u2 = (x - y) / math.sqrt(2)
            local b2 = u2 % 100    


            if b < 50 or b2 < 50 then
                colour = {0.465,0.465,0.465} --crosshatch
            else
                colour = {0.5,0.5,0.5}
            end

            local u3 = (2*x-y) / math.sqrt(2)
            local b3 = u3 % 600    

            if b3 < 25 then
                colour = {0.42,0.42,0.5}
            end
        
        end

        return colour

    end    
end
    
return GetColourAt  