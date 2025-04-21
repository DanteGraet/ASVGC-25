-- nobody told me how to grab the river current speed at a given point and it isnt like theres any documentation so then i had to write this function because im tired and dante moved everything and i can't figure out where anything is anymore so yeah i give up i just wanted to add a new river zone and then had to go down a 2 hour rabbit hole because all this stuff just didn't work anymore for some reason and i dont know why it was all touched but it stopped working and everythings moved so i don't have any idea how to fix it and i really don't know anymore my god.

function findRiverCurrent(p)

    local p = riverGenerator:GetPercentageThrough(player.y)
    local zoneNames = riverGenerator:GetZone(camera.y, true)

    local currentZone
    local transitionZone
    local transitionPercent = zoneNames[3] or nil

    if zoneNames[1] and type(zoneNames[1]) == "table" then
        currentZone = assets.code.river.riverData[riverName].obstacle[zoneNames[1].displayName]
        transitionZone = assets.code.river.riverData[riverName].obstacle[zoneNames[2].displayName]
    else --why is this all changed now. why . why. it worked fine before and i knew how to use it. now i have no idea whats going on. Why are we doing 9 layers of recursive indexing. clearly its to appease the flying spaghetti monster or otheriwse i have no clue
        currentZone = assets.code.river.riverData[riverName].obstacle[zoneNames.displayName]
    end
    

    if transitionZone  then --if we are in a transition
        riverCurrentSpeed = quindoc.runIfFunc(currentZone.current,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.current,0)*transitionPercent
    elseif currentZone.current then --just set the snow amount to what it needs to be
        riverCurrentSpeed = quindoc.runIfFunc(currentZone.current,p) or 100
    else
        riverCurrentSpeed = 0--well at least it works 
    end
    
    return riverCurrentSpeed
end

--i better kiss this file goodbye before dante finds it and deports it to a random file folder i will spend 27,000 years searching for

--please dante write a documentation or soemthing so i know what functions there are
--it would have saved me approx ~3000000 braincells and a miniature mental breakdown
--as you know my brain was fully developed at 12 years old so i struggle to find where anything is
--help
--ok end of rant thank you