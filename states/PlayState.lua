PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 2 - 50, 500)
	GRAVITY = 120
	playerSpeed = 500
end

function PlayState:update(dt)
	--sounds['playMusic']:setLooping(true)
	--sounds['playMusic']:play()
	player1:update(dt)
	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.isDown('right') then
		player1.x = (player1.x + playerSpeed * dt) % VIRTUAL_WIDTH
		self.dx = 6
	end

--[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)
--]]
	if love.keyboard.isDown('left') then
		player1.x = (player1.x - playerSpeed * dt) % VIRTUAL_WIDTH
		player1.dx = 6
	end

	if love.keyboard.wasPressed('space') and grounded then
		player1.dy = -30
	end

	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		--gStateMachine:change('titleState')
		playerX = 0
		playerY = 800 - 110
		playerDY = 0
		PLAYER_SPEED = 500
		player1.dx = 0
	end


end


function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	love.graphics.setColor(255/255, 193/255, 87/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 50)

	player1:render()

	love.graphics.print(table.concat({
		'',
		'',
		'playerX: '..math.floor(player1.x),
		'playerY: '..math.floor(player1.y),
		'player.dx: '..math.floor(player1.dx),
		'PLAYER_SPEED: '..math.floor(PLAYER_SPEED),
	}, '\n'))
	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end 

