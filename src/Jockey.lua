Jockey = Class{}

function Jockey:init(x, y)
self.x = x
self.y = y - 6
self.width = 8
self.height = 14
self.image = whiteJockey
self.lastX = -20
self.lastY = -20
self.collected = false
self.graveyard = true
end

function Jockey:update(dt)
	if self.graveyard then
		self.x = -20
		self.y = -20
	end

	if not self.collected then
		self.lastX = self.x
		self.lastY = self.y
	end

end

function Jockey:render()
	love.graphics.draw(self.image, self.x, self.y)
end