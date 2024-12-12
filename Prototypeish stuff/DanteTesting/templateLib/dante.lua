--=======================================================================================================--
--                                                                                                       --
--      88888888ba,                                                     88                               --
--      88      `"8b                             ,d         _,.         88                               --
--      88        `8b                            88       ""'           88                               --
--      88         88  ,adPPYYba,  8b,dPPYba,  MM88MMM  ,adPPYba,       88  88       88  ,adPPYYba,      --
--      88         88  ""     `Y8  88P'   `"8a   88    a8P_____88       88  88       88  ""     `Y8      --
--      88         8P  ,adPPPPP88  88       88   88    8PP"""""""       88  88       88  ,adPPPPP88      --
--      88      .a8P   88,    ,88  88       88   88,   "8b,   ,aa  888  88  "8a,   ,a88  88,    ,88      --
--      88888888Y"'    `"8bbdP"Y8  88       88   "Y888  `"Ybbd8"'  888  88   `"YbbdP'Y8  `"8bbdP"Y8      --
--                                                                                                       --
--                                                                                                       --
--  ┌─┐┌─┐┬  ┬┬┌┐┌┌─┐   ┬  ┌─┐┌─┐┌┬┐┬┌┐┌┌─┐   ┌─┐┌┐┌┌┬┐  ┌─┐┌─┐┌┬┐┌─┐  ┌─┐┌┬┐┬ ┬┌─┐┬─┐  ┌─┐┌┬┐┬ ┬┌─┐┌─┐  --
--  └─┐├─┤└┐┌┘│││││ ┬   │  │ │├─┤ │││││││ ┬   ├─┤│││ ││  └─┐│ ││││├┤   │ │ │ ├─┤├┤ ├┬┘  └─┐ │ │ │├┤ ├┤   --
--  └─┘┴ ┴ └┘ ┴┘└┘└─┘┘  ┴─┘└─┘┴ ┴─┴┘┴┘└┘└─┘┘  ┴ ┴┘└┘─┴┘  └─┘└─┘┴ ┴└─┘  └─┘ ┴ ┴ ┴└─┘┴└─  └─┘ ┴ └─┘└  └    --
--                                                                                                       --
--=======================================================================================================--
--  ChangeLog:                                                                                       V3  --
--    -> Hey look! I added a title, I had some time                                                      --
--    -> Made some functions local                                                                       --
--    -> Debug Text                                                                                      --
--=======================================================================================================--

dante = {}
local debugText = false

function dante.toggleDebugText()
    debugText = not debugText
    if debugText then
        print("[Dante.lua]: Enabled Debug Text")
    else
        print("[Dante.lua]: Disabled Debug Text")
    end
end

local function encrypt(data)      --TYGPT
    if debugText then
        print("[Dante.lua]: Encrypting " .. data .. " (" .. data:type() .. ")")
        if data:type() == "table" then
            dante.printTable(data)
        end
    end

    if data then
        local result = "{"
        for key, value in pairs(data) do
            if type(value) == "table" then
                result = result .. key .. "=" .. encrypt(value) .. ","
            elseif type(value) == "string" then
                local text = ""
                for i = 1,#value do
                    local char = value:sub(i, i)
                    if char == "," or char == "{" or char == "}" or char == "=" or char == "~" then
                        text = text .. "~"
                    end
                    text = text .. char
                end
                result = result .. key .. "=" .. tostring(text) .. ","
            else
                result = result .. key .. "=" .. tostring(value) .. ","
            end
        end
        result = result:sub(1, -2) .. "}"  -- Remove the trailing comma and add closing brace

        if debugText then
            print("[Dante.lua]: Encrypted " .. result)
        end

        return result
    end
end


local function decrypt(data)

    if debugText then
        print("[Dante.lua]: Decrypting " .. data)
    end

    local keys = {}
    local value = nil
    local type = "key"
    local currentValue = ""

    local finalTable = {}
    local currentTable = finalTable

    for i = 2, #data do -- remove the first character
        local char = data:sub(i, i)
        local preChar = data:sub(i-1, i-1)

        if char == "{" and preChar ~= "~" then
            table.insert(keys, currentValue)

            -- Create a new key for the nested table
            currentTable[currentValue] = {}
            currentTable = currentTable[currentValue]

            currentValue = ""
        elseif char == "}" or char == "," then
            if preChar ~= "~"  then
                if currentValue ~= "" then
                    addData(finalTable, keys, currentValue)
                end

                -- Move back to the parent table
                if #keys > 0 then

                end
                table.remove(keys, #keys)
                currentTable = finalTable

                currentValue = ""
            else
                currentValue = currentValue .. char
            end

        elseif char == "=" and preChar ~= "~"  then
            if data:sub(i + 1, i + 1) ~= "{" then
                table.insert(keys, currentValue)
                currentValue = ""
            end
        elseif char == "~" then

        else
            currentValue = currentValue .. char
        end
    end


    if debugText then
        print("[Dante.lua]: Finnished decrypting " .. data)
        dante.printTable(finalTable)
    end
    return finalTable
end



function addData(data, keys, value)
    if value ~= "" then
        local data = data
        local keys = keys
        local value = value

        local textForDebug = ""

        -- Ensure there are keys and the data table is initialized
        if #keys > 0 and data ~= "" then
            local currentTable = data

            -- Iterate through keys, excluding the last one
            for i = 1, #keys - 1 do
                local key = tonumber(keys[i]) or keys[i]

                -- Create a nested table if it doesn't exist
                currentTable[key] = currentTable[key] or {}

                -- Move to the next level
                currentTable = currentTable[key]
            end

            -- Insert the text into the final nested table
            local lastKey = tonumber(keys[#keys]) or keys[#keys]
            local numericValue = tonumber(value) or value

            if type(currentTable[lastKey]) == "table" then
                -- If the last key points to a table, add the value to that table
                table.insert(currentTable[lastKey], numericValue)
            else
                -- Otherwise, set the value for the last key
                currentTable[lastKey] = numericValue
            end

        end
    end
end



function dante.save(data, folder, file, compress) --IDIDMYSELF
    local text = nul
    if type(data) == "table" then
        text = encrypt(data)

    elseif type(data) == "string" then
        text = data
    else
        print("BAD type ig")
        return
    end

    if compress then
        text = love.data.compress("string", "zlib", text)
    end
    
    if love.filesystem.getInfo(folder, "directory") then
    else
        love.filesystem.createDirectory(folder)
    end
    love.filesystem.write(folder .. "/" .. file, text)

    if debugText then
        print("[Dante.lua]: saved" .. file .. " at " .. folder)
    end
end

function dante.load(file, compress)       --IDIDMYSELF
    if love.filesystem.getInfo(file, "file") then
        local fileContents, fileSize = love.filesystem.read(file)
        if debugText then
            print("[Dante.lua]: Found " .. file)
        end

        if compress then
            fileContents = love.data.decompress("string", "zlib", fileContents)
        end

        return clean(decrypt(fileContents))
    else
        if debugText then
            print("[Dante.lua]: Can't Find " .. file)
        end
    end
end


function clean(inputTable)
    if debugText then
        print("[Dante.lua]: Cleaning " .. inputTable)
    end
    local resultTable = {}

    for key, value in pairs(inputTable) do
        if type(value) == "table" then
            -- Recursively remove empty tables
            local nonEmptyTable = clean(value)
            if next(nonEmptyTable) ~= nil then
                resultTable[key] = nonEmptyTable
            end
        else
            resultTable[key] = value
        end
    end

    return resultTable
end



function dante.printTable(t, indent)
    indent = indent or 0
    for key, value in pairs(t) do
        local formatting = string.rep("  ", indent)

        if type(key) == "number" then
            formatting = formatting .. "[" .. key .. "]: "
        else
            formatting = formatting .. key .. ": "
        end

        if type(value) == "table" then
            print(formatting)
            dante.printTable(value, indent + 1)
        else
            print(formatting .. tostring(value))
        end
    end
end


function dante.isNegative(num)
    if num < 0 then
        return -1
    else
        return 1
    end
end


function dante.noQuantumEntanglememt(table)
    if debugText then
        print("[Dante.lua]: Re-building " .. table)
    end
    local temp = {}
    for key, value in pairs(table) do
        if type(table[key]) == "table" then
            temp[key] = noQuantumEntanglememt(table[key])
        else
            temp[key] = value
        end
    end

    return temp
end