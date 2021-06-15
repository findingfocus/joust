TripState = Class{__includes = BaseState}

function TripState:init() 

end

playerX = 0
PLAYER_SPEED = 250
local GRAVITY = 20
playerY = 800 - 110
playerDY = 0
grounded = true

function TripState:update(dt)
	--sounds['tripMusic']:setLooping(true)
	--sounds['tripMusic']:play()

	playerDY = playerDY + GRAVITY * dt

	if love.keyboard.isDown('right') then
		playerX = math.min(VIRTUAL_WIDTH - 110, playerX + PLAYER_SPEED * dt)
	end

	if love.keyboard.isDown('left') then
		playerX = math.max(0, playerX - PLAYER_SPEED * dt)
	end

	if love.keyboard.wasPressed('space') and grounded then
		playerDY = -20
	end

	if playerY == 690 then
		grounded = true
	else
		grounded = false
	end

	if love.keyboard.wasPressed('r') then
		--sounds['tripMusic']:stop()
		playerX = 0
		playerY = 800 - 110
		playerDY = 0
		gStateMachine:change('titleState')
	end
--[[
	redScroll = (redScroll + RED_SCROLL_SPEED * dt)
		% LOOPING_POINT

	greenScroll = (greenScroll + GREEN_SCROLL_SPEED * dt)
		% LOOPING_POINT

	blueScroll = (blueScroll + BLUE_SCROLL_SPEED * dt)
		% LOOPING_POINT

	cloudScroll = (cloudScroll + CLOUD_SCROLL_SPEED * dt)
		% CLOUD_LOOPING_POINT
--]]
	playerY = math.min(VIRTUAL_HEIGHT - 110, playerY + playerDY)
end


function TripState:render()
	love.graphics.clear(150/255, 150/255, 150/255, 255/255)

	love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	love.graphics.rectangle('fill', playerX, playerY, 110, 110)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.draw(clouds, -cloudScroll, 0)
	--love.graphics.draw(redScreen, -redScroll, 0)
	--love.graphics.draw(greenScreen, -greenScroll, 0)
	--love.graphics.draw(blueScreen, -blueScroll, 0)

	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello TripState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end
