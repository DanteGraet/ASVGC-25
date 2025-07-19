local function boulderValleyWind(percentage)
    return 600 + 300*quindoc.clamp(percentage,0,1)
end

local function boulderValleySnow(percentage)
    return 10*quindoc.clamp(percentage,0,1) + 15
end


local function stormValleyWind(percentage)
    local idk = 0

    if percentage > 0.8 then
        idk = percentage-0.8
    end

    return 900 + -900*quindoc.clamp(idk,0,1)
end

local function stormValleySnow(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 25 + 30*quindoc.clamp(idk,-1,1)
end

return {
    ["Ice Rapids"] = {
        snowAmount = 15,
        windSpeed = 600,
    },
    ["Death Valley"] = {
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
    },
    ["Hailstone Heck"] = {
        snowAmount = stormValleySnow,
        windSpeed = stormValleyWind,
    },
    ["_Hailstone Heck"] = {
        snowAmount = 3,
        windSpeed = 300,
    },
    ["Wooded Hills"] = {
        snowAmount = 3,
        windSpeed = 300,
    },
}