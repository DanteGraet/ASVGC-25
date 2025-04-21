-- nobody told me how to grab the river current speed at a given point and it isnt like theres any documentation so then i had to write this function because im tired and dante moved everything and i can't figure out where anything is anymore so yeah i give up i just wanted to add a new river zone and then had to go down a 2 hour rabbit hole because all this stuff just didn't work anymore for some reason and i dont know why it was all touched but it stopped working and everythings moved so i don't have any idea how to fix it and i really don't know anymore my god.

function findRiverCurrent(p)

    local currentZone
    local transitionZone 
    local transitionPercent 

    if type(zones[1]) == "table" then
        currentZone = zones[1]
        transitionZone = zones[2] 
        transitionPercent = zones[3]
    else
        currentZone = zones
    end




    local riverCurrentSpeed

    if transitionZone then --if we are in a transition
        riverCurrentSpeed = quindoc.runIfFunc(currentZone.current,p)*(1-transitionPercent) + quindoc.runIfFunc(transitionZone.current,0)*transitionPercent

    elseif currentZone.current then --just set the snow amount to what it needs to be
        riverCurrentSpeed = quindoc.runIfFunc(currentZone.current,p) or 0
    else
        riverCurrentSpeed = 199
    end

    return riverCurrentSpeed
end