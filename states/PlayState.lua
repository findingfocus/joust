PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT - 50 - 100, 100)
	player1.facingRight = true
	playerSpeed = 1
	playerSpeed2 = 4
	playerSpeed3 = 7
	playerSpeed4 = 12
	playerSpeed5 = 20
	fps = 1
	animationTimer = 1 / fps
	frame = 1
	totalFrames = 4
	xoffset = 100
	ostrichAtlas = love.graphics.newImage('src/pics/ostrichAtlas.png')
	ostrichSprite = love.graphics.newQuad(0, 0, 100, 100, ostrichAtlas:getDimensions())
end




--[[
Left and right need to be positive negative scale



under what conditions do we increment speed counter
	when the direction your facing key is pressed up until 5
--]]




function PlayState:update(dt)
	--sounds['playMusic']:setLooping(true)
	--sounds['playMusic']:play()
	--player1:update(dt)

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end


	--PLAYER MOVING LEFT
	if player1.speedTier > 0 and not player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x - playerSpeed
		elseif player1.speedTier == 2 then
			player1.x = player1.x - playerSpeed * playerSpeed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x - playerSpeed * playerSpeed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x - playerSpeed * playerSpeed4
		else
			player1.x = player1.x - playerSpeed * playerSpeed5
		end
	end


	--PLAYER MOVING RIGHT
	if player1.speedTier > 0 and player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x + playerSpeed
		elseif player1.speedTier == 2 then
			player1.x = player1.x + playerSpeed * playerSpeed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x + playerSpeed * playerSpeed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x + playerSpeed * playerSpeed4
		else
			player1.x = player1.x + playerSpeed * playerSpeed5
		end
	end

	player1.x = player1.x % VIRTUAL_WIDTH

--[[
	if love.keyboard.isDown('left') then
		player1.x = (player1.x - playerSpeed * dt) % VIRTUAL_WIDTH
	end

		--PLAYER MOVING RIGHT
	if love.keyboard.isDown('right') then
		player1.x = (player1.x + playerSpeed * dt) % VIRTUAL_WIDTH
	end
--]]







	--INCREMENT SPEED LEFT
	if love.keyboard.wasPressed('left') and player1.speedTier < 5 then

		--TURNING
		if player1.speedTier == 0 then
			player1.facingRight = false
		end
		--SPEED INCREMEMENT
		player1.speedTier = player1.speedTier + 1
	end

	--BRAKES
	if love.keyboard.wasPressed('left') and player1.facingRight then
		player1.speedTier = 0
	end




	--INCREMEMENT SPEED RIGHT
	if love.keyboard.wasPressed('right') and player1.speedTier < 5 then
		
		--TURNING
		if player1.speedTier == 0 then
			player1.facingRight = true
		end

		--SPEED INCREMENT
		player1.speedTier = player1.speedTier + 1
	end

	--BRAKES
	if love.keyboard.wasPressed('right') and not player1.facingRight then
		player1.speedTier = 0
	end

--[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)

	if love.keyboard.wasPressed('left') or 

	end

	--]]



	if love.keyboard.wasPressed('space') and grounded then
		player1.dy = -30
	end

	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		--gStateMachine:change('titleState')
		player1.x = VIRTUAL_WIDTH / 2 - 50
		player1.y = VIRTUAL_HEIGHT - 50 - player1.width
		--playerDY = 0
		player1.speedTier = 0
		player1.facingRight = true
	end



	animationTimer = animationTimer - dt
	if animationTimer <= 0 then
		animationTimer = 1 / fps
		frame = frame + 1
		if frame > totalFrames then frame = 1 end
		xoffset = 100 * (frame - 1)
		ostrichSprite:setViewport(xoffset, 0, 100, 100)
	end
	
	player1:update(dt)

end


function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	love.graphics.setColor(255/255, 193/255, 87/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 50)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	love.graphics.print(table.concat({
		'',
		'',
		'playerX: '..math.floor(player1.x),
		'playerY: '..math.floor(player1.y),
		'player1.speedTier: '..math.floor(player1.speedTier),
		'player1.facingRight: '..tostring(player1.facingRight),
	}, '\n'))
	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
	
	player1:render()
end 
