local speed = 100

local camera = {
    x = 0,
    y = 0,
}

function camera.update(dt)
    if cameraUnlocked then
        local mult = 10
        if love.keyboard.isDown("lshift") then
            mult = mult * 5
        end
        if love.keyboard.isDown("lctrl") then
            mult = mult * 10
        end

        if love.keyboard.isDown("up") then
            camera.y = camera.y + mult*dt*10
        end
        if love.keyboard.isDown("down") then
            camera.y = camera.y - mult*dt*10
        end
    end

    --eventually lock to the players y 
    if not noAutoScroll then
        camera.y = camera.y + speed * dt
    end
end

return camera