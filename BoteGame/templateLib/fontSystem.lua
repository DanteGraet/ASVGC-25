local f = {}

local fonts = {}
local fontLookUp = {}

local lastFontSize = 32
local lastFontName = ""

function f.loadFont(location, name)
    fontLookUp[name] = location
end

function f.setFont(name, size)
    local name = name
    local size = size

    
    if type(name) == "table" then
        size = name[2] or lastFontSize

        name = name[1] or lastFontName
    end

    if not size then size = lastFontSize end
    if not name then name = lastFontName end

    if not fonts[name] then
        if fontLookUp[name] then
            fonts[name] = {}
        else
            return
        end
    end

    if not fonts[name][size] then
        fonts[name][size] = love.graphics.newFont(fontLookUp[name], tonumber(size))
    end

    love.graphics.setFont(fonts[name][size])

    lastFontSize = size
    lastFontName = name
end


function f.getFont(name, size)
    local name = name
    local size = size
    
    if type(name) == "table" then
        size = name[2] or lastFontSize
        name = name[1] or lastFontName
    end

    if not size then return nil end
    if not name then return nil end

    if not fonts[name] then
        if fontLookUp[name] then
            fonts[name] = {}
        else
            return
        end
    end

    if not fonts[name][size] then
        fonts[name][size] = love.graphics.newFont(fontLookUp[name], tonumber(size))
    end


    love.graphics.setFont(fonts[name][size])
    return fonts[name][size]
end


return f