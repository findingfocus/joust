Player1 = Class{}

function Player1:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dy = 0
	self.speedTier = 0
	self.grounded = true
end

function Player1:update(dt)
	self.dy =  self.dy + GRAVITY * dt
	self.y = math.min(VIRTUAL_HEIGHT - self.height - 36, self.y + self.dy)
	if self.y == VIRTUAL_HEIGHT - self.height - 36 then
		self.y = VIRTUAL_HEIGHT - 56 --depends on where ground is, right now its only the bottom floor
		self.grounded = true
		self.height = 20
	elseif self.y < VIRTUAL_HEIGHT - self.height - 36 then
		self.grounded = false
		self.height = 17
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

	if love.keyboard.wasPressed('space') and grounded then
		self.dy = -30
	end
	--]]
end

function Player1:render()

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
--[[
	if player1.facingRight then
		love.graphics.draw(ostrichAtlas, ostrichSprite, self.x, self.y, 0, -1, 1, 100)
	else
		love.graphics.draw(ostrichAtlas, ostrichSprite, self.x, self.y)
	end
--]]
end