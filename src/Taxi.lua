Taxi = Class{}

function Taxi:init(x, y, width, height)
	self.x = x
	self.y = y
	self.dx = 0
	self.frame = 1
	self.animationTimer = .06
	self.width = width
	self.height = height
	self.atlas = taxi1Atlas
	taxi1Sprite = love.graphics.newQuad(1, 0, self.width, self.height, self.atlas:getDimensions())
end

function Taxi:update(dt)
	self.animationTimer = self.animationTimer - dt

	if self.animationTimer < 0 then
		taxi1Sprite:setViewport(self.frame + (self.width * (self.frame - 1)), 0, self.width, self.height, self.atlas:getDimensions())
		self.frame = self.frame + 1
		if self.frame > 4 then
			self.frame = 1
		end
		self.animationTimer = .06
	end
end

function Taxi:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, 1, 1)
end