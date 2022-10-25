PrintScore = Class{}

function PrintScore:init(lastX, lastY, scoreAmount)
	self.timer = 0
	self.lastX = lastX
	self.lastY = lastY
	self.scoreAmount = scoreAmount
	self.doubleScore = true
end

function PrintScore:update(dt)
	if self.timer > 0 then
		self.timer = self.timer - dt
	end

	if self.timer < 0 then
		self.timer = 0
	end
end

function PrintScore:render()
	if self.timer > 0 then
		love.graphics.setFont(smallerFont)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print(tostring(self.scoreAmount), self.lastX, self.lastY)
		if self.doubleScore == true then
			love.graphics.setColor(255/255, 255/255, 77/255, 255/255)
			love.graphics.print(tostring(self.scoreAmount), self.lastX, self.lastY - 8)
		end
	end
end