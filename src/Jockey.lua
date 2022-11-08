Jockey = Class{}

function Jockey:init(x, y)
self.x = x
self.y = y
self.image = whiteJockey
end

function Jockey:update(dt)

end

function Jockey:render()
	love.graphics.draw(self.image, self.x, self.y - 6)
end