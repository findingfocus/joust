Player2 = Class{}

function Player2:init(x, y, width)
	self.x = x
	self.y = y
	self.width = width
	self.dy = 0
	self.speedTier = 0
	self.grounded = true
end

function Player2:update(dt)
	self.dy = self.dy + GRAVITY * dt
	self.y = math.min(VIRTUAL_HEIGHT - self.width - 50, self.dy + self.y)
	if self.y == VIRTUAL_HEIGHT - self.width - 50 then
		self.grounded = true
	elseif self.y < VIRTUAL_HEIGHT - self.width - 50 then
		self.grounded = false 
	end
	--bouncing off top
	if self.y < 0 then
		self.y = 0
		self.dy = 2
	end
	--[[
if love.keyboard.isDown('right') then
		self.x = (self.x + PLAYER_SPEED * dt) % VIRTUAL_WIDTH
		self.dx = 6
	end

---[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)

	if love.keyboard.isDown('left') then
		self.x = (self.x - PLAYER_SPEED * dt) % VIRTUAL_WIDTH
		PLAYER_SPEED = self.dx + 300
	end

	if love.keyboard.wasPressed('x') and grounded then
		self.dy = -30
	end
	--]]
end

function Player2:render()

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	if player2.facingRight then
		love.graphics.draw(ostrichAtlas2, ostrichSprite2, self.x, self.y, 0, -1, 1, 100)
	else
		love.graphics.draw(ostrichAtlas2, ostrichSprite2, self.x, self.y)
	end

end
