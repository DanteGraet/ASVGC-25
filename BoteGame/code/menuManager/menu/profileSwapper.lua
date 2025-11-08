local profileSwapper = {}
local data = {}

local width = 900
local height = 500

profileSwapper.width = width
profileSwapper.height = height
profileSwapper.transitionIn = 0


function profileSwapper.load()
    data = {}
    local bg = {}
    bg.image = love.graphics.newImage("image/nineSliceTest.png")
    bg.x = -width/2
    bg.y = -height/2
    bg.sx = width
    bg.sy = height
    bg.cornerSize = 10

    local nineSlice = graetUI:getComponent("nineSliceGraphic")
    data.background = nineSlice:new(bg.image, bg.x, bg.y, bg.sx, bg.sy, bg.cornerSize)
    data.closing = false
    
    data.yOffset = 0 


end

function profileSwapper.update(dt)
    if data.closing then
        profileSwapper.transitionIn = math.max(profileSwapper.transitionIn - dt*2, 0)
    else
        profileSwapper.transitionIn = math.min(profileSwapper.transitionIn + dt*2, 1) 
    end

    local sine = tweens.sineOut(profileSwapper.transitionIn)
    data.yOffset = 1000 - sine*1000

    if data.closing == true and profileSwapper.transitionIn == 0 then
        profileSwapper.remove = true
    end
end

function profileSwapper.startClose()
    data.closing = true
end

function profileSwapper.draw()
    data.background:draw(0, 0 + data.yOffset)
end

return profileSwapper
