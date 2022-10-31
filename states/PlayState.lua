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
	self.eggCount = 1
	self.spawnPointIndex = 0
	self.vultureSpawnPointIndex = 0
	self.vultureSpawnTimer = 10
	self.lowestEggScore = 0
	self.scoresTable = {}
	self.wave1ScorePopulate = false
	self.helpToggle = false
	self.gameOver = false
	self.refresh = true
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 5, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET)
	player1.y = VIRTUAL_HEIGHT - GROUND_OFFSET - player1.height
	player1.temporarySafety = false
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	SpawnZonePoints = {}
	SpawnZonePoints[1] = SpawnZonePoint(platform3.x + 20, platform3.y)
	SpawnZonePoints[2] = SpawnZonePoint(platform4L.x + platform4L.width - 27, platform4L.y)
	SpawnZonePoints[3] = SpawnZonePoint(platform2.x + 20, platform2.y)
	SpawnZonePoints[4] = SpawnZonePoint(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y)
	self.monster = Pterodactyl(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 30)
end

function PlayState:update(dt)
	if love.keyboard.wasPressed('h') then
		self.helpToggle = not self.helpToggle
	end

	if self.wave == 1 then
		if not self.wave1ScorePopulate then
			self.lowestEggScore = 250

			--SCORE TABLE INITIALIZATION
			for i = 1, 3 do
				table.insert(self.scoresTable, PrintScore(-20, -20, self.lowestEggScore))
				self.lowestEggScore = self.lowestEggScore + 250 --Incremented by bounder score
			end
			self.wave1ScorePopulate = true
		end

		if self.vultureSpawnTimer > 0 then
			self.vultureSpawnTimer = self.vultureSpawnTimer - dt
		else
			self.vultureSpawnTimer = 0
		end
		--SPAWNING VULTURES FOR WAVE 1
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

	--PLAYER 1 OSTRICH DEATH AND RESPAWN
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

	--PLACE VULTURE IN GRAVEYARD UPON DEATH
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
	--VULTURE TO VULTURE COLLISION
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
		if player1:Collides(vulture.egg) and not vulture.egg.invulnerable and not vulture.egg.collected then
			if math.abs(player1.dx) < .3 then
				if player1.x + (player1.width / 2) < vulture.egg.x + 4.2 and player1.x + (player1.width / 2) > vulture.egg.x + 3.8 then
					vulture.egg.x = -vulture.egg.width
					vulture.egg.y = -vulture.egg.height
					vulture.egg.dx = 0
					vulture.egg.dy = 0
					vulture.egg.collected = true
					self.scoresTable[self.eggCount].lastX = vulture.egg.lastX
					self.scoresTable[self.eggCount].lastY = vulture.egg.lastY
					self.scoresTable[self.eggCount].timer = 1.5
					if vulture.egg.bouncedOffFloor then
						self.scoresTable[self.eggCount].doubleScore = false
						Score = Score + self.scoresTable[self.eggCount].scoreAmount
					else
						Score = Score + self.scoresTable[self.eggCount].scoreAmount * 2
					end
					self.eggCount = self.eggCount + 1
				end

			elseif math.abs(player1.dx) >= .3 then
				vulture.egg.x = -vulture.egg.width
				vulture.egg.y = -vulture.egg.height
				vulture.egg.dx = 0
				vulture.egg.dy = 0
				vulture.egg.collected = true
				self.scoresTable[self.eggCount].lastX = vulture.egg.lastX
				self.scoresTable[self.eggCount].lastY = vulture.egg.lastY
				self.scoresTable[self.eggCount].timer = 1.5
				if vulture.egg.bouncedOffFloor then
					Score = Score + self.scoresTable[self.eggCount].scoreAmount
					self.scoresTable[self.eggCount].doubleScore = false
				else
					Score = Score + self.scoresTable[self.eggCount].scoreAmount * 2
				end
				self.eggCount = self.eggCount + 1
			end
		end
		if vulture.egg:groundCollide(groundPlatform) then
				vulture.egg.bouncedOffFloor = true
				vulture.egg.y = groundPlatform.y - vulture.egg.height
				vulture.egg.dy = math.max(-vulture.egg.dy + .25, -.9)
		end

		for m, platform in pairs(collidablePlatforms) do
			if vulture.egg:groundCollide(platform) then
				vulture.egg.bouncedOffFloor = true
				vulture.egg.y = platform.y - vulture.egg.height
				vulture.egg.dy = math.max(-vulture.egg.dy + .25, -.9)
			end
			if vulture.egg:leftCollide(platform) then
				vulture.egg.x = platform.x + platform.width
				vulture.egg.dx = math.abs(vulture.egg.dx)
			end
			if vulture.egg:rightCollide(platform) then
				vulture.egg.x = platform.x - vulture.egg.width
				vulture.egg.dx = -1 * vulture.egg.dx
			end
		end
	end

	for k, v in pairs(self.scoresTable) do
		self.scoresTable[k]:update(dt)
	end

	for k, platform in pairs(collidablePlatforms) do
		if self.monster:leftCollides(platform) then
			self.monster.x = platform.x + platform.width
			self.monster.dx = self.monster.dx * -1
		elseif self.monster:rightCollides(platform) then
			self.monster.x = platform.x - self.monster.width
			self.monster.dx = self.monster.dx * -1
		elseif self.monster:topCollides(platform) then
			self.monster.y = platform.y + platform.height
			self.monster.dy = math.abs(self.monster.dy)
		elseif self.monster:bottomCollides(platform) then
			self.monster.y = platform.y - self.monster.height
			self.monster.dy = self.monster.dy * -1
		end
	end	

	if self.monster.y + self.monster.height > groundPlatform.y then
		self.monster.y = groundPlatform.y - self.monster.height
		self.monster.dy = self.monster.dy * -1
	end

	if self.monster.y < 0 then
		self.monster.y = 0
		self.monster.dy = math.abs(self.monster.dy)
	end

	self.monster:update(dt)
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
	--love.graphics.print('dy: ' .. tostring(player1.dy), 5, 15)
	
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

	for k, v in pairs(self.scoresTable) do
		self.scoresTable[k]:render()
	end

	self.monster:render()
end