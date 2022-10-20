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
	self.wave = 1
	self.lives = 8
	self.eggCounter = 0
	self.spawnPointIndex = 0
	self.vultureSpawnPointIndex = 0
	self.vultureSpawnTimer = 10
	self.onlyScore = PrintScore(-20,-20, 0)
	self.helpToggle = false
	self.gameOver = false
	self.refresh = true
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET)
	player1.y = VIRTUAL_HEIGHT - GROUND_OFFSET - player1.height
	player1.temporarySafety = false
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	SpawnZonePoints = {}
	SpawnZonePoints[1] = SpawnZonePoint(platform3.x + 20, platform3.y)
	SpawnZonePoints[2] = SpawnZonePoint(platform4L.x + platform4L.width - 27, platform4L.y)
	SpawnZonePoints[3] = SpawnZonePoint(platform2.x + 20, platform2.y)
	SpawnZonePoints[4] = SpawnZonePoint(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y)
	self.eggTest = Egg(0, 0, 0)
	self.mouseX = 0
	self.mouseY = 0
end

function PlayState:update(dt)
	if love.keyboard.wasPressed('h') then
		self.helpToggle = not self.helpToggle
	end

	if self.wave == 1 then
		if self.vultureSpawnTimer > 0 then
			self.vultureSpawnTimer = self.vultureSpawnTimer - dt
		else
			self.vultureSpawnTimer = 0
		end

		if self.vultureSpawnTimer < 9 and self.vultureSpawnTimer > 8 then
			self.vultureSpawnTimer = 8
			self.vultureSpawnPointIndex = math.random(4)
			Vulture1 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 1)
			Vultures[1] = Vulture1
		elseif self.vultureSpawnTimer < 7 and self.vultureSpawnTimer > 6 then
			self.vultureSpawnTimer = 6
			self.vultureSpawnPointIndex = math.random(4)
			Vulture2 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 2)
			Vultures[2] = Vulture2
		elseif self.vultureSpawnTimer < 5 and self.vultureSpawnTimer > 4 then
			self.vultureSpawnTimer = 0
			self.vultureSpawnPointIndex = math.random(4)
			Vulture3 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 3)
			Vultures[3] = Vulture3
		end
	end

	--Reset Ostrich
	if love.keyboard.wasPressed('r') then
		player1 = Ostrich(platform3.x, platform3.y, 16, 24, platform3.y)
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	--Reset Vultures
	if love.keyboard.wasPressed('v') then
		Vulture1 = Vulture(platform3.x + 20, platform3.y, 16, 24, platform3.y, 1)
		Vulture2 = Vulture(platform2.x + 20, platform2.y, 16, 24, platform2.y, 2)
		Vultures[1] = Vulture1
		Vultures[2] = Vulture2
	end

	--LOSE LIFE AND RESPAWN
	if player1.death then
		if self.lives == 1 then
			self.lives = self.lives - 1
			self.gameOver = true
		else
			self.lives = self.lives - 1
			self.spawnPointIndex = math.random(4)
			player1 = Ostrich(SpawnZonePoints[self.spawnPointIndex].x, SpawnZonePoints[self.spawnPointIndex].y, 16, 24, SpawnZonePoints[self.spawnPointIndex].y)
		end
	end

	lavaBubble1:update(dt)
	lavaBubble2:update(dt)

	for k, vulture in pairs(Vultures) do
		vulture:update(dt)
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

	--Placing vultures in graveyard offscreen
	for k, vulture in pairs(Vultures) do
		if vulture.exploded then
			if vulture.firstFrameExploded then
				vulture.eggSpawn = true --MAKE THIS ONLY TRUE THE FRAME WE EXPLODE
				vulture.firstFrameExploded = false
			end
			vulture.x = -vulture.width
			vulture.y = -vulture.height
			vulture.egg:update(dt)
		end
	end

	for i, vulture in pairs(Vultures) do
		for index, others in pairs(Vultures) do
			if vulture.index ~= index then
				if vulture:Collides(others) then
					vulture.dx = vulture.dx * -1
					others.dx = others.dx * -1
					if vulture.x < others.x then
						others.x = vulture.x + vulture.width + 1
					else
						others.x = vulture.x - others.width - 1
					end
				end
			end
		end
	end

	for l, vulture in pairs(Vultures) do
		if player1:Collides(vulture.egg) and not vulture.egg.invulnerable then

			if math.abs(player1.dx) < .3 then
				if player1.x + (player1.width / 2) < vulture.egg.x + 4.1 and player1.x + (player1.width / 2) > vulture.egg.x + 3.9 then
					vulture.egg.x = -vulture.egg.width
					vulture.egg.y = -vulture.egg.height
					vulture.egg.dx = 0
					vulture.egg.dy = 0
					vulture.egg.collected = true
					self.onlyScore = PrintScore(vulture.egg.lastX, vulture.egg.lastY, 250)

					if self.eggCounter == 0 then
						Score = Score + 250
					elseif self.eggCounter == 1 then
						Score = Score + 500
					elseif self.eggCounter == 2 then
						Score = Score + 750
					end
				end

			elseif math.abs(player1.dx) > .3 then
				vulture.egg.x = -vulture.egg.width
				vulture.egg.y = -vulture.egg.height
				vulture.egg.dx = 0
				vulture.egg.dy = 0
				vulture.egg.collected = true
				self.onlyScore = PrintScore(vulture.egg.lastX, vulture.egg.lastY, 250)

				if self.eggCounter == 0 then
					Score = Score + 250
					self.eggCounter = self.eggCounter + 1
				elseif self.eggCounter == 1 then
					Score = Score + 500
					self.eggCounter = self.eggCounter + 1
				elseif self.eggCounter == 2 then
					Score = Score + 750
					self.eggCounter = self.eggCounter + 1
				end
			end
		end
		if vulture.egg:groundCollide(groundPlatform) then
				vulture.egg.y = groundPlatform.y - vulture.egg.height
				vulture.egg.dy = math.max(-vulture.egg.dy + .25, -.9)
		end

		for m, platform in pairs(collidablePlatforms) do
			if vulture.egg:groundCollide(platform) then
				vulture.egg.y = platform.y - vulture.egg.height
				vulture.egg.dy = math.max(-vulture.egg.dy + .25, -.9)
			end
		end
	end

	self.mouseX = love.mouse.getX()
	self.mouseY = love.mouse.getY()

	self.onlyScore:update(dt)
	self.eggTest.x = self.mouseX
	self.eggTest.y = self.mouseY
end

function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	--draw ground top level **to be made retractable
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 4)

	--ground bottom stand-in
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)
	love.graphics.draw(groundBottom, 53, VIRTUAL_HEIGHT - 36)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT, VIRTUAL_WIDTH, LAVAHEIGHT)

	player1:render()

	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(tostring(self.lives), 138, VIRTUAL_HEIGHT - 28)

	for k, vulture in pairs(Vultures) do
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		vulture:render()
		if vulture.exploded then
			vulture.egg:render()
		end
	end
	
	lavaBubble1:render()
	lavaBubble2:render()

	for k, platform in pairs(collidablePlatforms) do 
		platform:render()
	end

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(platformSpawn, platform2.x + 15, platform2.y)
	love.graphics.draw(platformSpawn, platform3.x + 15, platform3.y)
	love.graphics.draw(platformSpawn, platform4L.x + platform4.width - 33, platform4L.y)
	love.graphics.draw(platformSpawn, VIRTUAL_WIDTH / 2 - 35, groundPlatform.y)
	

	love.graphics.setFont(smallFont)
	love.graphics.print('testEgg:groundCollide: ' .. tostring(self.eggTest:groundCollide(platform2)), 5, 15)
	love.graphics.print('testEgg:leftCollide: ' .. tostring(self.eggTest:leftCollide(platform2)), 5, 25)
	love.graphics.print('testEgg:rightCollide: ' .. tostring(self.eggTest:rightCollide(platform2)), 5, 35)
	--love.graphics.print('self.vultureSpawnTimer: ' .. tostring(self.vultureSpawnTimer), 5, 15)
	--love.graphics.print('TS: ' .. tostring(player1.temporarySafety), 5, 15)
	--love.graphics.print('exploded: ' .. tostring(Vultures[1].exploded), 5, 5)
	--love.graphics.print('eggSpawn: ' .. tostring(Vultures[1].eggSpawn), 5, 15)
	--slove.graphics.print('[' .. tostring(Vulture3.grounded) .. ']', Vulture3.x, Vulture3.y - 10)
--[[
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(smallFont)
	love.graphics.print(table.concat({
		'',
		'PLAYER1.X: '..math.floor(player1.x),
	}, '\n'))
--]]
	
--[[KEYLOGGER
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

	--SCORE
	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(string.format("%06d", Score), 67, VIRTUAL_HEIGHT - 28)
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	self.eggTest:render()
	self.onlyScore:render()
end