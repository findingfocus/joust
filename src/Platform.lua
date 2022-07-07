Platform = Class{}

function Platform:init(name, x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.name = name
end

function Platform:update(dt)

end

function Platform:render()
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end