tweens = {}

function tweens.linear(pos1, pos2, percent)
    local diff = pos1 - pos2
    return pos1 + diff*percent
end

function tweens.sineInOut(pos1, pos2, percent)
    local diff = pos1 - pos2
    local amt = (math.sin((percent-0.5)*math.pi))/2+0.5
    return pos1 + amt*pos2
end

function tweens.sineOut(pos1, pos2, percent)
    local diff = pos1 - pos2
    local amt = (math.sin((percent/2)*math.pi))
    return pos1 + amt*pos2
end

function tweens.sineIn(pos1, pos2, percent)
    local diff = pos1 - pos2
    local amt = (math.sin((percent-1)*math.pi/2))+1
    return pos1 + amt*pos2
end

return tweens