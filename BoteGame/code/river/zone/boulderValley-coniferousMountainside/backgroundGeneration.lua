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

        if type(GetPercentageThrough) == "function" then
            p = GetPercentageThrough(y)
        else
            p = riverGenerator:GetPercentageThrough(y)
        end

        local p = 1-p

        local amt = (math.sin((p-0.5)*math.pi))/2+0.5
        local elevation = (distToEdge - ((1-amt)*1000))/500 * math.max(math.min((love.math.noise(x/2500.1,y/2500.1)+((p*3)-1)), 1), 0)

        if elevation > 0 then
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
        else

            local elevation = distToEdge/(500+500*p)

            local noiseA = love.math.noise(y/1500.01) / 10
            local noiseB = love.math.noise(y/300.01) / 10
            local noiseC = love.math.noise(y/50.01) / 50

            if elevation < 0.05 then --riverbank
                colour = {0.85,0.9,0.25}
            elseif elevation < 0.10 +noiseA/10 then --near riverbank

                local snowPatch = 0.9*love.math.noise(2*x/1600.1,2*y/1600.1) + 0.1*love.math.noise(x/100.1,y/100.1)

                if snowPatch > 0.82 then
                    colour = {0.9,0.97,1.0}
                elseif snowPatch > 0.8 then
                    colour = {0.79,0.85,0.98}
                else
                    colour = {0.24,0.62,0.35}
                end

            elseif elevation < 0.75*(3*p+1) + noiseB - noiseA then --main gtass
                
                local snowPatch = 0.9*love.math.noise(2*x/1600.1,2*y/1600.1) + 0.1*love.math.noise(x/100.1,y/100.1)

                if snowPatch > 0.82 then
                    colour = {0.9,0.97,1.0}
                elseif snowPatch  > 0.8 then
                    colour = {0.79,0.85,0.98}
                elseif love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                    colour = {0.12,0.6,0.33}
                else colour = {0.12,0.58,0.35} end


            elseif elevation < 0.80*(3*p+1) + noiseB - noiseA then --stone's edge
                colour = {0.41,0.41,0.41}
            else --snow
                colour = {0.45,0.45,0.45}
            end

            return colour

        end

    end    
end

return GetColourAt