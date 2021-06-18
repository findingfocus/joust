Ostrich = Class{}

function Ostrich:init(x, y)
	self.x = x
	self.y = y
	self.width = 100
	self.dy = 0
end

function Ostrich:update(dt)
	self.dy = self.dy + GRAVITY * dt
	self.y = math.min(VIRTUAL_HEIGHT - self.width - 50, self.dy + self.y)

	if love.keyboard.isDown('right') then
		self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + PLAYER_SPEED * dt)
	end

	if love.keyboard.isDown('left') then
		self.x = math.max(0, self.x - PLAYER_SPEED * dt)
	end

	if love.keyboard.wasPressed('space') and grounded then
		self.dy = -30
	end
end

function Ostrich:render()
	love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.width)
end