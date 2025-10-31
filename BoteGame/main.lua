require("requirements")

--require("i give up")

gameState = ""
previousGameState = ""
game = {}



function love.quit()
    --[[if game[gameState] and game[gameState].unload then
        game[gameState].unload()
    end

    if assets.code then
        dante.save(assets.code.player.unlocks, "save", "unlocks")
    end
    if saveSettings then
        saveSettings()
    end]]
end




function getMouseSoxSoy()
    local screenScale = screen.getScale()
    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    local mx = love.mouse.getX()/screenScale
    local my = love.mouse.getY()/screenScale

    return mx - sox, my - soy
end

--[[function love.draw(pre)

    love.graphics.reset()

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2



    if not pre then
        if not game[gameState].noTransform == true then

            love.graphics.scale(screenScale)
            if lockedAspectRatio then
                love.graphics.translate(sox, soy)
            end
    
        end

        if game[gameState] and game[gameState].draw then
            game[gameState].draw()
        end
    else
        local p = previousGameState
        if p == "GetWreked" then
            p = gameState
        end

        if game[p] then
            if not game[p].noTransform == true then

                love.graphics.scale(screenScale)
                if lockedAspectRatio then
                    love.graphics.translate(sox, soy)
                end
        
            end
            if game[p] and game[p].draw then
                game[p].draw()
            end
        end
    end

    if drawDebugRuler then quindoc.drawRuler() end

    if lockedAspectRatio and not game[gameState].noTransform == true then
        love.graphics.setColor(screenBarColour)
        --x bars
        --love.graphics.rectangle("fill", 0, 0, -sox, love.graphics.getHeight()/screenScale)
        --love.graphics.rectangle("fill", 1920, 0, sox, love.graphics.getHeight()/screenScale)

        --y bars
        --love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/screenScale, -soy)
        --love.graphics.rectangle("fill", 0, 1080, love.graphics.getWidth()/screenScale, soy)
    end


end]]

function love.update(dt)
    music.update(dt)
end

function love.resize(width, height)
    -- update screen
    screen.update()
end

function love.quit()
	dante.save(save, "save")
end

function love.keypressed(key)
    if key == "f11" then
        if settingsMenu then
            --settingsMenu:toggleFullscreen()
            settingsMenu:toggleFunction(not love.window.getFullscreen(), settings.graphics.fullscreen)
        else
            love.window.setFullscreen( not love.window.getFullscreen())
        end
    end

    if key == "g" and love.keyboard.isDown("lctrl") and DEV then
        drawDebugRuler = not drawDebugRuler
    end

    if key == "m" and love.keyboard.isDown("lctrl") and DEV then
        print(love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
    end
end


function love.run()
    love.filesystem.load("load.lua")()

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
    local gameState = gameStateManager.updateGameState() or {}

	-- Main loop time.
	return function()
        -- update gameState here, update will be using it
        gameState = gameStateManager.updateGameState() or gameState

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end

				if love[name] then
					if love[name](a,b,c,d,e,f) ~= true then
						if gameState[name] then
							gameState[name](a,b,c,d,e,f)
						end
					end
				else
                	--love.handlers[name](a,b,c,d,e,f)
					if gameState[name] then
					gameState[name](a,b,c,d,e,f)
					end	
				end
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = math.min(love.timer.step(), 1/10) end

		-- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
		if gameState.update then gameState.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			--love.graphics.origin()
            --love.graphics.reset()
			love.graphics.clear(love.graphics.getBackgroundColor())


            if screen.draw then screen.draw(gameState) end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end