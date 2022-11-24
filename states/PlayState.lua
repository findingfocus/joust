PlayState = Class{__includes = BaseState}

function PlayState:init()
	platform1 = Platform('platform1R', 262, 55, 69, 7)
	platform1L = Platform('platform1L', -30, 55, 69, 7)
	platform2 = Platform('platform2', 76, 65, 110, 7)
	platform3 = Platform('platform3', 212, 114, 61, 7)
	platform4 = Platform('platform4', 262, 122, 79, 7)
	platform4L = Platform('platform4L', -30, 122, 79, 7)
	platform5 = Platform('platform5', 96, 150, 79, 7)
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT, 2)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT, 5)
	collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
	Vultures = {}
	Eggs = {}
	Jockeys = {}
	scoresTable = {}
	wave = 1
	lives = 8
	eggCount = 1
	spawnPointIndex = 0
	vultureSpawnPointIndex = 0
	vultureSpawnTimer = 10
	lowestEggScore = 0
	wave1ScorePopulate = false
	helpToggle = false
	gameOver = false
	refresh = true
	tablesPopulated = false
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 5, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET)
	player1.y = VIRTUAL_HEIGHT - GROUND_OFFSET - player1.height
	player1.temporarySafety = false
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	vultureCount = 0
	pteroTimer = 0
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
	randomPteroIndex = math.random(6)
	monster = Pterodactyl(-30, -30, 0)
	taxi1 = Taxi(VIRTUAL_WIDTH / 2, 20, 16, 24)
end

function PlayState:update(dt)

	if love.keyboard.wasPressed('h') then
		helpToggle = not helpToggle
	end

---[[VULTURE COUNT
	vultureCount = 0
	for k, vulture in pairs(Vultures) do
		if not vulture.exploded then
			vultureCount = vultureCount + 1
		end
	end
--]]

---[[WAVE LOGIC
	if wave == 1 then
		if not wave1ScorePopulate then
			lowestEggScore = 250

			--SCORE TABLE INITIALIZATION
			for i = 1, 3 do
				table.insert(scoresTable, PrintScore(-20, -20, lowestEggScore))
				lowestEggScore = lowestEggScore + 250 --Incremented by bounder score
			end
			wave1ScorePopulate = true
		end

		--GLOBAL OBJECT TABLE DUMMY INITIALIZATION
		if not tablesPopulated then
			for i = 1, 3 do
				Vultures[i] = Vulture(-20, -20, 16, 24, -20, i)
				Eggs[i] = Egg(-10, -10, 0, i)
				Jockeys[i] = Jockey(-20, -20, i)
			end

			tablesPopulated = true
		end

		--PTERODACTYL SPAWN
		if pteroTimer > 0 then
			pteroTimer = pteroTimer - dt
		end

		if pteroTimer < 0 then
			monster = Pterodactyl(PteroSpawnPoints[randomPteroIndex].x, PteroSpawnPoints[randomPteroIndex].y, PteroSpawnPoints[randomPteroIndex].dx)
			monster.graveyard = false
			pteroTimer = 0
		end

		--SPAWNING VULTURES
		if vultureSpawnTimer > 0 then
			vultureSpawnTimer = vultureSpawnTimer - dt
		else
			vultureSpawnTimer = 0
		end

		if vultureSpawnTimer < 9 and vultureSpawnTimer > 8 then
			vultureSpawnTimer = 8
			vultureSpawnPointIndex = math.random(4)
			Vulture1 = Vulture(SpawnZonePoints[vultureSpawnPointIndex].x, SpawnZonePoints[vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[vultureSpawnPointIndex].y, 1)
			Vultures[1] = Vulture1
			Vulture1.graveyard = false
			pteroTimer = pteroTimer + 20
		elseif vultureSpawnTimer < 7 and vultureSpawnTimer > 6 then
			vultureSpawnTimer = 6
			vultureSpawnPointIndex = math.random(4)
			Vulture2 = Vulture(SpawnZonePoints[vultureSpawnPointIndex].x, SpawnZonePoints[vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[vultureSpawnPointIndex].y, 2)
			Vultures[2] = Vulture2
			Vulture2.graveyard = false
			pteroTimer = pteroTimer + 20
		elseif vultureSpawnTimer < 5 and vultureSpawnTimer > 4 then
			vultureSpawnTimer = 0
			vultureSpawnPointIndex = math.random(4)
			Vulture3 = Vulture(SpawnZonePoints[vultureSpawnPointIndex].x, SpawnZonePoints[vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[vultureSpawnPointIndex].y, 3)
			Vultures[3] = Vulture3
			Vulture3.graveyard = false
			pteroTimer = pteroTimer + 20
		end
	end
--]]

---[[RESETS
	--RESET PLAYER
	if love.keyboard.wasPressed('r') then
		player1 = Ostrich(platform3.x, platform3.y, 16, 24, platform3.y)
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	--RESET VULTURES
	if love.keyboard.wasPressed('v') and not Vultures[3].spawning then
		Vulture1 = Vulture(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y, 16, 24, groundPlatform.y, 1)
		Vulture2 = Vulture(VIRTUAL_WIDTH / 2, groundPlatform.y, 16, 24, groundPlatform.y, 2)
		Vulture3 = Vulture(VIRTUAL_WIDTH / 2 + 30, groundPlatform.y, 16, 24, groundPlatform.y, 3)
		Vulture1.graveyard = false
		Vulture2.graveyard = false
		Vulture3.graveyard = false
		Vultures[1] = Vulture1
		Vultures[2] = Vulture2
		Vultures[3] = Vulture3
	end
--]]

	if player1.exploded and player1.explosionTimer > .35 then --PLAYER 1 DEATH AND RESPAWN
		--SENDS PTERO TO GRAVEYARD UPON PLAYER DEATH
		monster.graveyard = true
		monster = Pterodactyl(-30, -30, 0)
		pteroTimer = vultureCount * 20
		if lives == 1 then
			lives = lives - 1
			gameOver = true
		else
			lives = lives - 1
			spawnPointIndex = math.random(4)
			player1 = Ostrich(SpawnZonePoints[spawnPointIndex].x, SpawnZonePoints[spawnPointIndex].y, 16, 24, SpawnZonePoints[spawnPointIndex].y)
		end
	end

	if vultureCount == 0 then --KILLS PTERO IF NO VULTURES ON SCREEN
		monster = Pterodactyl(-30, -30, 0)
	end
	
---[[BUBBLE LOGIC
	if lavaBubble1.popped then --REMOVES POPPED LAVABUBBLES, REINSTANTIATES NEW ONES
		leftSpawnPoint = {11, 35}
		leftSpawnPoint = leftSpawnPoint[math.random(#leftSpawnPoint)]
		leftSpawnRandom = {1, 2, 5, 5, 7}
		leftSpawnRandom = leftSpawnRandom[math.random(#leftSpawnRandom)]
		lavaBubble1 = LavaBubble(leftSpawnPoint, VIRTUAL_HEIGHT, leftSpawnRandom)
	end

	if lavaBubble2.popped then --REMOVES POPPED LAVABUBBLES, REINSTANTIATES NEW ONES
		rightSpawnPoint = {VIRTUAL_WIDTH - 11, VIRTUAL_WIDTH - 45}
		rightSpawnPoint = rightSpawnPoint[math.random(#rightSpawnPoint)]
		rightSpawnRandom = {1, 2, 5, 5, 7}
		rightSpawnRandom = rightSpawnRandom[math.random(#rightSpawnRandom)]
		lavaBubble2 = LavaBubble(rightSpawnPoint, VIRTUAL_HEIGHT, rightSpawnRandom)
	end
	--]]

---[[VULTURE TO VULTURE COLLISION
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
	--]]

---[[PLAYER TO ENEMY COLLISIONS
	for i = 1, 3 do --Be sure to change 3 to variable for wave objects
		if not player1.temporarySafety then
			if Vultures[i].spawning == false then
				if player1:enemyTopCollides(Vultures[i]) then
					player1.exploded = true
					player1.graveyard = true
					Vultures[i].dy = Vultures[i].dy * -1
				elseif player1:enemyBottomCollides(Vultures[i]) then
					Vultures[i].exploded = true
					Vultures[i].graveyard = true
					Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
					Eggs[i].graveyard = false
					Eggs[i].invulnerable = true
					pteroTimer = vultureCount * 20 - 20
					Vultures[i].firstFrameExploded = true
					player1.dy = player1.dy * -1
					Score = Score + Vultures[i].pointTier
				elseif player1:enemyLeftCollides(Vultures[i]) then
					if player1.facingRight and Vultures[i].facingRight then
						player1.exploded = true
						player1.graveyard = true
					elseif not player1.facingRight and not Vultures[i].facingRight then
						Vultures[i].exploded = true
						Vultures[i].graveyard = true
						Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
						Eggs[i].graveyard = false
						Eggs[i].invulnerable = true
						pteroTimer = vultureCount * 20 - 20
						Vultures[i].firstFrameExploded = true
						Score = Score + Vultures[i].pointTier
					elseif player1.facingRight and not Vultures[i].facingRight then
						player1.dx = player1.dx * -1
						player1.x = Vultures[i].x + Vultures[i].width
					elseif not player1.facingRight and Vultures[i].facingRight then
						if player1.y == Vultures[i].y then
							player1.dx = player1.dx * -1
							Vultures[i].dx = Vultures[i].dx * -1
							Vultures[i].x = player1.x - Vultures[i].width
						elseif player1.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
							player1.exploded = true
							player1.graveyard = true
						elseif player1.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
							Vultures[i].exploded = true
							Vultures[i].graveyard = true
							Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
							Eggs[i].graveyard = false
							Eggs[i].invulnerable = true
							pteroTimer = vultureCount * 20 - 20
							Vultures[i].firstFrameExploded = true
							Score = Score + Vultures[i].pointTier
						end
					end
				elseif player1:enemyRightCollides(Vultures[i]) then
					if player1.facingRight and Vultures[i].facingRight then
						Vultures[i].exploded = true
						Vultures[i].graveyard = true
						Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
						Eggs[i].graveyard = false
						Eggs[i].invulnerable = true
						pteroTimer = vultureCount * 20 - 20
						Vultures[i].firstFrameExploded = true
						Score = Score + Vultures[i].pointTier
					elseif not player1.facingRight and not Vultures[i].facingRight then
						player1.exploded = true
						player1.graveyard = true
					elseif player1.facingRight and not Vultures[i].facingRight then
						if player1.y == Vultures[i].y then
							player1.dx = player1.dx * -1
							Vultures[i].dx = Vultures[i].dx * -1
							Vultures[i].x = player1.x + player1.width
						elseif player1.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
							pteroTimer = vultureCount * 20 - 20
							Vultures[i].exploded = true
							Vultures[i].graveyard = true
							Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
							Eggs[i].graveyard = false
							Eggs[i].invulnerable = true
							Vultures[i].firstFrameExploded = true
							Score = Score + Vultures[i].pointTier
						elseif player1.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
							player1.exploded = true
							player1.graveyard = true
						end
					elseif not player1.facingRight and Vultures[i].facingRight then
						player1.dx = player1.dx * -1
						player1.x = Vultures[i].x - player1.width
					end 
				end
			end
		end
	end				
	--]]

---[[JOCKEY SPAWN
	for i = 1, 3 do
		if Eggs[i].hatched then
			Jockeys[i] = Jockey(Eggs[i].lastX, Eggs[i].lastY)
			Jockeys[i].graveyard = false
			Eggs[i].graveyard = true
			Eggs[i].hatched = false
		end
	end
	--]]

---[[PLAYER TO OBJECT COLLISIONS
	for i = 1, 3 do
		if player1:Collides(Eggs[i]) and not Eggs[i].invulnerable and not Eggs[i].collected then --PLAYER TO EGG COLLISIONS
			if math.abs(player1.dx) < .3 then --SLOW COLLISION
				if player1.x + (player1.width / 2) < Eggs[i].x + 4.2 and player1.x + (player1.width / 2) > Eggs[i].x + 3.8 then
					Eggs[i].graveyard = true
					Eggs[i].collected = true
					scoresTable[eggCount].lastX = Eggs[i].lastX
					scoresTable[eggCount].lastY = Eggs[i].lastY
					scoresTable[eggCount].timer = 1.5
					if scoresTable[eggCount].doubleScore then
						Score = Score + scoresTable[eggCount].scoreAmount * 2
					else
						Score = Score + scoresTable[eggCount].scoreAmount
					end
					if eggCount < 3 then
						eggCount = eggCount + 1
					end
				end
			elseif math.abs(player1.dx) >= .3 then --FAST COLLISION
				Eggs[i].graveyard = true
				Eggs[i].collected = true
				scoresTable[eggCount].lastX = Eggs[i].lastX
				scoresTable[eggCount].lastY = Eggs[i].lastY
				scoresTable[eggCount].timer = 1.5
				if scoresTable[eggCount].doubleScore then
					Score = Score + scoresTable[eggCount].scoreAmount * 2
				else
					Score = Score + scoresTable[eggCount].scoreAmount
				end

				if eggCount < 3 then --PREVENTS EGGCOUNT FROM INDEXING MORE THAN AVAILABLE OBJECTS, CHANGE FROM 3 TO WAVE OBJECTS VARIABLE
					eggCount = eggCount + 1
				end
			end
		end

---[[PLAYER TO JOCKEY COLLISION
		if not Jockeys[i].graveyard and player1:Collides(Jockeys[i]) then
			Jockeys[i].collected = true
			if scoresTable[eggCount].doubleScore then
				Score = Score + scoresTable[eggCount].scoreAmount * 2
			else
				Score = Score + scoresTable[eggCount].scoreAmount
			end
			--scoresTable[eggCount].doubleScore = false
			--Score = Score + scoresTable[eggCount].scoreAmount
	
			scoresTable[eggCount].timer = 1.5
			scoresTable[eggCount].lastX = Jockeys[i].lastX
			scoresTable[eggCount].lastY = Jockeys[i].lastY
			Jockeys[i].graveyard = true

			if eggCount < 3 then
				eggCount = eggCount + 1
			end
		end
	--]]

---[[EGGS TO FLOOR COLLISION
		--EGGS ON GROUND COLLISION
		if Eggs[i]:groundCollide(groundPlatform) then
				Eggs[i].bouncedOffFloor = true
				Eggs[i].y = groundPlatform.y - Eggs[i].height
				Eggs[i].dy = math.max(-Eggs[i].dy + .25, -.9)
		end

		--EGGS AND PLATFORM COLLISION
		for m, platform in pairs(collidablePlatforms) do
			if Eggs[i]:groundCollide(platform) then
				Eggs[i].bouncedOffFloor = true
				Eggs[i].y = platform.y - Eggs[i].height
				Eggs[i].dy = math.max(-Eggs[i].dy + .25, -.9)
			end
			if Eggs[i]:leftCollide(platform) then
				Eggs[i].x = platform.x + platform.width
				Eggs[i].dx = math.abs(Eggs[i].dx)
			end
			if Eggs[i]:rightCollide(platform) then
				Eggs[i].x = platform.x - Eggs[i].width
				Eggs[i].dx = -1 * Eggs[i].dx
			end
		end
	end

	for i = 1, 3 do
		if Eggs[i].bouncedOffFloor and not Eggs[i].collected then
			scoresTable[i].doubleScore = false
		end
	end
	--]]
	
	for k, v in pairs(scoresTable) do
		scoresTable[k]:update(dt)
	end

---[[PTERODACTYL COLLISION

	--PTERODACTYL AND PLATFORM COLLISION
	for k, platform in pairs(collidablePlatforms) do
		if monster:leftCollides(platform) then
			monster.x = platform.x + platform.width
			monster.dx = monster.dx * -1
		elseif monster:rightCollides(platform) then
			monster.x = platform.x - monster.width
			monster.dx = monster.dx * -1
		elseif monster:topCollides(platform) then
			monster.y = platform.y + platform.height
			monster.dy = math.abs(monster.dy)
		elseif monster:bottomCollides(platform) then
			monster.y = platform.y - monster.height
			monster.dy = monster.dy * -1
		end
	end	

	--PTERODACTYL AND VULTURE COLLISION
	for i, vulture in pairs(Vultures) do
		if monster:leftCollides(vulture) then
			vulture.dx = math.abs(vulture.dx) * -1
			monster.x = vulture.x + vulture.width
			monster.dx = math.abs(monster.dx)
		elseif monster:rightCollides(vulture) then
			vulture.dx = math.abs(vulture.dx)
			monster.x = vulture.x - monster.width
			monster.dx = math.abs(monster.dx) * -1
		elseif monster:topCollides(vulture) then
			vulture.dy = math.abs(vulture.dy) * -1
			monster.y = vulture.y + vulture.height
			monster.dy = math.abs(monster.dy)
		elseif monster:bottomCollides(vulture) then
			vulture.dy = math.abs(vulture.dy)
			monster.y = vulture.y - monster.height
			monster.dy = math.abs(monster.dy) * -1
		end
	end

	--LANCE TO PTERODACTYL COLLISION
	if not player1.temporarySafety and not monster.facingRight then
		if player1.facingRight then
			if monster:leftCollides(player1) then
				if player1.y + 4 > monster.y + 1 and player1.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
					monster.exploded = true
					monster.graveyard = true
				elseif monster:leftCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
					player1.exploded = true
				end
			end
		end

	elseif not player1.temporarySafety and monster.facingRight then
		if not player1.facingRight then
			if monster:rightCollides(player1) then
				if player1.y + 4 > monster.y + 1 and player1.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
					monster.exploded = true
					monster.graveyard = true
				elseif monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
					player1.exploded = true
				end
			end
		end
	end

	if player1.facingRight and monster.facingRight then --KILLS PLAYER IF TOUCHES PTERO OUTSIDE OF WEAKSPOT
		if monster:leftCollides(player1) or monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
			player1.exploded = true
		end
	elseif not player1.facingRight and not monster.facingRight then
		if monster:leftCollides(player1) or monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
			player1.exploded = true
		end
	end
	--]]

---[[OBJECT UPDATES
	for i = 1, 3 do
		Vultures[i]:update(dt)
		Eggs[i]:update(dt)
		Jockeys[i]:update(dt)
	end
	monster:update(dt)
	lavaBubble1:update(dt)
	lavaBubble2:update(dt)
	player1:update(dt)
	--]]

	taxi1:update(dt)
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

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT, VIRTUAL_WIDTH, LAVAHEIGHT)

	player1:render()
	monster:render()

	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(tostring(lives), 138, VIRTUAL_HEIGHT - 28)

---[[RENDER OBJECT TABLES
	for i = 1, 3 do
		if not Vultures[i].graveyard or Vultures[i].explosionTimer ~= 0 then
			Vultures[i]:render()
		end

		if not Eggs[i].graveyard and not Eggs[i].collected then
			Eggs[i]:render()
		end

		if not Jockeys[i].graveyard then
			Jockeys[i]:render()	
		end
	end
	--]]
	
	lavaBubble1:render()
	lavaBubble2:render()

	taxi1:render()

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
	love.graphics.setColor(255/255, 255/255, 60/255, 255/255)
	love.graphics.print('[1]', Vultures[1].x, Vultures[1].y - 8)
	--love.graphics.print('taxianim: ' .. tostring(taxi1.animationTimer), 5, 15)
	
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
	if gameOver then
		love.graphics.setColor(255/255, 30/255, 30/255, 100/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center', 0, 1, 1, -1, -1)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
	end

	if helpToggle and not gameOver then
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

	for k, v in pairs(scoresTable) do
		scoresTable[k]:render()
	end

	--tester:render()
end