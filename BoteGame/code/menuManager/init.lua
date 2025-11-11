local menuManager = {}
local openMenus = {}

function menuManager.openMenu(menuName)
    for i = 1,#openMenus do
    if openMenus[i].name == menuName then
            print("menu '" .. menuName .. "'' already open")
            return
        end
    end

    local newMenu = love.filesystem.load("code/menuManager/menu/" .. menuName .. ".lua")()
    quindoc.runIfFunc(newMenu.load)

    newMenu.name = menuName
    table.insert(openMenus, 1, newMenu)
end

function menuManager.closeMenu(menuName)
    local currentMenu = 1

    for i = 1,#openMenus do
        if openMenus[i].name == menuName then
            currentMenu = i
            break
        end
    end

    openMenus[currentMenu].startClose()
end

function menuManager.isMenuOpen()
    return #openMenus >= 0
end

function menuManager.mousepressed(mx, my, button)
    if #openMenus <= 0 then
        return false
    end
    local menu = openMenus[1]
    if mx > -menu.width/2 and mx < menu.width/2 and my > -menu.height/2 and my < menu.height/2 then
        openMenus[1].ui:toggleClick(true, "Menu")
    else
        menu.startClose()
    end

    return true
end

function menuManager.mousereleased(mx, my, button)
    if #openMenus <= 0 then
        return false
    end

    if openMenus[1].ui then
        openMenus[1].ui:toggleClick(false, "Menu")
    end

    return true
end


function menuManager.update(dt)
    for i = #openMenus, 1, -1 do
        if openMenus[i].update  then
            openMenus[i].update(dt)

            if openMenus[1].ui then
                openMenus[1].ui:update(dt)
            end

            if openMenus[i].remove then
                table.remove(openMenus, i)
            end
        end
    end
end

function menuManager.draw(targetWidth, targetHeight, offsetX, offsetY)
    -- draw a balck box??
    if #openMenus <= 0 then
        return
    end

    local transition = openMenus[#openMenus].transitionIn
    local fade = tweens.sineOut(transition or 0)/3

    love.graphics.setColor(0,0,0, fade)
    love.graphics.rectangle("fill", -offsetX, -offsetY, targetWidth + offsetX*2, targetHeight + offsetY*2)

    love.graphics.setColor(1,1,1,1)
    for i = #openMenus, 1, -1 do
        openMenus[i].draw()
        if openMenus[i].ui then
            openMenus[i].ui:draw()
        end
    end
end

return menuManager