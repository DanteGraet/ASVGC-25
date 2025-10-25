local printDebug = true

debug = {}

function debug.print(...)
    if printDebug then
        print(...)
    end
end


function debug.startLog()
    log.logs = {}
    log.time = love.timer.getTime()
end

function debug.jumpLogTime()
    log.time = love.timer.getTime()
end

function debug.logPoint(name)
    local now = love.timer.getTime()
    table.insert(
        log.logs, 
        {
            name = name,
            time = love.timer.getTime() - log.time
        }
    )
    log.time = love.timer.getTime()
end

function debug.stopLog()
    table.sort(log.logs, function(a,b) return a.time > b.time end)

    --print(log.logs[1].name,  (log.logs[1].time * 1000) .. "ms")
    --print(log.logs[1].name, string.format("%.3f ms", log.logs[1].time * 1000)) -- Rounded to 3 decimals
    local lTable  = {}

    for i = 1,#log.logs do
        local l = log.logs[i]
        table.insert(lTable, string.format("%.3f ms", log.logs[i].time * 1000) .. " -> " .. l.name)
    end

    print("=========================================================")
    dante.printTable(lTable)
end

