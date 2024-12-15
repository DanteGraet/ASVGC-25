local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    if river:IsInBounds(x, y) then
        return {53/255,81/255,147/255}
    end

    return colour
end

return GetColourAt