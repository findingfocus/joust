Ostrich = Class{}

function Ostrich:init(x, y, width)
	self.x = x
	self.y = y
	self.width = width
	self.dy = 0
	self.speedTier = 0
end

function Ostrich:update(dt)
	self.dy = self.dy + GRAVITY * dt
	self.y = math.min(VIRTUAL_HEIGHT - self.width - 50, self.dy + self.y)

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

	if love.keyboard.wasPressed('space') and grounded then
		self.dy = -30
	end
	--]]
end

function Ostrich:render()

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.setColor(255/255, 70/255, 70/255, 255/255)

	love.graphics.draw(ostrichAtlas, ostrichSprite, self.x, self.y)

end