PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - 36 - 20, 16, 20)
end

function PlayState:update(dt)

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('r') then
		player1.x = VIRTUAL_WIDTH / 3 - 8
		player1.y = VIRTUAL_HEIGHT - 36 - player1.height
		player1.speedTier = 0
		player1.facingRight = true
		player1.dx = 0
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
		sounds['skid']:stop()
	end

--[[
-- OSTRICH1 ANIMATION CYCLE
	if player1.speedTier == 0 and player1.grounded then
		frame = 1
		ostrichSprite:setViewport(0, 0, 100, 100)
	end
	
	speedScale = (player1.speedTier * .035)
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
--]]

	
	player1:update(dt)

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
		'PLAYER1.DY: ' ..tostring(string.format("%.2f", player1.dy)),
		'PLAYER1.grounded: ' ..tostring(player1.grounded),
		'PLAYER1.skid: ' ..tostring(player1.skid),
		'PLAYER1.dx: ' ..tostring(string.format("%.2f", player1.dx)),
	}, '\n'))

	player1:render()
end