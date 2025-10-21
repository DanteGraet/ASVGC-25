local function GetColourAt(x, y, distToEdge)
    local colour = {0.5,0.5,0.5}

    if not distToEdge then
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


        --if p > 0.9 then p = 0 end

        local elevation = distToEdge/(500)

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.03 then --riverbank
            colour = {0.401,0.4,0.45}
        elseif elevation < 0.06 +noiseA/10 then --near riverbank

            colour = {0.5,0.5,0.55}

        elseif elevation < 1.17 then --main concrete

            if love.math.noise(x/1600.1,y/1600.1) > 0.35 and love.math.noise(x/1600.1,y/1600.1) < 0.65 then --"path" pattern
                colour = {0.67,0.67,0.67} 
            else      

                local u = (x + y) / math.sqrt(2)
                local b = u % 100    

                if b < 50 then
                    colour = {0.685,0.685,0.685} --stripes
                else
                    colour = {0.7,0.7,0.7}
                end
            end

        elseif elevation < 1.2 then

            colour = {0.5,0.5,0.55}

        else

            local u = (x - y) / math.sqrt(2)
            local b = u % 200    

            if b < 50 then
                colour = {0.585,0.585,0.585} --stripes
            else
                colour = {0.6,0.6,0.6}
            end

        end

        return colour

    end    
end
    
return GetColourAt  