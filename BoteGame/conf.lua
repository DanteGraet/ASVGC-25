VERSION = "V0.1"
DEV = false  

lockedAspectRatio = true
screenBarColour = {0,0,0}

function love.conf(t)
    t.title = "Bouyant Voyage " .. VERSION
    t.window.icon = "image/icon/icon256.png"

    t.window.width = 1920/2
    t.window.height = 1080/2

    t.window.resizable = true
    t.console = DEV
end