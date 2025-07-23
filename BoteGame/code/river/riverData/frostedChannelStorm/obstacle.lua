local function boulderValleyChainLengthCoefficient(percentage)
    return 1.35 - 0.2*quindoc.clamp(percentage,0,1)
end

local function stormValleyCurrent(percentage)
    local idk = percentage

    if percentage < 0.8 then
        idk = percentage*1.25
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end
    return 250 + 150*quindoc.clamp(idk,0,1) 
end

local function stormValleyStormIntensity(percentage)
    local idk = percentage

    if percentage < 0.4 then
        idk = percentage*2.5
    elseif percentage < 0.8 then
        idk = 1
    else
        idk = 1 - 2*((percentage - 0.8) * 5)
    end

    idk = quindoc.clamp(idk*0.4+0.6,0,1)

    return 1000*quindoc.clamp(idk,0,1)
end

local function coniferousMountainsideDifficulty(percentage)

    if percentage > 0.9 then
        return 0
    else
        return 0.01
    end

end

local function iceRapidsCurrent(percentage)

    return 350 + -50*(quindoc.clamp((percentage-0.9)*10,0,1))

end

local function deathValleyStormIntensity(percentage)

    return 400 + 200*percentage


end


return {

    ["Ice Rapids"] = {
        difficultyFunction = 0.015,
        current = 350,
        stormIntensity = 400
    },
    ["Death Valley"] = {
        difficultyFunction = 0.004,
        current = 300,
        chainLengthCoefficient = 1,
        stormIntensity = deathValleyStormIntensity
    },
    ["Hailstone Heck"] = {
        stormIntensity = stormValleyStormIntensity,
        difficultyFunction = 0.012,
        current = stormValleyCurrent,
        chainLengthCoefficient = stormValleyChainLengthCoefficient,
    },
    ["_Hailstone Heck"] = {
        stormIntensity = 0,
        difficultyFunction = 0.006,
        current = 100,
        chainLengthCoefficient = 1.1,
    },
    ["Wooded Hills"] = {
        difficultyFunction = coniferousMountainsideDifficulty,
        current = 100,
        stormIntensity = 0,
    },
}



--riverGenerator:GetPercentageThrough(player.y)