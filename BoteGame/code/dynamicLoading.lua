DynamicLoading = {}
DynamicLoading.__index = DynamicLoading

local dt = 1/10
local timer = 0
local angle = -0.1
local ox = 0
local oy = 0

local loadPercentage = 0

function DynamicLoading:New(toLoad, autoRun, image, colour) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, DynamicLoading)
    loadPercentage = 0
    obj.image = love.graphics.newImage(image or "image/loading.png")
    --obj.image = ParallaxImage:New(1920, 1080, parallaxImage)
    --obj.image.hovering = 1

    --[[local chunk, err = love.filesystem.load(toLoad)
    if chunk then
        local success, loadList = pcall(chunk)
        if success then
            obj.loadList = loadList
        end
    end]]

    self.colour = colour or {0,0,0}

    obj:Draw(0, 0)

    ---collectgarbage("collect")

    if autoRun then
        if obj:Run() == "QUIT" then
            love.event.quit()
        end
    end

    timer = 0

    return obj

end


function DynamicLoading:Run()
    local loadedList = {}

    -- fade transition in the thing
    if previousGameState == "" then
        loadPercentage = 1
        if love.timer then dt = love.timer.step() end
        self:Update(dt)
        love.graphics.clear()
        self:Draw()
        if love.timer then love.timer.sleep(0.001) end
    else
        while loadPercentage < 1 do
            if love.timer then dt = love.timer.step() end
            self:Update(dt)
            loadPercentage = math.min(loadPercentage + dt, 1)
    
            love.graphics.clear()
            love.draw(true)
            self:Draw()
            if love.timer then love.timer.sleep(0.001) end
        end
    end

    
    if previousGameState ~= ""  then
        if previousGameState == "GetWreked" then
            previousGameState = gameState
        end
        --Unload old "garbage"
        print("code/gameStateLoading/" .. previousGameState .. "Loading.lua")
        self.unloadList = love.filesystem.load("code/gameStateLoading/" .. previousGameState .. "Loading.lua")()
        local i = 1
        --for i = 1,#self.loadList do

        -- use a while loop so we can expand the load list while we are loading
        while i <= #self.unloadList do
            -- Process events, taken from the wiki
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return "QUIT"
                        end
                    end
                    love.handlers[name](a,b,c,d,e,f)
                end
            end

            if type(self.unloadList[i]) == "function" then
            else
                local path = {}
                for match in string.gmatch(self.unloadList[i][1], "[^/]+") do
                    table.insert(path, match)
                end

                self:removeItem(path, assets)
            end


            if love.timer then dt = love.timer.step() end
            self:Update(dt)

            love.graphics.clear()
            self:Draw()

            i = i + 1
            if love.timer then love.timer.sleep(0.001) end
        end
    end

    if game[previousGameState or gameState] and game[previousGameState or gameState].unload then
        game[previousGameState or gameState].unload()
    end


    self.loadList = love.filesystem.load("code/gameStateLoading/" .. gameState .. "Loading.lua")()
    local i = 1
    --for i = 1,#self.loadList do

    -- use a while loop so we can expand the load list while we are loading
    while i <= #self.loadList do
        -- Process events, taken from the wiki
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return "QUIT"
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

        if type(self.loadList[i]) == "table" then
            local path = {}
            for match in string.gmatch(self.loadList[i][1], "[^/]+") do
                table.insert(path, match)
            end

            self:AddItem(path, assets, self.loadList[i])
        elseif type(self.loadList[i]) == "function" then
            self.loadList[i]()
        end

        if love.timer then dt = love.timer.step() end
        self:Update(dt)

        love.graphics.clear()
        --love.draw(true)
        self:Draw()

        i = i + 1
        if love.timer then love.timer.sleep(0.001) end
    end

    game[gameState].extraLoad()
    game[gameState].update(dt)


    print("\n============ Loaded Assets ============")
    --dante.printTable(assets)

    --fade out of the transition
    while loadPercentage < 2 do
        if love.timer then dt = love.timer.step() end
        self:Update(dt)
        loadPercentage = math.min(loadPercentage + dt, 2)
        
        love.graphics.clear()
        love.draw()
        self:Draw()
        if love.timer then love.timer.sleep(0.001) end
    end

    if love.timer then dt = love.timer.step() end
    self:Update(dt)

    love.graphics.clear()
    love.draw()
    if love.timer then love.timer.sleep(0.001) end
end

function DynamicLoading:Update(dt)
    timer = timer + (dt*math.pi)/10
    ox = ox - dt*24 -- dt*(100*math.sin(timer) + 200)/10

    --oy = oy - dt*(100*math.cos(timer))/10
    if loadPercentage == 1 then
        ox = ox % self.image:getWidth()
        oy = oy % self.image:getHeight()
    end
end

function DynamicLoading:AddItem(path, current, original)
    if #path == 1 then
        local file = path[#path]

        if file:match("%.png$") then
            current[string.sub(file, 1, #file-4)] = love.graphics.newImage(original[1])
            print("Loaded Image " .. string.sub(file, 1, #file-4) .. " (" .. original[1] .. ")")

            if original[2] == "blur" then
                current[string.sub(file, 1, #file-4)]:setFilter("linear", "linear")

            else
                current[string.sub(file, 1, #file-4)]:setFilter("nearest", "nearest")
            end

        elseif file:match("%.mp3$") then
            --current[string.sub(file, 1, #file-4)] = love.graphics.newImage(original[1])
            current[string.sub(file, 1, #file-4)] = love.audio.newSource(original[1], original[2])

            print("Loaded Sound " .. string.sub(file, 1, #file-4) .. " (" .. original[1] .. ")")

        elseif file:match("%.lua$") then
            if original[2] == "run" then
                if original[3] then
                    current[original[3]] = love.filesystem.load(original[1])()
                else
                    if love.filesystem.getInfo(original[1], "file") then
                        current[string.sub(file, 1, #file-4)] = love.filesystem.load(original[1])()
                    end
                end
            else
                current[string.sub(file, 1, #file-4)] = love.filesystem.load(original[1])

                if original[2] == "addObstacles" then
                    local c = current[string.sub(file, 1, #file-4)]()
                    for i = 1,#c do
                        for name, _ in pairs(c[i].data) do
                            table.insert(self.loadList, #self.loadList+1, {"obstacle/" .. name .. ".lua", "run"})
                        end
                    end
                end
            end

            --print("Loaded Script " .. string.sub(file, 1, #file-4) .. " (" .. original[1] .. ")")
        elseif file:match("%.ttf$") then
            current[string.sub(file, 1, #file-4)..original[2] or "32"] = love.graphics.newFont(original[1],original[2] or 32)
        end
        
    else
        if not current[path[1]] then
            current[path[1]] = {}
        end
        local nextCurrent = current[path[1]]
        table.remove(path, 1)

        self:AddItem(path, nextCurrent, original)
    end
end

function DynamicLoading:removeItem(path, current)
    if #path == 1 then
        local file = path[#path]
        current[string.sub(file, 1, #file-4)] = nil        
    else
        if not current[path[1]] then
            current[path[1]] = {}
        end
        local nextCurrent = current[path[1]]
        table.remove(path, 1)

        self:removeItem(path, nextCurrent)
    end
end


function DynamicLoading:Draw(percentage, current)
    love.graphics.origin()


    local screenScale = love.graphics.getWidth()/1920
    if love.graphics.getHeight()/1080 > screenScale then
        screenScale = love.graphics.getHeight()/1080
    end

    love.graphics.scale(screenScale)
    local width = love.graphics.getWidth()/screenScale
    local height = love.graphics.getHeight()/screenScale


    local a = 1
    if loadPercentage < 0.5 then
        a = tweens.sineIn(loadPercentage*2)
    elseif loadPercentage > 1.5 then
        a = tweens.sineOut((2- loadPercentage)*2)
    end
    love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], a)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor({1,1,1})
    love.graphics.rotate(angle)



    local trigWidth = width * math.cos(-angle) - height * math.sin(-angle)--math.cos(angle + startAngle/2)*legnth
    local trigHeight = width * math.sin(-angle) + height * math.cos(-angle)--math.sin(angle + startAngle/2)*height 

    love.graphics.setColor(1,1,1,1)


    for x = math.sin(angle)*height -50 - ox , trigWidth + 100, self.image:getWidth() do
        for y = -(math.cos(angle)*width + math.cos(angle)*height) -50 - oy, trigHeight + 100 -oy, self.image:getHeight() do
            if loadPercentage <= 1 then
                love.graphics.draw(self.image, x + (trigWidth + self.image:getWidth()*3)*tweens.sineOut(loadPercentage) - (trigWidth+ self.image:getWidth()*3), y) 
            else
                love.graphics.draw(self.image, x + (trigWidth + self.image:getWidth()*3)*tweens.sineIn(1-loadPercentage), y) 
            end
        end
    end


    love.graphics.origin()
    love.graphics.scale(screenScale)

    font.setFont("black", 64)
    local step = 10
    local dist = 5
    local suf = ""
    for i = 1, (timer*10)%4 do
        suf = suf .. "."
    end
    love.graphics.setColor(0,0,0, a)
    for i = 0,359, step do
        
        local angle = math.rad(i)
        local x = 16 + math.cos(angle)*dist
        local y = height - 100 + math.sin(angle)*dist
        love.graphics.print("Loading" .. suf, x, y)
    end
    love.graphics.setColor(1,1,1, a)
    love.graphics.print("Loading".. suf, 16, height-100)

    love.graphics.setColor(1,1,1, 1)


    --[[self.image:Draw(love.graphics.getWidth()/screenScale/2 - 960, love.graphics.getHeight()/screenScale/2 - 540, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
    
    love.graphics.origin()
    local uiScreenScale = love.graphics.getWidth()/1920
    if love.graphics.getHeight()/1080 < uiScreenScale then
        uiScreenScale = love.graphics.getHeight()/1080
    end

    love.graphics.scale(uiScreenScale)

    --draw loading bar here
    love.graphics.print(current)
    local barSizeX = 1000
    local barSizeY = 25
    local outline = 5

    local width = love.graphics.getWidth()/uiScreenScale
    local height = love.graphics.getHeight()/uiScreenScale

    love.graphics.setColor(0.2,0,0.3)
    love.graphics.rectangle("fill", width/2 - barSizeX/2 - outline, height - barSizeY*2 - outline, barSizeX + outline*2, barSizeY + outline*2, barSizeY/2)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", width/2 - barSizeX/2, height - barSizeY*2, barSizeY + (barSizeX-barSizeY)*percentage, barSizeY, barSizeY/2)

    ]]

    love.graphics.present()
end