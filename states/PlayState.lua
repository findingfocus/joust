PlayState = Class{__includes = BaseState}

function PlayState:init()
	platform1 = Platform('platform1R', 262, 55, 69, 7)
	platform1L = Platform('platform1L', -30, 55, 69, 7)
	platform2 = Platform('platform2', 76, 65, 110, 7)
	platform3 = Platform('platform3', 212, 114, 61, 7)
	platform4 = Platform('platform4', 262, 122, 79, 7)
	platform4L = Platform('platform4L', -30, 122, 79, 7)
	platform5 = Platform('platform5', 96, 150, 79, 7)
	self.Bubble1 = {}
	self.Bubble2 = {}
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT, 2)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT, 5)
	collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
	Vultures = {}
	table.insert(Vultures, Vulture(platform3.x + 16, platform3.y, 16, 24, platform3))
	table.insert(Vultures, Vulture(platform2.x + 16, platform2.y, 16, 24, platform2))
	self.lives = 4
	self.helpToggle = false
	self.gameOver = false
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET)
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
end

function PlayState:update(dt)

	if love.keyboard.wasPressed('h') then
		self.helpToggle = not self.helpToggle
	end

	if love.keyboard.wasPressed('r') then
		--[[
		player1.x = platform4L.x + platform4L.width - player1.width--VIRTUAL_WIDTH / 3 - 8
		player1.y = platform4L.y - player1.height--VIRTUAL_HEIGHT - 65
		player1.skid = false
		player1.grounded = false
		player1.facingRight = true
		player1.exploded = false
		player1.dx = 0
		player1.dy = 0
		--]]
		player1 = Ostrich(platform3.x, platform3.y, 16, 24, platform3.y)
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	--Respawn Vultures
	if love.keyboard.wasPressed('v') then
		table.remove(Vultures)
		table.remove(Vultures)
		table.insert(Vultures, Vulture(platform3.x + 16, platform3.y, 16, 24, platform3))
		table.insert(Vultures, Vulture(platform2.x + 16, platform2.y, 16, 24, platform2))
	end

	lavaBubble1:update(dt)
	lavaBubble2:update(dt)

	for k, vulture in pairs(Vultures) do
		vulture:update(dt)
	end

	--LOSE LIFE AND RESPAWN
	if player1.death then
		if self.lives == 1 then
			self.lives = self.lives - 1
			self.gameOver = true
		elseif self.lives == 0 then

		else
			self.lives = self.lives - 1
			player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET)
		end
	end

	player1:update(dt)
	
--REMOVES POPPED LAVABUBBLES, REINSTANTIATES NEW ONES
	if lavaBubble1.popped then
		leftSpawnPoint = {11, 35}
		leftSpawnPoint = leftSpawnPoint[math.random(#leftSpawnPoint)]
		leftSpawnRandom = {1, 2, 5, 5, 7}
		leftSpawnRandom = leftSpawnRandom[math.random(#leftSpawnRandom)]
		lavaBubble1 = LavaBubble(leftSpawnPoint, VIRTUAL_HEIGHT, leftSpawnRandom)
	end

	if lavaBubble2.popped then
		rightSpawnPoint = {VIRTUAL_WIDTH - 11, VIRTUAL_WIDTH - 45}
		rightSpawnPoint = rightSpawnPoint[math.random(#rightSpawnPoint)]
		rightSpawnRandom = {1, 2, 5, 5, 7}
		rightSpawnRandom = rightSpawnRandom[math.random(#rightSpawnRandom)]
		lavaBubble2 = LavaBubble(rightSpawnPoint, VIRTUAL_HEIGHT, rightSpawnRandom)
	end
end

function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT, VIRTUAL_WIDTH, LAVAHEIGHT)


	--draw ground top level **to be made retractable
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 4)

	--ground bottom stand-in
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	player1:render()
	love.graphics.setFont(smallFont)
	love.graphics.print('LIVES: ' .. tostring(self.lives), 10, VIRTUAL_HEIGHT - 25)

	for k, vulture in pairs(Vultures) do
		vulture:render()
	end
	
	lavaBubble1:render()
	lavaBubble2:render()

	for k, platform in pairs(collidablePlatforms) do 
		platform:render()
	end

	love.graphics.setFont(smallFont)
	love.graphics.print('vultureJustCOllided: ' .. tostring(Vultures[1].justCollided), 10, 10)
	--love.graphics.print('enemy.y: ' .. tostring(vulture1.y), 10, 20)

	--love.graphics.print('counter: ' .. tostring(lavaBubble1.counter), 10, 10)
	--love.graphics.print('randomspawn: ' .. tostring(lavaBubble1.randomSpawn), 10, 20)
	--love.graphics.print('particleSpawn: ' .. tostring(lavaBubble1.particleSpawn), 10, 30)
	--love.graphics.print('particleY: ' .. tostring(lavaBubble1.y), 10, 40)
	--love.graphics.print(tostring(self.Bubble1[2]), 10, 20)
	--love.graphics.print(tostring(self.Bubble1[3]), 10, 30)

--[[
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(smallFont)
	love.graphics.print(table.concat({
		'',
		'',
		'',
		'PLAYER1.X: '..math.floor(player1.x),
		'PLAYER1.Y: '..math.floor(player1.y),
		--'PLAYER1.facingRight: '..tostring(player1.facingRight),
		--'ANIMATION TIMER: ' ..tostring(animationTimer),
		--'PLAYER1.speedTier: '..math.floor(player1.speedTier),
		'PLAYER1.DY: ' ..tostring(string.format("%.2f", player1.dy)),
		--'PLAYER1.skid: ' ..tostring(player1.skid),
		'PLAYER1.DX: ' ..tostring(string.format("%.2f", player1.dx)),
		--'justStoppedTimer: ' ..tostring(string.format("%.3f", player1.justStoppedTimer)),
		--'justTurnedTimer: ' ..tostring(string.format("%.3f", player1.justTurnedTimer)),
		--'justStopped = ' ..tostring(player1.justStopped),
		--'justTurned = ' ..tostring(player1.justTurned),
		--'love.keyboard.isDown(left) =' ..tostring(love.keyboard.isDown('left')),
		'self.skid = ' ..tostring(player1.skid),
		--'lastInputLocked = ' ..lastInput[1],
		'PLAYER1.grounded: ' ..tostring(player1.grounded),
		--'TOP COLL: ' .. tostring(player1:topCollides(platform1)),
		'platform1 BotCol: ' .. tostring(player1:bottomCollides(platform1)),
		'groundPlat BotCol: ' .. tostring(player1:bottomCollides(groundPlatform)),
		--'checkedGround4L: ' .. tostring(player1:checkGrounded(platform4L)),
		--'checkedGround4: ' .. tostring(player1:checkGrounded(platform4)),
		'GROUND: ' .. tostring(player1.ground.name),
		--'topcollides5: ' .. tostring(player1:topCollides(platform5)),
		--'name: ' .. tostring(ground),
		--'topcheckGrounded: ' .. tostring(player1:checkGrounded(groundPlatform)),
 		--'RIGHT COLL: ' .. tostring(player1:rightCollides(platform1)),
		--'LEFT COLL: ' .. tostring(player1:leftCollides(platform1)),
		--'jumpTimer: ' ..tostring(player1.jumpTimer),
		--'flapped: ' ..tostring(player1.flapped),
	}, '\n'))
--]]
	
--[[
	--KEYLOGGER
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(keyloggerPlate, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)

	if love.keyboard.isDown('left') then
		love.graphics.draw(keylogger1, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end
	
	if love.keyboard.isDown('a') then
		love.graphics.draw(keylogger2, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end

	if love.keyboard.isDown('right') then
		love.graphics.draw(keylogger3, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end
	--]]

	if self.gameOver then
		love.graphics.setColor(255/255, 30/255, 30/255, 100/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center', 0, 1, 1, -1, -1)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
	end

	if self.helpToggle and not self.gameOver then
		love.graphics.setColor(255/255, 30/255, 30/255, 100/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.printf('TO FLY, REPEATEDLY PRESS \'A\'', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center', 0, 1, 1, -1, -1)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.printf('TO FLY, REPEATEDLY PRESS \'A\'', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
	end
end