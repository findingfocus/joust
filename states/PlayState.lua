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
	self.vultureCount = 0
	self.pteroTimer = 0
	SpawnZonePoints = {}
	SpawnZonePoints[1] = SpawnZonePoint(platform3.x + 20, platform3.y)
	SpawnZonePoints[2] = SpawnZonePoint(platform4L.x + platform4L.width - 27, platform4L.y)
	SpawnZonePoints[3] = SpawnZonePoint(platform2.x + 20, platform2.y)
	SpawnZonePoints[4] = SpawnZonePoint(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y)
	PteroSpawnPoints = {}
	PteroSpawnPoints[1] = SpawnZonePoint(-24, 12, 1.8)
	PteroSpawnPoints[2] = SpawnZonePoint(VIRTUAL_WIDTH, 12, -1.8)
	PteroSpawnPoints[3] = SpawnZonePoint(-24, 75, 1.8)
	PteroSpawnPoints[4] = SpawnZonePoint(VIRTUAL_WIDTH, 75, -1.8)
	PteroSpawnPoints[5] = SpawnZonePoint(-24, VIRTUAL_HEIGHT - 80, 1.8)
	PteroSpawnPoints[6] = SpawnZonePoint(VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 80, -1.8)
	self.randomPteroIndex = math.random(6)
	self.monster = Pterodactyl(-30, -30, 0)
	--self.mouseX = 0
	--self.mouseY = 0
	--tester = Vulture(self.mouseX, self.mouseY, 16, 24)
end

function PlayState:update(dt)
--[[
	self.mouseX = love.mouse:getX()
	self.mouseY = love.mouse:getY()

	tester.x = self.mouseX
	tester.y = self.mouseY

	if love.keyboard.wasPressed('h') then
		self.helpToggle = not self.helpToggle
	end
--]]


---[[VultureCount
	self.vultureCount = 0
	for i, vulture in pairs(Vultures) do
		if not vulture.exploded then
			self.vultureCount = self.vultureCount + 1
		end
	end
--]]

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

		if self.pteroTimer > 0 then
			self.pteroTimer = self.pteroTimer - dt
		end

		if self.pteroTimer < 0 then
			self.monster = Pterodactyl(PteroSpawnPoints[self.randomPteroIndex].x, PteroSpawnPoints[self.randomPteroIndex].y, PteroSpawnPoints[self.randomPteroIndex].dx)
			self.pteroTimer = 0
		end

		if self.vultureSpawnTimer > 0 then
			self.vultureSpawnTimer = self.vultureSpawnTimer - dt
		else
			self.vultureSpawnTimer = 0
		end
---[[SPAWNING VULTURES FOR WAVE 1
		if self.vultureSpawnTimer < 9 and self.vultureSpawnTimer > 8 then
			self.vultureSpawnTimer = 8
			self.vultureSpawnPointIndex = math.random(4)
			Vulture1 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 1)
			Vultures[1] = Vulture1
			self.pteroTimer = self.pteroTimer + 20
		elseif self.vultureSpawnTimer < 7 and self.vultureSpawnTimer > 6 then
			self.vultureSpawnTimer = 6
			self.vultureSpawnPointIndex = math.random(4)
			Vulture2 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 2)
			Vultures[2] = Vulture2
			self.pteroTimer = self.pteroTimer + 20
		elseif self.vultureSpawnTimer < 5 and self.vultureSpawnTimer > 4 then
			self.vultureSpawnTimer = 0
			self.vultureSpawnPointIndex = math.random(4)
			Vulture3 = Vulture(SpawnZonePoints[self.vultureSpawnPointIndex].x, SpawnZonePoints[self.vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[self.vultureSpawnPointIndex].y, 3)
			Vultures[3] = Vulture3
			self.pteroTimer = self.pteroTimer + 20
		end
	end
--]]

	--Reset Ostrich
	if love.keyboard.wasPressed('r') then
		player1 = Ostrich(platform3.x, platform3.y, 16, 24, platform3.y)
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	--Reset Vultures
	if love.keyboard.wasPressed('v') then
		Vulture1 = Vulture(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y, 16, 24, groundPlatform.y, 1)
		Vulture2 = Vulture(platform2.x + 20, platform2.y, 16, 24, platform2.y, 2)
		Vultures[1] = Vulture1
		Vultures[2] = Vulture2
	end

	--PLAYER 1 OSTRICH DEATH AND RESPAWN
	if player1.death then
		--SENDS PTERO TO GRAVEYARD UPON PLAYER DEATH
		self.monster = Pterodactyl(-30, -30, 0)
		self.pteroTimer = self.vultureCount * 20
		if self.lives == 1 then
			self.lives = self.lives - 1
			self.gameOver = true
		else
			self.lives = self.lives - 1
			self.spawnPointIndex = math.random(4)
			player1 = Ostrich(SpawnZonePoints[self.spawnPointIndex].x, SpawnZonePoints[self.spawnPointIndex].y, 16, 24, SpawnZonePoints[self.spawnPointIndex].y)
		end
	end

	--KILLS PTERO IF NO VULTURES ON SCREEN
	if self.vultureCount == 0 then
		self.monster = Pterodactyl(-30, -30, 0)
	end

	lavaBubble1:update(dt)
	lavaBubble2:update(dt)

	for k, vulture in pairs(Vultures) do
		vulture:update(dt)
		vulture.egg.jockey:update(dt)
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

---[[PLAYER TO ENEMY COLLISIONS
	for k, vulture in pairs(Vultures) do
		if not player1.temporarySafety then
			if vulture.spawning == false then
				if player1:enemyTopCollides(vulture) then
					player1.exploded = true
					vulture.dy = vulture.dy * -1
					vulture.y = player1.y - vulture.height
				elseif player1:enemyBottomCollides(vulture) then
					vulture.exploded = true
					self.pteroTimer = self.vultureCount * 20 - 20
					vulture.firstFrameExploded = true
					player1.dy = player1.dy * -1
					player1.y = vulture.y - player1.height
					Score = Score + vulture.pointTier
				elseif player1:enemyLeftCollides(vulture) then
					if player1.facingRight and vulture.facingRight then
						player1.exploded = true
					elseif not self.facingRight and not vulture.facingRight then
						vulture.exploded = true
						self.pteroTimer = self.vultureCount * 20 - 20
						vulture.firstFrameExploded = true
						Score = Score + vulture.pointTier
					elseif player1.facingRight and not vulture.facingRight then
						player1.dx = player1.dx * -1
						player1.x = vulture.x + vulture.width
					elseif not player1.facingRight and vulture.facingRight then
						if player1.y == vulture.y then
							player1.dx = player1.dx * -1
							vulture.dx = vulture.dx * -1
							vulture.x = player1.x - vulture.width
						elseif player1.y > vulture.y then --VULTURE HAS HIGHER LANCE
							player1.exploded = true
						elseif player1.y < vulture.y then --OSTRICH HAS HIGHER LANCE
							vulture.exploded = true
							self.pteroTimer = self.vultureCount * 20 - 20
							vulture.firstFrameExploded = true
							Score = Score + vulture.pointTier
						end
					end
				elseif player1:enemyRightCollides(vulture) then
					if player1.facingRight and vulture.facingRight then
						vulture.exploded = true
						self.pteroTimer = self.vultureCount * 20 - 20
						vulture.firstFrameExploded = true
						Score = Score + vulture.pointTier
					elseif not player1.facingRight and not vulture.facingRight then
						player1.exploded = true
					elseif player1.facingRight and not vulture.facingRight then
						if player1.y == vulture.y then
							player1.dx = player1.dx * -1
							vulture.dx = vulture.dx * -1
							vulture.x = player1.x + player1.width
						elseif player1.y < vulture.y then --OSTRICH HAS HIGHER LANCE
							self.pteroTimer = self.vultureCount * 20 - 20
							vulture.exploded = true
							vulture.firstFrameExploded = true
							Score = Score + vulture.pointTier
						elseif player1.y > vulture.y then --VULTURE HAS HIGHER LANCE
							player1.exploded = true
							--vulture.firstFrameExploded = true
						end
					elseif not player1.facingRight and vulture.facingRight then
						player1.dx = player1.dx * -1
						player1.x = vulture.x - player1.width
					end 
				end
			end
		end
	end				
--]]
---[[PLAYER TO EGG COLLISIONS
	for l, vulture in pairs(Vultures) do
		if player1:Collides(vulture.egg) and not vulture.egg.invulnerable and not vulture.egg.collected then --do we need to add if not egg hatched here that would move egg to graveyard upon hatching then we need jockey to inherit x y?
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

		if player1:Collides(vulture.egg.jockey) then
			vulture.egg.jockey.collected = true
			self.scoresTable[self.eggCount].doubleScore = false
			Score = Score + self.scoresTable[self.eggCount].scoreAmount
			self.scoresTable[self.eggCount].lastX = vulture.egg.jockey.lastX
			self.scoresTable[self.eggCount].lastY = vulture.egg.jockey.lastY
			self.scoresTable[self.eggCount].timer = 1.5
			vulture.egg.jockey.x = -20
			vulture.egg.jockey.y = -20
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
--]]

	for k, v in pairs(self.scoresTable) do
		self.scoresTable[k]:update(dt)
	end

---[[PTERODACTYL COLLISION

	--PTERODACTYL AND PLATFORM COLLISION
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

	--PTERODACTYL AND VULTURE COLLISION
	for i, vulture in pairs(Vultures) do
		if self.monster:leftCollides(vulture) then
			vulture.dx = math.abs(vulture.dx) * -1
			self.monster.x = vulture.x + vulture.width
			self.monster.dx = math.abs(self.monster.dx)
		elseif self.monster:rightCollides(vulture) then
			vulture.dx = math.abs(vulture.dx)
			self.monster.x = vulture.x - self.monster.width
			self.monster.dx = math.abs(self.monster.dx) * -1
		elseif self.monster:topCollides(vulture) then
			vulture.dy = math.abs(vulture.dy) * -1
			self.monster.y = vulture.y + vulture.height
			self.monster.dy = math.abs(self.monster.dy)
		elseif self.monster:bottomCollides(vulture) then
			vulture.dy = math.abs(vulture.dy)
			self.monster.y = vulture.y - self.monster.height
			self.monster.dy = math.abs(self.monster.dy) * -1
		end
	end

--LANCE TO PTERODACTYL COLLISION
	if not player1.temporarySafety and not self.monster.facingRight then
		--Check if joust kills ptero when ptero facing left and player facing right
		if player1.facingRight then
			if self.monster:leftCollides(player1) then
				if player1.y + 4 > self.monster.y + 1 and player1.y + 4 < self.monster.y + 8 and self.monster.frame == 3 then
					self.monster.exploded = true
				elseif self.monster:leftCollides(player1) or self.monster:topCollides(player1) or self.monster:bottomCollides(player1) then
					player1.death = true
				end
			end
		end

	elseif not player1.temporarySafety and self.monster.facingRight then
		--Check if joust kills ptero when ptero facing right and player facing left
		if not player1.facingRight then
			if self.monster:rightCollides(player1) then
				if player1.y + 4 > self.monster.y + 1 and player1.y + 4 < self.monster.y + 8 and self.monster.frame == 3 then
					self.monster.exploded = true
				elseif self.monster:rightCollides(player1) or self.monster:topCollides(player1) or self.monster:bottomCollides(player1) then
					player1.death = true
				end
			end
		end
	end

--Kills player if collision while facing same direction as pterodactyl
	if player1.facingRight and self.monster.facingRight then
		if self.monster:leftCollides(player1) or self.monster:rightCollides(player1) or self.monster:topCollides(player1) or self.monster:bottomCollides(player1) then
			player1.death = true
		end
	elseif not player1.facingRight and not self.monster.facingRight then
		if self.monster:leftCollides(player1) or self.monster:rightCollides(player1) or self.monster:topCollides(player1) or self.monster:bottomCollides(player1) then
			player1.death = true
		end
	end

--BOUNCES PTERO OFF FLOOR
	if self.monster.y + self.monster.height > groundPlatform.y then --GROUND
		self.monster.y = groundPlatform.y - self.monster.height
		self.monster.dy = self.monster.dy * -1
	end
--BOUNCES PTERO OFF TOP OF SCREEN
	if self.monster.y < 0 then --TOP OF SCREEN COLLISION
		self.monster.y = 0
		self.monster.dy = math.abs(self.monster.dy)
	end
--]]
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
	self.monster:render()

	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(tostring(self.lives), 138, VIRTUAL_HEIGHT - 28)

	for k, vulture in pairs(Vultures) do
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		vulture:render()

		if vulture.exploded then
			vulture.egg:render()
		end

		if vulture.egg.jockeySpawned then
			vulture.egg.jockey:render()
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

--DEBUG INFO
	--love.graphics.print('enemyLeftCollides: ' .. tostring(player1:enemyRightCollides(tester)), 5, 15)
	--love.graphics.print('enemyRightCollides: ' .. tostring(player1:enemyLeftCollides(tester)), 5, 25)
	
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

	--tester:render()
end