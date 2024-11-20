function playSound(sound)
    local tempSound = sound:clone()
    tempSound:setPitch(math.random(95, 105)/100)
    
    tempSound:play()
end