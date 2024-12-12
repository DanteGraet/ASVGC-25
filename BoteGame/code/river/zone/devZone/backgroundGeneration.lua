local function GetColourAt(x, y)
    local colour = {0,1,1}

    if river:IsInBounds(x, y) then
        return {0,0,1}
    end

    return colour
end

return GetColourAt