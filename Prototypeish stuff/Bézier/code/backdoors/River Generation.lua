local gen = {
    title = "River Generation",
    x = 0, y = 0, sx = 0, sy = 0,
}

function gen.load(x, y)
    gen.x = x or 225
    gen.y = y or 50
    gen.sx = 200
    gen.sy = 85
end

function gen.getTransform()
    return {x = gen.x, y = gen.y, sx = gen.sx, sy = gen.sy, title = gen.title}
end

function gen.move(x, y)
    gen.x = x
    gen.y = y
end


function gen.draw()
    local mx, my = love.mouse.getPosition()
    local mx = mx - gen.x
    local my = my - gen.y

    local river = getRiverData()

    for i = 1,#river do
        love.graphics.print("Channel " .. i, gen.x + (i-1)*100 + 10, gen.y + 5)

        for j = 1,#river[i] do
            love.graphics.print(#river[i][j], gen.x + (i-1)*100 + 10, gen.y + 5 + 15*j)
        end
    end
end

return gen