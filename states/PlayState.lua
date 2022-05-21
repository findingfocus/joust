PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Player1(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - 36 - 20, 16, 20)
	--player2 = Player2(VIRTUAL_WIDTH - VIRTUAL_WIDTH / 3 - 50, VIRTUAL_HEIGHT - 150, 100)
	--player2.facingRight = false
	slowScale = .3
	fps = 1
	animationTimer1 = 1 / fps
	animationTimer2 = 1/ fps
	frame1 = 1
	frame2 = 1
	totalFrames = 4
	xoffset1 = 100
	xoffset2 = 100
	ostrichAtlas = love.graphics.newImage('src/pics/ostrichAtlas1-6panel.png')
	ostrichAtlas2 = love.graphics.newImage('src/pics/ostrichAtlas2-6panel.png')
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
	deltaTime = dt

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end




--[[
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
--]]




--[[
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
--]]


	--player1.x = player1.x % VIRTUAL_WIDTH
	--player2.x = player2.x % VIRTUAL_WIDTH

--[[
	if love.keyboard.isDown('left') then
		player1.x = (player1.x - playerSpeed * dt) % VIRTUAL_WIDTH
	end

		--PLAYER MOVING RIGHT
	if love.keyboard.isDown('right') then
		player1.x = (player1.x + playerSpeed * dt) % VIRTUAL_WIDTH
	end
--]]






--[[
--INCREMENT PLAYER2 SPEED TO THE LEFT
	if love.keyboard.wasPressed('left') and player2.speedTier < 5 then

		--TURNING
		if player2.speedTier == 0 then
			player2.facingRight = false
		end
		--SPEED INCREMEMENT
		player2.speedTier = player2.speedTier + 1
	end

		--BRAKES
	if love.keyboard.wasPressed('left') and player2.facingRight then
		player2.speedTier = 0
	end
--]]



--[[
	--INCREMEMENT PLAYER2 SPEED TO THE RIGHT
	if love.keyboard.wasPressed('right') and player2.speedTier < 5 then
		
		--TURNING
		if player2.speedTier == 0 then
			player2.facingRight = true
		end

		--SPEED INCREMENT
		player2.speedTier = player2.speedTier + 1
	end
	--]]


--[[
	--BRAKES FOR PLAYER2
	if love.keyboard.wasPressed('right') and not player2.facingRight then
		player2.speedTier = 0
	end
--]]

--[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)

	if love.keyboard.wasPressed('left') or 

	end

	--]]



--old jump logic
--[[
	if love.keyboard.wasPressed('space') then
		if player1.dy < -5 then
			player1.dy = - 8
		elseif player1.dy < -4 then
			player1.dy = -6
		elseif player1.dy < -3 then
			player1.dy = -5
		elseif player1.dy < -2 then
			player1.dy = -4
		elseif player1.dy < -1 then
			player1.dy = -3
		else
			player1.dy = -2
		end
	end
--]]

--[[
	if love.keyboard.wasPressed('w') and not player1.grounded then
		ostrichSprite:setViewport(500, 0, 100, 100)
		--ostrichSprite:setViewport(400, 0, 100, 100)
	end
	--]]


--[[
		--PLAYER2 JUMPING
	if love.keyboard.wasPressed('up') then
		if player2.dy < -5 then
			player2.dy = - 8
		elseif player2.dy < -4 then
			player2.dy = -6
		elseif player2.dy < -3 then
			player2.dy = -5
		elseif player2.dy < -2 then
			player2.dy = -4
		elseif player2.dy < -1 then
			player2.dy = -3
		else
			player2.dy = -2
		end
	end
--]]



	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		--gStateMachine:change('titleState')
		player1.x = VIRTUAL_WIDTH / 3 - 8
		--player2.x = VIRTUAL_WIDTH - VIRTUAL_WIDTH / 3 - 50
		player1.y = VIRTUAL_HEIGHT - 36 - player1.height
		--player2.y = VIRTUAL_HEIGHT - 50 - player2.width
		--playerDY = 0
		player1.speedTier = 0
		--player2.speedTier = 0
		player1.facingRight = true
		player1.dx = 0
		--player2.facingRight = false
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
		sounds['skid']:stop()
	end


-- OSTRICH1 ANIMATION CYCLE
	if player1.speedTier == 0 and player1.grounded then
		frame = 1
		ostrichSprite:setViewport(0, 0, 100, 100)
	end
	
	speedScale = (player1.speedTier * .035)
	--speedScale2 = (player2.speedTier * .035)
	animationTimer1 = animationTimer1 - speedScale

	if player1.speedTier > 0 and player1.grounded then 
		animationTimer1 = animationTimer1 - dt
		if animationTimer1 <= 0 then
			animationTimer1 = 1 / fps
			frame1 = frame1 + 1
			if frame1 > totalFrames then frame1 = 1 end
			xoffset1 = 100 * (frame1 - 1)
			ostrichSprite:setViewport(xoffset1, 0, 100, 100)
		end
	end

	--PLAYER 1 AERIAL ANIMATION HANDLING
	if not player1.grounded then
		if love.keyboard.wasPressed('w') and not player1.grounded then
			ostrichSprite:setViewport(500, 0, 100, 100)
		else
			ostrichSprite:setViewport(400, 0, 100, 100)
		end

	end

--[[
	-- OSTRICH2 ANIMATION CYCLE
	if player2.speedTier == 0 and player2.grounded then
		frame2 = 1
		ostrichSprite2:setViewport(0, 0, 100, 100)
	end

	speedScale2 = (player2.speedTier * .035)
	animationTimer2 = animationTimer2 - speedScale2

	if player2.speedTier > 0 and player2.grounded then 
		animationTimer2 = animationTimer2 - dt
		if animationTimer2 <= 0 then
			animationTimer2 = 1 / fps
			frame2 = frame2 + 1
			if frame2 > totalFrames then frame2 = 1 end
			xoffset2 = 100 * (frame2 - 1)
			ostrichSprite2:setViewport(xoffset2, 0, 100, 100)
		end
	end

	--PLAYER 2 AERIAL ANIMATION HNADLING
	if not player2.grounded then
		if love.keyboard.wasPressed('up') and not player2.grounded then
			ostrichSprite2:setViewport(500, 0, 100, 100)
		else
			ostrichSprite2:setViewport(400, 0, 100, 100)
		end
	end
--]]
	
	player1:update(dt)
	--player2:update(dt)

end

function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 13, VIRTUAL_WIDTH, 13)


	--draw ground top level **to be made retractable
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 4)

	--ground bottom stand-in
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	love.graphics.setFont(smallFont)
	love.graphics.print(table.concat({
		'',
		'',
		'',
		'PLAYER1.X: '..math.floor(player1.x),
		'PLAYER1.Y: '..math.floor(player1.y),
		'PLAYER1.facingRight: '..tostring(player1.facingRight),
		--'ANIMATION TIMER: ' ..tostring(animationTimer),
		'PLAYER1.speedTier: '..math.floor(player1.speedTier),
		'SPEED SCALE: ' ..tostring(speedScale),
		'PLAYER1.DY: ' ..tostring(string.format("%.2f", player1.dy)),
		--'PLAYER2.DY: ' ..tostring(math.floor(player2.dy)),
		'PLAYER1.grounded: ' ..tostring(player1.grounded),
		'PLAYER1.skid: ' ..tostring(player1.skid),
		'PLAYER1.dx: ' ..tostring(string.format("%.2f", player1.dx)),
		'frameTracker: ' ..tostring(string.format("%.4f", player1.frameTracker)),
		--'PLAYER2.grounded: ' .. tostring(player2.grounded),
	}, '\n'))
	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')

	player1:render()
	--player2:render()
end