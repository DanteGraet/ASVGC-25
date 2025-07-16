local function inletBG(x, y, elevation, p)
    local colour = {0.5,0.5,0.5}

    local noiseA = love.math.noise(y/1500.01) / 10
    local noiseB = love.math.noise(y/300.01) / 10
    local noiseC = love.math.noise(y/50.01) / 50

    if elevation < 0.03 then --riverbank
        colour = {0.41,0.4,0.45}
    elseif elevation < 0.06 +noiseA/10 then --near riverbank

        colour = {0.51,0.5,0.55}

    elseif elevation < 0.77 then --main concrete

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

    elseif elevation < 0.8 then

        colour = {0.5,0.5,0.55}

    elseif elevation < 1.24 then

        local b = y % 100    --horizontal stripes

        if b < 50 then
            colour = {0.585,0.585,0.585} --stripes
        else
            colour = {0.6,0.6,0.6}
        end

    elseif elevation < 1.3 then

        colour = {0.3,0.3,0.3}

    elseif elevation < 1.305 + 0.5*noiseB+0.5*noiseA then

        colour = {0.26,0.53,0.07}

    else

        if love.math.noise(x/700.1,y/700.1) < 0.4 then
            colour = {0.4,0.63,0.18}
        else colour = {0.4,0.67,0.14} end

    end

    return colour
end


local function lowerDamBG(x, y, elevation)
    local colour

    local noiseA = love.math.noise(y/1500.01) / 10
    local noiseB = love.math.noise(y/300.01) / 10
    local noiseC = love.math.noise(y/50.01) / 50

    if elevation < 0.03 then --riverbank
        colour = {0.3,0.3,0.35}
    elseif elevation < 0.06 +noiseA/10 then --near riverbank

        colour = {0.4,0.4,0.45}

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

local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    local distToEdge
    if getDistToEdge then
        distToEdge = getDistToEdge(x, y)
    else
        distToEdge = river:getDistToEdge(x, y)
    end

    local p = (GetPercentageThrough and GetPercentageThrough(y)) or riverGenerator:GetPercentageThrough(y)



    if distToEdge < 0 then

        local noiseA = love.math.noise(y/300.01)/100
        local noiseB = love.math.noise(y/2000.01)/30
        local noiseC = love.math.noise(y/10000.01)/20
       -- noiseD = love.math.noise(y/20.01)/200

        local mega = quindoc.round(((1-distToEdge/-1500+noiseA+noiseB+noiseC))*1.96,1)/1.96

        colour = quindoc.clamp(mega,0.815,1)
        return {53*colour/255,81*colour/255,147*colour/255}
        
    else

        local elevation = distToEdge/(500+500*(1-p))


        if p < 0.75 - math.abs(x)/1000 then
           return inletBG(x, y, elevation, p)
        elseif ((GetPercentageThrough and GetPercentageThrough(y + 15)) or riverGenerator:GetPercentageThrough(y+15 )) < 0.75 - quindoc.clamp(math.abs(x)/1000, 0, 0.65) then
            return {0.5001,0.5,0.55}
        elseif ((GetPercentageThrough and GetPercentageThrough(y + 30)) or riverGenerator:GetPercentageThrough(y+30 )) < 0.75 - quindoc.clamp(math.abs(x)/1000, 0, 0.65) then
            return {0.4001,0.4,0.45}
        else
            return lowerDamBG(x, y, distToEdge/500)
        end
    end    
end
    
return GetColourAt  