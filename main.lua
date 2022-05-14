require '/src/dependencies'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Joust')

	love.mouse.setVisible(false)

	smallFont = love.graphics.newFont('fonts/arcadeFont.ttf', 8)
	mediumFont = love.graphics.newFont('fonts/arcadeFont.ttf', 16)
	largeFont = love.graphics.newFont('fonts/arcadeFont.ttf', 32)

	sounds = {
		--['titleMusic'] = love.audio.newSource('music/titlemusic.mp3', 'static'),
		--['playMusic'] = love.audio.newSource('music/playstatemusic.mp3', 'static'),
		--['tripMusic'] = love.audio.newSource('music/trippingmusic.mp3', 'static'),
		['beep'] = love.audio.newSource('music/beep.wav', 'static'),
		['select'] = love.audio.newSource('music/select.wav', 'static'),

		['speed1'] = love.audio.newSource('music/1.mp3', 'static'),
		['speed2'] = love.audio.newSource('music/2.mp3', 'static'),
		['speed3'] = love.audio.newSource('music/3.mp3', 'static'),
		['speed4'] = love.audio.newSource('music/4.mp3', 'static'),

		['2speed1'] = love.audio.newSource('music/1-2.mp3', 'static'),
		['2speed2'] = love.audio.newSource('music/2-2.mp3', 'static'),
		['2speed3'] = love.audio.newSource('music/3-2.mp3', 'static'),
		['2speed4'] = love.audio.newSource('music/4-2.mp3', 'static')


	}
--]]
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false
	})

	gStateMachine = StateMachine {
		['titleState'] = function() return TitleScreenState() end,
		['playState'] = function() return PlayState() end,
		['tripState'] = function() return TripState() end,
		['helpState'] = function() return HelpState() end
	}

	gStateMachine:change('playState')

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w,h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end

	if key == 'tab' then
		local state = not love.mouse.isVisible()
		love.mouse.setVisible(state)
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end





function love.update(dt)

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {} 
end



function love.draw()
	push:start()

	gStateMachine:render()

	displayFPS()

	push:finish()
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end