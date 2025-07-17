local d = {
    timer = 0,
    stack = {},
    current = nil,
    time = 0,
}

function d.schedule(image, time)
    if type(image) == "string" then
        image = love.graphics.newImage(image)
    end
    table.insert(d.stack, {image, time})
    if d.timer <= 0 then
        d.next()
    end
end

function d.next(allowRemove)

    d.timer = 0
    local next = d.stack[1]
    if next then
        d.current = next[1]
        d.time = next[2]

        table.remove(d.stack, 1)
    elseif allowRemove then
        d.time = 0
        d.current = nil
    end
end

function d.update(dt)
    if d.current then
        d.timer = d.timer + dt

        if d.timer > d.time then
            d.next(true)
        end
    end
end


function d.draw()
    if d.current and d.timer > 0 then
        local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
        local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

        local y = 1080 + soy
        local x = 1920 + sox

        local oy = 0
        if d.timer < 1 then
            oy = tweens.sineInOut(1-d.timer)*500
        end

        if d.timer > d.time-1 then
            oy = tweens.sineInOut(1- (d.timer-d.time))*500
        end
        love.graphics.draw(d.current, x, y+oy, 0, 1, 1, d.current:getWidth(), d.current:getHeight())
    end
end


return d