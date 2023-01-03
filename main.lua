require '/src/dependencies'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Joust')

	love.mouse.setVisible(false)

	math.randomseed(os.time())

	Score = 0

	smallerFont = love.graphics.newFont('fonts/visitor.ttf', 10)
	smallFont = love.graphics.newFont('fonts/arcadeFont.ttf', 8)
	mediumFont = love.graphics.newFont('fonts/arcadeFont.ttf', 16)
	largeFont = love.graphics.newFont('fonts/arcadeFont.ttf', 32)

	playerAtlas = love.graphics.newImage('src/pics/joustPlayerAtlas2.png')
	bounderAtlas = love.graphics.newImage('src/pics/bounderAtlas.png')
	hunterAtlas = love.graphics.newImage('src/pics/hunterAtlas.png')
	shadowlordAtlas = love.graphics.newImage('src/pics/shadowlordAtlas.png')
	pterodactylAtlas = love.graphics.newImage('src/pics/pterodactylAtlas.png')
	hunterTaxiAtlas = love.graphics.newImage('src/pics/hunterTaxiAtlas.png')
	shadowlordTaxiAtlas = love.graphics.newImage('src/pics/shadowlordTaxiAtlas.png')
	whiteJockey = love.graphics.newImage('src/pics/whiteJockey.png')

	temporarySafetyAtlas = love.graphics.newImage('src/pics/temporarySafetyAtlas.png')
	platformLeft = love.graphics.newImage('src/pics/platformLeft.png')
	platformRight = love.graphics.newImage('src/pics/platformRight.png')
	keyloggerPlate = love.graphics.newImage('src/pics/keyloggerBackplate.png')
	keylogger1 = love.graphics.newImage('src/pics/keylogger1.png')
	keylogger2 = love.graphics.newImage('src/pics/keylogger2.png')
	keylogger3 = love.graphics.newImage('src/pics/keylogger3.png')
	particle = love.graphics.newImage('src/pics/particle.png')
	bubble = love.graphics.newImage('src/pics/bubble.png')
	pop = love.graphics.newImage('src/pics/pop.png')
	explosion1 = love.graphics.newImage('src/pics/explosion1.png')
	explosion2 = love.graphics.newImage('src/pics/explosion2.png')
	explosion3 = love.graphics.newImage('src/pics/explosion3.png')
	eggAtlas = love.graphics.newImage('src/pics/eggAtlas.png')
	platformSpawn = love.graphics.newImage('src/pics/platformSpawn.png')
	groundBottom = love.graphics.newImage('src/pics/groundBottom.png')

	sounds = {
		['beep'] = love.audio.newSource('music/beep.wav', 'static'),
		['select'] = love.audio.newSource('music/select.wav', 'static'),

		['leftStep'] = love.audio.newSource('music/leftStep.mp3', 'static'),
		['rightStep'] = love.audio.newSource('music/rightStep.mp3', 'static'),

		['skid'] = love.audio.newSource('music/skid.mp3', 'static'),
		['flap'] = love.audio.newSource('music/flap.mp3', 'static'),
		['land'] = love.audio.newSource('music/land.mp3', 'static'),
		['collide'] = love.audio.newSource('music/collide.mp3', 'static'),
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false
	})

	gStateMachine = StateMachine {
		['titleState'] = function() return TitleScreenState() end,
		['playState'] = function() return PlayState() end
	}

	gStateMachine:change('playState')

	love.keyboard.keysPressed = {}
	love.keyboard.keysReleased = {}

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

function love.keyreleased(key)
	love.keyboard.keysReleased[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.keyboard.wasReleased(key)
	if love.keyboard.keysReleased[key] then
		return true
	else
		return false
	end
end

function love.update(dt)

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
	love.keyboard.keysReleased = {} 
end



function love.draw()
	push:start()

	gStateMachine:render()

	--displayFPS()

	push:finish()
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end