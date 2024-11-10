ObstacleSpawner = {}
ObstacleSpawner.__index = ObstacleSpawner


-- Constructor for SkillTree
function ObstacleSpawner:New()
    local obj = setmetatable({}, ObstacleSpawner)

    obj.spawners = {}
    obj.lastCamY = 0

    return obj
end

function ObstacleSpawner:AddSpawner(obstical, keyframes)
    local tempSpawner = {
        obstical = obstical,
        timer = 0,
        lastTime = 0,
        keyframes = keyframes or {["0"] = {timer = 25, lerp = tweens.sineInOut}, ["1000000"] = {timer = 25, lerp = tweens.sineInOut}},
    }

    table.insert(self.spawners, tempSpawner)
end

function ObstacleSpawner:Update(cameraY)
    local changeCameraY = self.lastCamY - cameraY
    self.lastCamY = cameraY

    for i = 1,#self.spawners do
        local spawner = self.spawners[i]

        local lastFrame = 0
        local nextFrame = math.huge

        spawner.timer = spawner.timer - changeCameraY

        --get the time.
        for key, value in pairs(spawner.keyframes) do

            local num = tonumber(key)

            if num then
                if num > cameraY then
                    if num > lastFrame then
                        lastFrame = num
                    end
                elseif num < nextFrame then
                    nextFrame = num
                end
            end
        end

        --print(lastFrame, nextFrame)

        local lf = spawner.keyframes[tostring(lastFrame)]
        local nf = spawner.keyframes[tostring(nextFrame)]
        if nf and lf then

            local requiredTime = lf.lerp(lf.timer, nf.timer, (-cameraY-lastFrame)/(nextFrame-lastFrame))

            local count = spawner.timer/requiredTime
            local num = 1

            while spawner.timer > requiredTime do
                local x = math.random(-960, 1920)

                local y = -((cameraY-(count/num))+100) - math.random(0, requiredTime)

                if river.insideBounds(x, y) then
                    table.insert(obsticals, spawner.obstical:New(x, y))
                    print("sp")
                end

                spawner.timer = spawner.timer - requiredTime
                num = num + 1
            end

        end

    end
end