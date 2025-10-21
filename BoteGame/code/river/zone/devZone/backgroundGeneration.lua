local function GetColourAt(x, y, dist)
    local colour = {math.min(dist/100, 0.5) / 2,dist/1000,dist/500/ 2}

    

    return colour
end

return GetColourAt



