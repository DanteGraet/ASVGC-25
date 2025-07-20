--general
local function currentMult()
    return -0.5/(math.abs(player.y)/1000000 + 1) + 1.5
end

local function difficultyMult()
    return math.abs(player.y/50000000000) + 1
end

-- frosted channel functionss
    local function iceplainsCurrent(percentage)
        return (100*quindoc.clamp(percentage,0,1) + 100) *currentMult()
    end

    local function boulderValleyDifficulty(percentage)
        return (0.0015 + 0.0035*quindoc.clamp(percentage,0,1))*difficultyMult()
    end


    local function boulderValleyCurrent(percentage)
        return (200*quindoc.clamp(percentage,0,1) + 100)*currentMult()
    end

    local function boulderValleyChainLengthCoefficient(percentage)
        return 1.35 - 0.2*quindoc.clamp(percentage,0,1)
    end


    local function stormValleyDifficulty(percentage)
        return (0.005+percentage*0.005)*difficultyMult()
    end


    local function stormValleyCurrent(percentage)
        local idk = percentage

        if percentage < 0.8 then
            idk = percentage*1.25
        else
            idk = 1 - 2*((percentage - 0.8) * 5)
        end
        return (300 + 200*quindoc.clamp(idk,-0.5,1)) *currentMult()
    end

    local function stormValleyChainLengthCoefficient(percentage)
        return 1.15 - 0.05*quindoc.clamp(percentage,0,1)
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

        return 1000*quindoc.clamp(idk,0,1)
    end

    local function coniferousMountainsideDifficulty(percentage)

        if percentage > 0.9 then
            return 0
        else
            return 0.01*difficultyMult()
        end

    end

--Autumn Grove Functions
    local function autumnRapidsCurrent(percentage)
        return (200*quindoc.clamp(percentage,0,1) + 200 + 100*quindoc.clamp(percentage*10,0,1))*currentMult()
    end

-- Dam Functions 
    --Nothing here D:



--return
return {
    ["Ice Plains"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = iceplainsCurrent,
    },
    ["Boulder Valley"] = {
        difficultyFunction = boulderValleyDifficulty,
        current = boulderValleyCurrent,
        chainLengthCoefficient = boulderValleyChainLengthCoefficient,
    },
    ["Storm Valley"] = {
        stormIntensity = stormValleyStormIntensity,
        difficultyFunction = stormValleyDifficulty,
        current = stormValleyCurrent,
        chainLengthCoefficient = stormValleyChainLengthCoefficient,
    },
    ["Wooded Hills"] = {
        difficultyFunction = coniferousMountainsideDifficulty,
        current = function()
            return 100 * currentMult()
        end,
    },


    ["Autumn Grove"] = {
        difficultyFunction = function() return 0.005 * difficultyMult() end,
        current = function()
            return 200 * currentMult()
        end
    },
    ["Clockwork Ruins"] = {
        difficultyFunction = function() return 0.02 * difficultyMult() end,
        current = 200,
    },
    ["Clockwork's Core"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = function() return 100 * currentMult() end,
    },
    ["Autumn Rapids"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = autumnRapidsCurrent,
    },


    ["Gravelly Plains"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = function() return 200 * currentMult() end,
    },
    ["Upper Dam"] = {
        difficultyFunction = function() return 0.012 * difficultyMult() end,
        current = function() return 150 * currentMult() end,
    },
    ["The Inlet"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = function() return 500 * currentMult() end,
    },

    ["Electrical Complex"] = {
        difficultyFunction = function() return 0.01 * difficultyMult() end,
        current = function() return 100 * currentMult() end,
    },
}



--riverGenerator:GetPercentageThrough(player.y)