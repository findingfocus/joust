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
    self.retracting = false
    self.retractingLeftWidth = 0
    self.retractingRightX = x + width
    self.retractingRightWidth = 0
end

function Platform:update(dt)

end

function Platform:render()
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.draw(platformLeft, self.leftHalf, self.x, self.y)
    if self.name == 'platform3' then
        love.graphics.draw(platform3Sprite, self.x, self.y)
    elseif self.name == 'platform2' then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.draw(platformRight, self.rightHalf, self.x + (self.width - platformRight:getWidth()) + PLATFORMOFFSET, self.y)
        love.graphics.draw(platformSpawn, self.x + 15, self.y)
    else
        --ADD RIGHT SIDE FOR EVERY OTHER MAIN PLATFORM WITH SPAWNZONE POINT
        love.graphics.draw(platformRight, self.rightHalf, self.x + (self.width - platformRight:getWidth()) + PLATFORMOFFSET, self.y)
    end

    if self.retracting then
        love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
        love.graphics.rectangle('fill', self.x, self.y, self.retractingLeftWidth, 7)
        love.graphics.rectangle('fill', self.retractingRightX, self.y, self.retractingRightWidth, 7)
    end
end
