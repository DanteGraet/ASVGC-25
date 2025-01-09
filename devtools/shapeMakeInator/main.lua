require("templateLib/dante")
require("templateLib/quindoc")


local lastSaves = {}
local fileName = "" 

local image
local scale = 1
local targetSize = 500

local colourMode = 1

local colours = {
    {
        point = {1,1,1},
        line = {0,1,0},
        joint = {1,0,0},
    },
    {
        point = {0,1,1},
        line = {0,0,1},
        joint = {1,1,0},
    }
}

local selectedPoint = {
    pos = 0,
    ox = 0,
    oy = 0,
}

local hyperLog = {}


function love.load()
    lastSaves = dante.load("hitboxes") or {}
    table.insert(hyperLog, {"loaded save", 3})
end


function love.filedropped(file)
    fileName = file:getFilename()

    fileName = fileName:gsub("\\", "/")
    
    -- load as image, form love2d wiki
    local ext = fileName:match("%.%w+$")

	if ext == ".png" then
		file:open("r")
		local fileData = file:read("data")
		local img = love.image.newImageData(fileData)
		image = love.graphics.newImage(img)

        scale = 1

        scale = targetSize/image:getWidth()
        if targetSize/image:getHeight() < scale then
            scale = targetSize/image:getHeight()
        end

        if not lastSaves[fileName] then
            lastSaves[fileName] = {
                type = "polygon",
                data = {}
            }
        end

        table.insert(hyperLog, {"loaded file", 5})

	end
end

function love.quit()
    dante.save(lastSaves, nil, "hitboxes")
end


function love.wheelmoved(x, y)
    scale = quindoc.clamp(scale + y/10, 0.1, 100)
    table.insert(hyperLog, {"set scale: " .. scale, 1})

end


function love.mousepressed(mx, my, button)
    if lastSaves[fileName] and image and button == 1 then
        local points = lastSaves[fileName].data
        local clicked = false
        for i = 1,#points, 2 do
            if quindoc.dist(points[i]*scale, points[i+1]*scale, mx - love.graphics.getWidth()/2, my - love.graphics.getHeight()/2) <= 10 then

                clicked = true

                selectedPoint.pos = i
                selectedPoint.ox = 0--points[i]*scale - mx
                selectedPoint.oy = 0--points[i+1]*scale - my
                table.insert(hyperLog, {"moving node " .. i/2 , 1})

                break
            end
        end

        if not clicked then
            table.insert(lastSaves[fileName].data, quindoc.round((mx - love.graphics.getWidth()/2) /scale))
            table.insert(lastSaves[fileName].data, quindoc.round((my - love.graphics.getHeight()/2) /scale))

            selectedPoint.pos = #lastSaves[fileName].data - 1
            selectedPoint.ox = 0
            selectedPoint.oy = 0

            table.insert(hyperLog, {"added node", 1})

        end
    end

    if button == 2 then
        local points = lastSaves[fileName].data
        for i = 1,#points, 2 do
            if quindoc.dist(points[i]*scale, points[i+1]*scale, mx - love.graphics.getWidth()/2, my - love.graphics.getHeight()/2) <= 10 then
                table.remove(lastSaves[fileName].data, i)
                table.remove(lastSaves[fileName].data, i)
                table.insert(hyperLog, {"removed node " .. i/2, 1})

                break
            end
        end
    end
end


function love.update(dt)
    if selectedPoint.pos > 0 then
        if not love.mouse.isDown(1) then
            selectedPoint.pos = 0
        else
            local points = lastSaves[fileName].data

            points[selectedPoint.pos] = quindoc.round((love.mouse.getX() + selectedPoint.oy - love.graphics.getWidth()/2)/scale)
            points[selectedPoint.pos+1] = quindoc.round((love.mouse.getY() + selectedPoint.oy - love.graphics.getHeight()/2)/scale)

        end
    end

    for i = #hyperLog,1,-1 do
        hyperLog[i][2] = hyperLog[i][2] - dt
        if hyperLog[i][2] < 0 then
            table.remove(hyperLog, i)
        end
    end
end

function dataToUsableString()
    local str = ""
    for i = 1,#lastSaves[fileName].data do
        str = str .. lastSaves[fileName].data[i] .. ", "
    end

    return string.sub(str, 0, #str - 2)
end

function love.keypressed(key)
    if key == "o" then
        love.system.openURL(love.filesystem.getAppdataDirectory( ) .. "/LOVE/" .. love.filesystem.getIdentity() .. "/hitboxes.lua")
        table.insert(hyperLog, {"opend save file", 7})

    elseif key == "s" then
        dante.save(lastSaves, nil, "hitboxes")
        table.insert(hyperLog, {"saved shapes (o to open file)", 7})

    elseif key == "c" then
        love.system.setClipboardText( dataToUsableString() )
        table.insert(hyperLog, {"coppied shape", 7})

    end
end

function love.draw()
    if lastSaves[fileName] and image then
        local type = lastSaves[fileName].type or "nil???"
        love.graphics.print(
            love.filesystem.getAppdataDirectory( ) .. "/LOVE/" .. love.filesystem.getIdentity() .. "/hitboxes.lua" ..  "\n" .. 
            "File: " .. fileName .. 
            "\nType: " .. type .. 
            "\nScale: " .. scale
        )
        love.graphics.draw(image, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, scale, scale, image:getWidth()/2, image:getHeight()/2)


        love.graphics.setColor(colours[colourMode].point)
        for i = 1,#lastSaves[fileName].data, 2 do

            love.graphics.circle("line", lastSaves[fileName].data[i]*scale + love.graphics.getWidth()/2, lastSaves[fileName].data[i+1]*scale + love.graphics.getHeight()/2, 10)
        end

        
        love.graphics.setColor(colours[colourMode].line)
        for i = 1,#lastSaves[fileName].data-2, 2 do
            love.graphics.line(lastSaves[fileName].data[i]*scale + love.graphics.getWidth()/2, lastSaves[fileName].data[i+1]*scale + love.graphics.getHeight()/2, lastSaves[fileName].data[i+2]*scale + love.graphics.getWidth()/2, lastSaves[fileName].data[i+3]*scale + love.graphics.getHeight()/2)
        end

        love.graphics.setColor(colours[colourMode].joint)
        if #lastSaves[fileName].data > 3 then
            local i = #lastSaves[fileName].data - 1
            love.graphics.line(lastSaves[fileName].data[i]*scale + love.graphics.getWidth()/2, lastSaves[fileName].data[i+1]*scale + love.graphics.getHeight()/2, lastSaves[fileName].data[1]*scale + love.graphics.getWidth()/2, lastSaves[fileName].data[2]*scale + love.graphics.getHeight()/2)
        end


        love.graphics.setColor(1,1,1)

    else
        love.graphics.printf("drag and drop image (yes i found out how to do that) to start", love.graphics.getWidth()/2 - 125, love.graphics.getHeight()/2- 15, 250, "center")
    end


    love.graphics.printf("drag and drop image \nclick to add points \nclick and drag to move points \ns to save \nc to copy current shape \no to open file \nright click to delete", 0, 0, love.graphics.getWidth(), "right")

    local log = ""
    for i = #hyperLog, 1, -1 do
        log = log .. "\n" .. hyperLog[i][1] .. " (" .. hyperLog[i][2] .. ")"
    end

    love.graphics.print(log, 0, love.graphics.getHeight() - love.graphics.getFont():getHeight()*(#hyperLog+1))
end