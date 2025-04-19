DynamicLoading = {}
DynamicLoading.__index = DynamicLoading

local dt = 1/10
local timer = 0
local angle = -0.1
local ox = 0
local oy = 0

local loadPercentage = 0

function DynamicLoading:New(toLoad, autoRun) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, DynamicLoading)
    loadPercentage = 0
    obj.image = love.graphics.newImage("image/loading.png")
    --obj.image = ParallaxImage:New(1920, 1080, parallaxImage)
    --obj.image.hovering = 1

    local chunk, err = love.filesystem.load(toLoad)
    if chunk then
        local success, loadList = pcall(chunk)
        if success then
            obj.loadList = loadList
        end
    end

    obj:Draw(0, 0)

    ---collectgarbage("collect")

    if autoRun then
        if obj:Run() == "QUIT" then
            love.event.quit()
        end
    end

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
        love.draw(true)
        self:Draw()

        i = i + 1
        if love.timer then love.timer.sleep(0.001) end
    end

    game[gameState].extraLoad()
    game[gameState].update(dt)

   --[[ while true do
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



        if love.timer then dt = love.timer.step() end
        self:Update(dt)

        self:Draw()
    end]]

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
end

function DynamicLoading:Update(dt)
    timer = timer + (dt*math.pi)/10
    ox = ox - dt*24 -- dt*(100*math.sin(timer) + 200)/10

    --oy = oy - dt*(100*math.cos(timer))/10

    ox = ox % self.image:getWidth()
    oy = oy % self.image:getHeight()


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
            current[string.sub(file, 1, #file-4)] = love.graphics.newImage(original[1])
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


function DynamicLoading:Draw(percentage, current)
    love.graphics.origin()


    local screenScale = love.graphics.getWidth()/1920
    if love.graphics.getHeight()/1080 > screenScale then
        screenScale = love.graphics.getHeight()/1080
    end

    love.graphics.scale(screenScale)
    love.graphics.rotate(angle)
    local width = love.graphics.getWidth()/screenScale
    local height = love.graphics.getHeight()/screenScale


    local trigWidth = width * math.cos(-angle) - height * math.sin(-angle)--math.cos(angle + startAngle/2)*legnth
    local trigHeight = width * math.sin(-angle) + height * math.cos(-angle)--math.sin(angle + startAngle/2)*height 

    love.graphics.setColor(1,1,1,1)


    for x = math.sin(angle)*height -50 - ox , trigWidth + 100, self.image:getWidth() do
        for y = -(math.cos(angle)*width + math.cos(angle)*height) -50 - oy, trigHeight + 100 -oy, self.image:getHeight() do
            if loadPercentage <= 1 then
                love.graphics.draw(self.image, x + (trigWidth)*tweens.sineOut(loadPercentage) - (trigWidth), y) 
            else
                love.graphics.draw(self.image, x + (trigWidth + self.image:getWidth()*3)*tweens.sineIn(1-loadPercentage), y) 
            end
        end
    end




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