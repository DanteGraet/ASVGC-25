require("code/templateLib/debug")

debug.print("[LOADING] Start")

-- load libraries
local libraryList = love.filesystem.getDirectoryItems("code/templateLib")
for name, library in pairs(libraryList) do
    -- remove the ".lua"
    local libraryName = library:gsub("%.lua$", "")
    require("code/templateLib/" .. libraryName)
    print(libraryName)

    print(dante and dante.dataToString(debug))
    if debug then debug.print("[LOADING] Loaded Library " .. libraryName) end
end

if love.filesystem.getInfo("code/globals.lua", "file") then
    love.filesystem.load("code/globals.lua")()
    if debug then debug.print("[LOADING] Loaded Globals" ) end
end

font.loadFont("font/kulimParkRegular.ttf", "kulimPark")


debug.print("[LOADING] End")