PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - 65, 16, 24)
	platform1 = Platform('platform1R', 262, 55, 69, 7)
	platform1L = Platform('platform1L', -30, 55, 69, 7)
	platform2 = Platform('platform2', 76, 65, 110, 7)--110width
	platform3 = Platform('platform3', 212, 114, 61, 7)
	platform4 = Platform('platform4', 262, 122, 79, 7)
	platform4L = Platform('platform4L', -30, 122, 79, 7)
	platform5 = Platform('platform5', 96, 150, 79, 7)--79width
	self.Bubble1 = {}
	self.Bubble2 = {}
	self.randomSpawn = math.random(4, 11)
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT)
	table.insert(self.Bubble1, lavaBubble1)
	table.insert(self.Bubble2, lavaBubble2)
	counter = 0
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
end

function PlayState:update(dt)

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('r') then
		player1.x = platform4L.x + platform4L.width - player1.width--VIRTUAL_WIDTH / 3 - 8
		player1.y = platform4L.y - player1.height--VIRTUAL_HEIGHT - 65
		player1.skid = false
		player1.grounded = false
		player1.facingRight = true
		player1.dx = 0
		player1.dy = 0
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	counter = counter + dt

	--Spawns particle at determined randomSpawn time
	if counter > self.randomSpawn then
		lavaBubble1.particleSpawn = true
		lavaBubble2.particleSpawn = true
		self.randomSpawn = math.random(7, 11)
	end

	lavaBubble1:update(dt)
	lavaBubble2:update(dt)

	if lavaBubble1.popped then
		table.remove(self.Bubble1, 1)
		leftSpawnPoint = {11, 22}
		leftSpawnPoint = leftSpawnPoint[math.random(#leftSpawnPoint)]
		lavaBubble1 = LavaBubble(leftSpawnPoint, VIRTUAL_HEIGHT)
		table.insert(self.Bubble1, lavaBubble1)
	end

	if lavaBubble2.popped then
		table.remove(self.Bubble2, 1)
		rightSpawnPoint = {VIRTUAL_WIDTH - 11, VIRTUAL_WIDTH - 22}
		rightSpawnPoint = rightSpawnPoint[math.random(#rightSpawnPoint)]
		lavaBubble2 = LavaBubble(rightSpawnPoint, VIRTUAL_HEIGHT)
		table.insert(self.Bubble2, lavaBubble2)
	end



--[[
	if lavaBubble1.popped then
		leftSpawnPoint = {11, 22}
		leftSpawnPoint = leftSpawnPoint[math.random(#leftSpawnPoint)]
		lavaBubble1 = LavaBubble(leftSpawnPoint, VIRTUAL_HEIGHT)
	end

	if lavaBubble2.popped then
		rightSpawnPoint = {VIRTUAL_WIDTH - 11, VIRTUAL_WIDTH - 22}
		rightSpawnPoint = rightSpawnPoint[math.random(#rightSpawnPoint)]
		lavaBubble2 = LavaBubble(rightSpawnPoint, VIRTUAL_HEIGHT)
	end
	--]]

	player1:update(dt)

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
	lavaBubble1:render()
	lavaBubble2:render()

	for k, v in pairs(collidablePlatforms) do 
		v:render()
	end
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

end