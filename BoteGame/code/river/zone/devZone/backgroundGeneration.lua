local function GetColourAt(x, y)
    local colour = {0,1,1}

    if getDistToEdge and getDistToEdge(x, y) > 0 then
        return {0,0,1}
    end

    return colour
end

return GetColourAt



