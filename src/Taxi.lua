Taxi = Class{}

function Taxi:init(x, y, width, height, dx, index)
	self.x = x
	self.y = y
	self.index = index
	self.dx = dx * .5
	self.dy = 0
	self.frame = 1
	self.animationTimer = .06
	self.facingRight = true
	self.graveyard = true
	self.width = width
	self.height = height
	self.atlas = taxi1Atlas
	taxi1Sprite = love.graphics.newQuad(1, 0, self.width, self.height, self.atlas:getDimensions())
end

function Taxi:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Taxi:rightCollides(collidable)
	if (self.x + self.width > collidable.x and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Taxi:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Taxi:update(dt)
	if not self.graveyard then

		if self.dx > 0 then
			self.facingRight = true
		else
			self.facingRight = false
		end

		self.animationTimer = self.animationTimer - dt

		for k, platform in pairs(collidablePlatforms) do
			self.grounded = true
			if not PlayState:checkGrounded(self, platform) or not PlayState:checkGrounded(self, groundPlatform) then
				self.dy = self.dy + GRAVITY * dt
			end
		end

		--self.dy = self.dy + GRAVITY * dt

		self.y = self.y + self.dy

		self.x = self.x + self.dx 


		if self:bottomCollides(groundPlatform) then
			self.y = groundPlatform.y - self.height
		end

		for k, platform in pairs(collidablePlatforms) do
			if self:bottomCollides(platform) then
				self.dy = 0
				self.y = platform.y - self.height
			end
		end

		if self.animationTimer < 0 then
			taxi1Sprite:setViewport(self.frame + (self.width * (self.frame - 1)), 0, self.width, self.height, self.atlas:getDimensions())
			self.frame = self.frame + 1
			if self.frame > 4 then
				self.frame = 1
			end
			self.animationTimer = .06
		end
	else -- IF GRAVEYARD
		self.x = -20
		self.y = -20
		self.dx = 0
		self.dy = 0
	end
end

function Taxi:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	if self.facingRight then
		love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, 1, 1)
	else
		love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, -1, 1, self.width)
	end
	
end