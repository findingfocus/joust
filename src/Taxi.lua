Taxi = Class{}

function Taxi:init(x, y, width, height)
	self.x = x
	self.y = y
	self.dx = 0
	self.width = width
	self.height = height
	self.atlas = taxi1Atlas
	taxi1Sprite = love.graphics.newQuad(1, 0, self.width, self.height, self.atlas:getDimensions())
end

function Taxi:update(dt)
	
end

function Taxi:render()
	love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, 1, 1)
end