local camera = {}

river = require("code.river")
local devMenu = require("code.builtInBackdoor")

require("code.obstacle.obstacle")
require("code.obstacle.rock")
require("code.obstacle.spawner")


obsticals = {}


world = love.physics.newWorld(0, 0, false)
world:setCallbacks( beginContact, endContact, preSolve, postSolve )

local function load()
    love.physics.setMeter(100)


    local rockKeyframes = {
        ["0"] =         {timer = 1, lerp = tweens.sineInOut}, 
        ["1000000"] =   {timer = 1, lerp = tweens.sineInOut}
    }
    obstacleSpawner = ObstacleSpawner:New()
    obstacleSpawner:AddSpawner(rockObstical, rockKeyframes)

    love.math.setRandomSeed(os.time(), love.timer.getTime())

    camera = require("code/camera")
    river.load()
end



local function keypressed(key)
    if DEV then
        devMenu.keypressed(key)
    end
end

local function mousepressed(x, y, button)
    if DEV then
        devMenu.mousepressd(x, y, button)
    end
end



local function update(dt)

    camera.update(dt)
    local camY = getCamera().y




    river.update(dt)
    obstacleSpawner:Update(camY)


    world:update(dt)



    local contacts = world:getContacts()

    for _, contact in ipairs(contacts) do
        local fixtureA, fixtureB = contact:getFixtures()  -- Get the two fixtures involved
        local dataA = fixtureA:getUserData()
        local dataB = fixtureB:getUserData()
        if  dataA.first then
            dataA.remove = true
            fixtureA:setUserData(dataA)
        elseif dataB.first then
            dataB.remove = true
            fixtureB:setUserData(dataB)
        end
    end

    for i = #obsticals,1, -1 do
        obsticals[i]:Update(camY, i)
    end


    if devMenu then
        devMenu.update()
    end
end


local function draw()
    love.graphics.setBackgroundColor(67/255, 78/255, 175/255)
    love.graphics.translate(camera.x, camera.y)
    
    river.draw()

    for i = 1,#obsticals do
        obsticals[i]:Draw()

        obsticals[i]:DrawHitbox()
    end


    love.graphics.reset()

    if devMenu then
        devMenu.draw()
    end
end

--[[

 888888ba  dP                         oo                       a88888b.          dP dP dP                         dP                
 88    `8b 88                                                 d8'   `88          88 88 88                         88                
a88aaaa8P' 88d888b. dP    dP .d8888b. dP .d8888b. .d8888b.    88        .d8888b. 88 88 88d888b. .d8888b. .d8888b. 88  .dP  .d8888b. 
 88        88'  `88 88    88 Y8ooooo. 88 88'  `"" Y8ooooo.    88        88'  `88 88 88 88'  `88 88'  `88 88'  `"" 88888"   Y8ooooo. 
 88        88    88 88.  .88       88 88 88.  ...       88    Y8.   .88 88.  .88 88 88 88.  .88 88.  .88 88.  ... 88  `8b.       88 
 dP        dP    dP `8888P88 `88888P' dP `88888P' `88888P'     Y88888P' `88888P8 dP dP 88Y8888' `88888P8 `88888P' dP   `YP `88888P' 
                         .88                                                                                                        
                     d8888P                                                                                                         
]]

local function beginContact(a, b, coll)

end


return {
    load = load,
    keypressed = keypressed,
    mousepressed = mousepressed,
    update = update,
    draw = draw,

    beginContact = beginContact
}