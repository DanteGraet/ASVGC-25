local function boulderValleyWind(percentage)
    return 100 + 300*quindoc.clamp(percentage,0,1)
end

local function boulderValleySnow(percentage)
    return 10*quindoc.clamp(percentage,0,1) + 5
end


local function boulderValleyWind_STORM(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 400 + 600*quindoc.clamp(idk,-0.2,1)
end

local function boulderValleySnow_STORM(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    return 23 + 20*quindoc.clamp(idk,-1,1)
end

return {
    ["Ice Plains"] = {
        snowAmount = 5,
        windSpeed = 200,
    },
    ["Boulder Valley"] = {
        snowAmount = boulderValleySnow,
        windSpeed = boulderValleyWind,
    },
    ["Storm Valley"] = {
        snowAmount = boulderValleySnow_STORM,
        windSpeed = boulderValleyWind_STORM,
    },
    ["Coniferous Highlands"] = {
        snowAmount = 3,
        windSpeed = 300,
    },
}