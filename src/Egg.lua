Egg = Class{}

function Egg:init(lastX, lastY, dx)
	self.x = lastX
	self.y = lastY
	self.width = 8
	self.height = 8
	self.atlas = eggAtlas
	self.dx = dx
	self.dy = 0
	self.invulnerableTimer = 0
	self.invulnerable = false
	self.eggSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
end

function Egg:groundCollide(collidable)
	if self.x < collidable.x + collidable.width - BUFFER + 1 and self.x + self.width > collidable.x + BUFFER - 1 and self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
		return true
	end
	return false
end

function Egg:update(dt)
	self.x = self.x + self.dx
	if self.dx > 0 then
		self.dx = math.max(0, self.dx - .002)
	elseif self.dx < 0 then
		self.dx = math.min(0, self.dx + .002)
	end
	self.dy = self.dy + .02
	self.y = self.y + self.dy
end

function Egg:render()
	love.graphics.draw(self.atlas, self.eggSprite, self.x, self.y)
end