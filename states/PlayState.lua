PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 2 - 50, 500)
	PLAYER_SPEED = 500
	GRAVITY = 120
end

function PlayState:update(dt)
	--sounds['playMusic']:setLooping(true)
	--sounds['playMusic']:play()
	player1:update(dt)
	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		gStateMachine:change('titleState')
		playerX = 0
		playerY = 800 - 110
		playerDY = 0
	end


end


function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	love.graphics.setColor(255/255, 193/255, 87/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 50)

	player1:render()
	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end 

