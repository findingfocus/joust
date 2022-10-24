Egg = Class{}

function Egg:init(lastX, lastY, dx)
	self.x = lastX
	self.y = lastY
	self.lastX = 0
	self.lastY = 0
	self.width = 8
	self.height = 8
	self.atlas = eggAtlas
	self.dx = dx
	self.dy = 0
	self.invulnerableTimer = 0
	self.invulnerable = false
	self.collected = false
	self.eggSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
end

function Egg:groundCollide(collidable)
	if self.x < collidable.x + collidable.width - (BUFFER / 2) and self.x + self.width > collidable.x + (BUFFER / 2) and self.y + 6 < collidable.y + 2 and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:leftCollide(collidable)
	if self.x < collidable.x + collidable.width - 2 and self.x + (self.width / 2 - 2) > collidable.x + collidable.width - (self.width / 2) and self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:rightCollide(collidable)
	if self.x + (self.width / 2) < collidable.x + (self.width / 2 - 4) and self.x + self.width > collidable.x and self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:eggGrounded(collidable)
	if self.x < collidable.x + collidable.width and self.x + self.width > collidable.x then
		if self.y == collidable.y - self.height then
			return true
		end
	end

	return false
end

function Egg:update(dt)
	if not self.collected then
		self.lastX = self.x
		self.lastY = self.y
	end 

	self.x = self.x + self.dx
	if self.dx > 0 then
		self.dx = math.max(0, self.dx - .002)
	elseif self.dx < 0 then
		self.dx = math.min(0, self.dx + .002)
	end
	self.dy = self.dy + .02
	self.y = self.y + self.dy

	--LOOPS EGG to left side of screen
	if self.x > VIRTUAL_WIDTH then
		self.x = -self.width
	end

	--LOOPS EGG to right side of screen
	if self.x < -self.width then
		self.x = VIRTUAL_WIDTH
	end
end

function Egg:render()
	love.graphics.draw(self.atlas, self.eggSprite, self.x, self.y)
end