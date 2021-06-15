TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()

end

local highlighted = 1

function TitleScreenState:update(dt)

--[[
	sounds['titleMusic']:setLooping(true)
	sounds['titleMusic']:play()
--]]

	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		highlighted = highlighted == 1 and 2 or 1
		sounds['beep']:play()
	end

	if love.keyboard.wasPressed('h') then
		--sounds['titleMusic']:stop()
		gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		if highlighted == 1 then
			--sounds['titleMusic']:stop()
			sounds['select']:play()
			gStateMachine:change('playState')
		else
			love.event.quit()
		end
	end
end


function TitleScreenState:render()
	love.graphics.clear(150/255, 150/255, 150/255, 255/255)

--[[
	love.graphics.setFont(smallFont)
	love.graphics.printf('JOUST small', 0, VIRTUAL_HEIGHT / 3 - 60, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('JOUST medium', 0, (VIRTUAL_HEIGHT / 3) * 2 - 60, VIRTUAL_WIDTH, 'center')
--]]
	love.graphics.setFont(largeFont)
	love.graphics.printf('JOUST', 0, (VIRTUAL_HEIGHT / 3) - 120 , VIRTUAL_WIDTH, 'center')
	
	if highlighted == 1 then
		love.graphics.setColor(80/255, 220/255, 255/255, 255/255)
	end
	love.graphics.setFont(mediumFont)
	love.graphics.printf('PLAY', 0, VIRTUAL_HEIGHT / 2 + 120, VIRTUAL_WIDTH, 'center')
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	if highlighted == 2 then
		love.graphics.setColor(80/255, 220/255, 255/255, 255/255)
	end
	love.graphics.setFont(mediumFont)
	love.graphics.printf('EXIT', 0, VIRTUAL_HEIGHT / 2 + 190, VIRTUAL_WIDTH, 'center')
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "H" For Help', 0, VIRTUAL_HEIGHT / 2 + 320, VIRTUAL_WIDTH, 'center')

end