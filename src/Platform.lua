Platform = Class{}

function Platform:init(name, x, y, width, height)
	self.name = name
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.leftHalf = love.graphics.newQuad(0, 0, width / 2, 7, platformLeft:getDimensions())
	self.rightHalf = love.graphics.newQuad(0, 0, platformRight:getWidth(), platformRight:getHeight(), platformRight:getDimensions())
	self.rightHalf:setViewport(PLATFORMOFFSET, 0, platformRight:getWidth() - PLATFORMOFFSET, platformRight:getHeight())
end

function Platform:update(dt)

end

function Platform:render()
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.draw(platformLeft, self.leftHalf, self.x, self.y)
	love.graphics.draw(platformRight, self.rightHalf, self.x + (self.width - platformRight:getWidth()) + PLATFORMOFFSET, self.y)
--	love.graphics.draw(platformRight, self.rightHalf, self.x + (self.width - platformRight:getWidth()) + PLATFORMOFFSET, self.y)
	--love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
