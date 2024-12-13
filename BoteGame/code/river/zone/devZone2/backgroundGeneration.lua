local function GetColourAt(x, y)
    local colour = {0,1,0}

    if river:IsInBounds(x, y) then
        return {1,0,0}
    end

    return colour
end

return GetColourAt