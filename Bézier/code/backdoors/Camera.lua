local gen = {
    title = "Camera",
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

    local cam = getCamera()

    love.graphics.print("X: " .. cam.x, gen.x + 10, gen.y + 5)
    love.graphics.print("Y: " .. cam.y, gen.x + 10, gen.y + 20)
    love.graphics.print("Scale: " .. cam.scale, gen.x + 10, gen.y + 35)
end

return gen