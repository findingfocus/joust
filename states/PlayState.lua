PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - 36 - 20, 16, 24)
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
		'jumpTimer: ' ..tostring(player1.jumpTimer),
		'flapped: ' ..tostring(player1.flapped),
	}, '\n'))

	player1:render()
end