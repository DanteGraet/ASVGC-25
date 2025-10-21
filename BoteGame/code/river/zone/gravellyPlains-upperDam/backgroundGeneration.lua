local function gravelBG(x, y, elevation, p)
    local colour

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


local function upperDamBG(x, y, elevation)
    local colour

    local noiseA = love.math.noise(y/1500.01) / 10
    local noiseB = love.math.noise(y/300.01) / 10
    local noiseC = love.math.noise(y/50.01) / 50

    if elevation < 0.03 then --riverbank
        colour = {0.401,0.4,0.45}
    elseif elevation < 0.06 +noiseA/10 then --near riverbank

        colour = {0.5001,0.5,0.55}

    elseif elevation < 1.17 then --main concrete

        if love.math.noise(x/1600.1,y/1600.1) > 0.35 and love.math.noise(x/1600.1,y/1600.1) < 0.65 then --"path" pattern
            colour = {0.67001,0.67,0.67} 
        else      

            local u = (x + y) / math.sqrt(2)
            local b = u % 100    

            if b < 50 then
                colour = {0.685001,0.685,0.685} --stripes
            else
                colour = {0.7001,0.7,0.7}
            end
        end

    elseif elevation < 1.2 then

        colour = {0.5001,0.5,0.55}

    else

        local u = (x - y) / math.sqrt(2)
        local b = u % 200    

        if b < 50 then
            colour = {0.585001,0.585,0.585} --stripes
        else
            colour = {0.6001,0.6,0.6}
        end

    end

    return colour
end

local function GetColourAt(x, y, distToEdge)
    local colour = {0.5,0.5,0.5}

    if not distToEdge then
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

        local elevation = distToEdge/(500+500*p)


        if p < 0.75 - math.abs(x)/10000 then
           return gravelBG(x, y, elevation, p)
        elseif ((GetPercentageThrough and GetPercentageThrough(y + 15)) or riverGenerator:GetPercentageThrough(y+15 )) < 0.75 - quindoc.clamp(math.abs(x)/10000, 0, 0.65) then
            return {0.401,0.4,0.45}
        elseif ((GetPercentageThrough and GetPercentageThrough(y + 30)) or riverGenerator:GetPercentageThrough(y+30 )) < 0.75 - quindoc.clamp(math.abs(x)/10000, 0, 0.65) then
            return {0.501,0.5,0.55}
        else
            return upperDamBG(x, y, distToEdge/500)
        end
    end    
end
    
return GetColourAt  