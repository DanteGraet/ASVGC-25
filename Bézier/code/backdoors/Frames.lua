local gen = {
    title = "Frames",
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

    love.graphics.print("Seed: " .. love.math.getRandomSeed(), gen.x + 10, gen.y + 5 + 15*2)
    love.graphics.print("FPS: " .. love.timer.getFPS(), gen.x + 10, gen.y + 5 + 15)
    love.graphics.print("Delta Time: " .. quindoc.round(love.timer.getDelta(), 5), gen.x + 10, gen.y + 5)


end

return gen