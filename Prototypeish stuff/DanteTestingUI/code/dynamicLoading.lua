assets = {}

require("code.parallaxImage")

DynamicLoading = {}
DynamicLoading.__index = DynamicLoading

function DynamicLoading:New(toLoad, parallaxImage, autoRun) -- data is a table {{image/path, layer}}
    local obj = setmetatable({}, DynamicLoading)

    obj.image = ParallaxImage:New(1920, 1080, parallaxImage)
    obj.image.hovering = 1

    local chunk, err = love.filesystem.load(toLoad)
    if chunk then
        local success, loadList = pcall(chunk)
        if success then
            obj.loadList = loadList
        end
    end

    if autoRun then
        if obj:Run() == "QUIT" then
            love.event.quit()
        end
    else
        return obj
    end
end


function DynamicLoading:Run()
    local loadedList = {}

    for i = 1,#self.loadList do
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

        local path = {}
        for match in string.gmatch(self.loadList[i], "[^/]+") do
            table.insert(path, match)
        end

        self:AddItem(path, assets, self.loadList[i])

        self:Draw(i/#self.loadList, self.loadList[i])
    end

    print("\n============ Loaded Assets ============")
    dante.printTable(assets)
end

function DynamicLoading:AddItem(path, current, original)
    if #path == 1 then
        local file = path[#path]
        if file:match("%.png$") then
            current[string.sub(file, 1, #file-4)] = love.graphics.newImage(original)
            print("Loaded Image " .. string.sub(file, 1, #file-4) .. " (" .. original .. ")")
        elseif file:match("%.mp3$") then
            current[string.sub(file, 1, #file-4)] = love.graphics.newImage(original)
            print("Loaded Sound " .. string.sub(file, 1, #file-4) .. " (" .. original .. ")")
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
    love.graphics.clear()

    local screenScale = love.graphics.getWidth()/1920
    if love.graphics.getHeight()/1080 > screenScale then
        screenScale = love.graphics.getHeight()/1080
    end

    love.graphics.scale(screenScale)
    self.image:Draw(love.graphics.getWidth()/screenScale/2 - 960, love.graphics.getHeight()/screenScale/2 - 540, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
    
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

    love.graphics.present()
end