--[[
    First basic
]]


local devMenu = {}
local backdoors = {}
local moving = {
    move = false,
    ox = 0,
    oy = 0,
}


local avalible = love.filesystem.getDirectoryItems("code/backdoors")
local backdoorMenu = {
    title = "Built-In Backdoor!",
    x = 0, y = 0, sx = 0, sy = 0,
}

function backdoorMenu.load(x, y)
    backdoorMenu.x = x or 25
    backdoorMenu.y = y or 50
    backdoorMenu.sx = 175
    backdoorMenu.sy = #avalible*25 + 25
end

function backdoorMenu.getTransform()
    return {x = backdoorMenu.x, y = backdoorMenu.y, sx = backdoorMenu.sx, sy = backdoorMenu.sy, title = backdoorMenu.title}
end

function backdoorMenu.move(x, y)
    backdoorMenu.x = x
    backdoorMenu.y = y
end


function backdoorMenu.click(x, y, button)
    if button == 1 then
        for i = 1,#avalible do
            if x > 0 and x < backdoorMenu.sx then
                if y > (i-1)*25 and y < i*25 then
                    table.insert(backdoors, 1, require("code/backdoors/" .. string.sub(avalible[i], 0, -5)))
                    backdoors[1].load()
                end
            end
        end
    end
end



function backdoorMenu.draw()
    local mx, my = love.mouse.getPosition()
    local mx = mx - backdoorMenu.x
    local my = my - backdoorMenu.y

    for i = 1,#avalible do
        if mx > 0 and mx < backdoorMenu.sx then
            if my > (i-1)*25 and my < i*25 then
                love.graphics.setColor(1,1,1,0.2)
                love.graphics.rectangle("fill", backdoorMenu.x + 5, backdoorMenu.y + (i-1)*25 + 5, backdoorMenu.sx - 10, 15, 5)
            end
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(string.sub(avalible[i], 0, -5), backdoorMenu.x + 10, backdoorMenu.y + (i-1)*25 + 5)
    end
end





function devMenu.keypressed(key)
    if key == "d" then
        table.insert(backdoors, backdoorMenu)
        backdoorMenu.load()
    end
end

function devMenu.mousepressd(x, y, button)
    for i = 1,#backdoors do
        local transform = backdoors[i].getTransform()
        if x > transform.x and x < transform.x + transform.sx then
            if y > transform.y - 25 and y < transform.y + transform.sy then
                local remove = false

                if y > transform.y then
                    if backdoors[i].click then
                        backdoors[i].click(x - transform.x , y - transform.y, button)
                    end
                else
                    if x > transform.x + transform.sx - 25 then
                        table.remove(backdoors, i)
                        remove = true
                    else
                        --Move
                        moving.move = true
                        moving.ox = transform.x - x
                        moving.oy = transform.y - y
                    end
                end

                if not remove then
                    local temp = backdoors[i]
                    table.remove(backdoors, i)
                    table.insert(backdoors, 1, temp)
                end

                break
            end
        end
    end
end

function devMenu.update()
    if moving.move then
        if love.mouse.isDown(1) then
            local mx, my = love.mouse.getPosition()

            backdoors[1].move(mx + moving.ox, my + moving.oy)
        else
            moving.move = false
        end    
    end
end

function devMenu.draw()
    for i = #backdoors,1, -1 do
        local transform = backdoors[i].getTransform()

        love.graphics.setColor(0,0,0.5,0.5)

        if i == 1 then
            love.graphics.setColor(0.2, 0.2, 0.8, 0.5)
        end
        love.graphics.rectangle("fill", transform.x, transform.y - 25, transform.sx, transform.sy, 10)

        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", transform.x, transform.y - 25, transform.sx, transform.sy, 10)
        love.graphics.line(transform.x, transform.y, transform.sx + transform.x, transform.y)

        love.graphics.print(transform.title, transform.x + 5, transform.y-20)
        love.graphics.printf("x", transform.x - 5, transform.y-20, transform.sx, "right")

        backdoors[i].draw()
    end
end




return devMenu