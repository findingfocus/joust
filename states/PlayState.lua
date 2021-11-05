PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Player1(VIRTUAL_WIDTH / 3 - 50, VIRTUAL_HEIGHT - 150, 100)
	player2 = Player2(VIRTUAL_WIDTH - VIRTUAL_WIDTH / 3 - 50, VIRTUAL_HEIGHT - 150, 100)
	player1.facingRight = true
	player2.facingRight = false
	player1Speed = 1
	player1Speed2 = 4
	player1Speed3 = 7
	player1Speed4 = 12
	player1Speed5 = 20
	player2Speed = 1
	player2Speed2 = 4
	player2Speed3 = 7
	player2Speed4 = 12
	player2Speed5 = 20
	fps = 1
	animationTimer1 = 1 / fps
	animationTimer2 = 1/ fps
	frame1 = 1
	frame2 = 1
	totalFrames = 4
	xoffset1 = 100
	xoffset2 = 100
	ostrichAtlas = love.graphics.newImage('src/pics/ostrichAtlas.png')
	ostrichAtlas2 = love.graphics.newImage('src/pics/ostrichAtlas2.png')
	ostrichSprite = love.graphics.newQuad(0, 0, 100, 100, ostrichAtlas:getDimensions())
	ostrichSprite2 = love.graphics.newQuad(0, 0, 100, 100, ostrichAtlas2:getDimensions())
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


	--PLAYER1 MOVING LEFT
	if player1.speedTier > 0 and not player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x - player1Speed
		elseif player1.speedTier == 2 then
			player1.x = player1.x - player1Speed * player1Speed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x - player1Speed * player1Speed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x - player1Speed * player1Speed4
		else
			player1.x = player1.x - player1Speed * player1Speed5
		end
	end

	--PLAYER2 MOVING LEFT
		if player2.speedTier > 0 and not player2.facingRight then
		if player2.speedTier == 1 then
			player2.x = player2.x - player2Speed
		elseif player2.speedTier == 2 then
			player2.x = player2.x - player2Speed * player2Speed2
		elseif player2.speedTier == 3 then
			player2.x = player2.x - player2Speed * player2Speed3
		elseif player2.speedTier == 4 then
			player2.x = player2.x - player2Speed * player2Speed4
		else
			player2.x = player2.x - player2Speed * player2Speed5
		end
	end


	--PLAYER1 MOVING RIGHT
	if player1.speedTier > 0 and player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x + player1Speed
		elseif player1.speedTier == 2 then
			player1.x = player1.x + player1Speed * player1Speed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x + player1Speed * player1Speed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x + player1Speed * player1Speed4
		else
			player1.x = player1.x + player1Speed * player1Speed5
		end
	end

		--PLAYER2 MOVING RIGHT
	if player2.speedTier > 0 and player2.facingRight then
		if player2.speedTier == 1 then
			player2.x = player2.x + player2Speed
		elseif player2.speedTier == 2 then
			player2.x = player2.x + player2Speed * player2Speed2
		elseif player2.speedTier == 3 then
			player2.x = player2.x + player2Speed * player2Speed3
		elseif player2.speedTier == 4 then
			player2.x = player2.x + player2Speed * player2Speed4
		else
			player2.x = player2.x + player2Speed * player2Speed5
		end
	end

	player1.x = player1.x % VIRTUAL_WIDTH
	player2.x = player2.x % VIRTUAL_WIDTH

--[[
	if love.keyboard.isDown('left') then
		player1.x = (player1.x - playerSpeed * dt) % VIRTUAL_WIDTH
	end

		--PLAYER MOVING RIGHT
	if love.keyboard.isDown('right') then
		player1.x = (player1.x + playerSpeed * dt) % VIRTUAL_WIDTH
	end
--]]







	--INCREMENT PLAYER1 SPEED TO THE LEFT
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


--INCREMENT PLAYER2 SPEED TO THE LEFT
	if love.keyboard.wasPressed('a') and player2.speedTier < 5 then

		--TURNING
		if player2.speedTier == 0 then
			player2.facingRight = false
		end
		--SPEED INCREMEMENT
		player2.speedTier = player2.speedTier + 1
	end

		--BRAKES
	if love.keyboard.wasPressed('a') and player2.facingRight then
		player2.speedTier = 0
	end





	--INCREMEMENT PLAYER1 SPEED TO THE RIGHT
	if love.keyboard.wasPressed('right') and player1.speedTier < 5 then
		
		--TURNING
		if player1.speedTier == 0 then
			player1.facingRight = true
		end

		--SPEED INCREMENT
		player1.speedTier = player1.speedTier + 1
	end

	--INCREMEMENT PLAYER2 SPEED TO THE RIGHT

	---[[
	if love.keyboard.wasPressed('d') and player2.speedTier < 5 then
		
		--TURNING
		if player2.speedTier == 0 then
			player2.facingRight = true
		end

		--SPEED INCREMENT
		player2.speedTier = player2.speedTier + 1
	end
	--]]




	--BRAKES FOR PLAYER1
	if love.keyboard.wasPressed('right') and not player1.facingRight then
		player1.speedTier = 0
	end

	--BRAKES FOR PLAYER2
	if love.keyboard.wasPressed('d') and not player2.facingRight then
		player2.speedTier = 0
	end

--[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)

	if love.keyboard.wasPressed('left') or 

	end

	--]]



	--PLAYER1 JUMPING
	if love.keyboard.wasPressed('up') then
		player1.dy = -30
	end

		--PLAYER2 JUMPING
	if love.keyboard.wasPressed('w') then
		player2.dy = -30
	end



	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		--gStateMachine:change('titleState')
		player1.x = VIRTUAL_WIDTH / 3 - 50
		player2.x = VIRTUAL_WIDTH - VIRTUAL_WIDTH / 3 - 50
		player1.y = VIRTUAL_HEIGHT - 50 - player1.width
		player2.y = VIRTUAL_HEIGHT - 50 - player2.width
		--playerDY = 0
		player1.speedTier = 0
		player2.speedTier = 0
		player1.facingRight = true
		player2.facingRight = false
	end


-- SOUNDS FOR WALKING
---[[
	if player1.speedTier == 0 then
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
	end

	if player2.speedTier == 0 then
		sounds['2speed1']:stop()
		sounds['2speed2']:stop()
		sounds['2speed3']:stop()
		sounds['2speed4']:stop()
	end


	if player1.speedTier == 1 then
		sounds['speed1']:setLooping(true)
		sounds['speed1']:play()
	end

	if player2.speedTier == 1 then
		sounds['2speed1']:setLooping(true)
		sounds['2speed1']:play()
	end


	if player1.speedTier == 2 then
		sounds['speed1']:stop()
		sounds['speed2']:setLooping(true)
		sounds['speed2']:play()
	end

	if player2.speedTier == 2 then
		sounds['2speed1']:stop()
		sounds['2speed2']:setLooping(true)
		sounds['2speed2']:play()
	end


	if player1.speedTier == 3 then
		sounds['speed2']:stop()
		sounds['speed3']:setLooping(true)
		sounds['speed3']:play()
	end

	if player2.speedTier == 3 then
		sounds['2speed2']:stop()
		sounds['2speed3']:setLooping(true)
		sounds['2speed3']:play()
	end


	if player1.speedTier == 4 then
		sounds['speed3']:stop()
		sounds['speed4']:setLooping(true)
		sounds['speed4']:play()
	end

	if player2.speedTier == 4 then
		sounds['2speed3']:stop()
		sounds['2speed4']:setLooping(true)
		sounds['2speed4']:play()
	end
--]]



-- OSTRICH1 ANIMATION CYCLE
	if player1.speedTier == 0 then
		frame = 1
		ostrichSprite:setViewport(0, 0, 100, 100)
	end

	speedScale = (player1.speedTier * .035)
	speedScale2 = (player2.speedTier * .035)
	animationTimer1 = animationTimer1 - speedScale

	if player1.speedTier > 0 then 
		animationTimer1 = animationTimer1 - dt
		if animationTimer1 <= 0 then
			animationTimer1 = 1 / fps
			frame1 = frame1 + 1
			if frame1 > totalFrames then frame1 = 1 end
			xoffset1 = 100 * (frame1 - 1)
			ostrichSprite:setViewport(xoffset1, 0, 100, 100)
		end
	end

	-- OSTRICH2 ANIMATION CYCLE
	if player2.speedTier == 0 then
		frame2 = 1
		ostrichSprite2:setViewport(0, 0, 100, 100)
	end

	speedScale2 = (player2.speedTier * .035)
	animationTimer2 = animationTimer2 - speedScale2

	if player2.speedTier > 0 then 
		animationTimer2 = animationTimer2 - dt
		if animationTimer2 <= 0 then
			animationTimer2 = 1 / fps
			frame2 = frame2 + 1
			if frame2 > totalFrames then frame2 = 1 end
			xoffset2 = 100 * (frame2 - 1)
			ostrichSprite2:setViewport(xoffset2, 0, 100, 100)
		end
	end
	
	player1:update(dt)
	player2:update(dt)

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
		--'ANIMATION TIMER: ' ..tostring(animationTimer),
		'SPEED SCALE: ' ..tostring(speedScale),
	}, '\n'))
	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')

	player1:render()
	player2:render()
end 
