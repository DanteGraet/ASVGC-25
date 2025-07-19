local function boulderValleyWind(percentage)
    return 100 + 300*quindoc.clamp(percentage,0,1)
end

local function boulderValleySnow(percentage)
    return 10*quindoc.clamp(percentage,0,1) + 5
end


local function stormValleyWind(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 400 + 900*quindoc.clamp(idk,-0.2,1)
end

local function stormValleySnow(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 23 + 30*quindoc.clamp(idk,-1,1)
end

return {
    ["Glacial Lake"] = {
        snowAmount = 1,
        windSpeed = 200,
    },
    ["Ice Plains"] = {
        snowAmount = 5,
        windSpeed = 200,
    },
    ["Boulder Valley"] = {
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
    },
    ["Storm Valley"] = {
        snowAmount = stormValleySnow,
        windSpeed = stormValleyWind,
    },
    ["_Storm Valley"] = {
        snowAmount = 3,
        windSpeed = 300,
    },
    ["Wooded Hills"] = {
        snowAmount = 3,
        windSpeed = 300,
    },
}