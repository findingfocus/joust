Taxi = Class{}

function Taxi:init(x, y, width, height, dx, index)
	self.x = x
	self.y = y
	self.lastX = 0
	self.lastY = 0
	self.index = index
	self.dx = dx * .5
	self.dy = 0
	self.frame = 1
	self.animationTimer = .06
    self.needsToJump = false
    self.flapped = false
    self.flapCounter = 0
	self.facingRight = true
	self.graveyard = true
	self.grounded = false
	self.ground = Platform('name', 1, 1, 1, 1)
	self.width = width
	self.height = height
	self.tier = 1
	self.atlas = hunterTaxiAtlas
	taxi1Sprite = love.graphics.newQuad(1, 0, self.width, self.height, self.atlas:getDimensions())
end

function Taxi:collides(collidable)
	if self.x < collidable.x + collidable.width - BUFFER / 2 and self.x + self.width > collidable.x + BUFFER / 2 then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y + BUFFER / 2 then
			return true
		end
	else
		return false
	end
end

function Taxi:checkGrounded(collidablePlatforms)
	if self.y == collidablePlatforms.y - self.height then
		if self.x < collidablePlatforms.x + collidablePlatforms.width - BUFFER and self.x + self.width > collidablePlatforms.x + BUFFER then
			return true
		end
	else
		return false
	end
end

function Taxi:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Taxi:topCollides(collidable)
    if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
        if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
            return true
        end
    end

    return false
end

function Taxi:rightCollides(collidable)
	if (self.x + self.width > collidable.x + BUFFER and self.x + self.width < collidable.x + collidable.width - BUFFER) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Taxi:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width - BUFFER and self.x > collidable.x + BUFFER) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Taxi:update(dt)
	if self.tier == 1 then
		self.atlas = hunterTaxiAtlas
	else
		self.atlas = shadowlordTaxiAtlas
	end

	if not self.graveyard then
		self.lastX = self.x
		self.lastY = self.y

		if self.x > VIRTUAL_WIDTH then
			self.x = -self.width
		end

		if self.x < -self.width then
			self.x = VIRTUAL_WIDTH
		end

		if self.dx > 0 then
			self.facingRight = true
		else
			self.facingRight = false
		end

		self.y = self.y + self.dy

		self.x = self.x + self.dx

        if self.y < 0 then
            self.dy = 0
            self.y = 0
        end

		--ENSURES GROUND FIELD IS PLATFORM THAT WE ARE STANDING ON, NOT JUST PLATFORM WE BOTTOM COLLIDED WITH
		if self:checkGrounded(groundPlatform) then
			self.ground = groundPlatform
		end

		for k, platform in pairs(collidablePlatforms) do
			if self:checkGrounded(platform) then
				self.ground = platform
			end
		end

---[[ TAXI AND PLATFORM COLLISION
		if self:bottomCollides(groundPlatform) then
			self.dy = 0
			self.grounded = true
			self.height = 24
			self.ground = groundPlatform
			self.y = groundPlatform.y - self.height
			taxi1Sprite:setViewport(1, 0, self.width, 24, self.atlas:getDimensions())
		end

		for k, platform in pairs(collidablePlatforms) do

			if self:bottomCollides(platform) then
				self.dy = 0
				self.grounded = true
				self.height = 24
				self.ground = platform
				self.y = platform.y - self.height
				taxi1Sprite:setViewport(1, 0, self.width, 24, self.atlas:getDimensions())
			end

			if self:leftCollides(platform) then
				self.dx = math.abs(self.dx)
				self.x = platform.x + platform.width
			end

			if self:rightCollides(platform) then
				self.dx = math.abs(self.dx) * -1
				self.x = platform.x - self.width
			end

            if self:topCollides(platform) then
               self.flapped = false
               self.dy = 0
               self.y = platform.y + platform.height
            end
		end

		--ACTIVATING GRAVITY
		if not self:checkGrounded(self.ground) then
			self.grounded = false
			self.height = 16
		end

		if not self.grounded then
			self.dy = self.dy + GRAVITY * dt
		end

        if self.y > Jockeys[self.index].y then
            self.needsToJump = true
        end

        if self.needsToJump then
            self.flapped = true
            self.dy = -.6
            self.flapCounter = .1
            self.needsToJump = false
        end

        if self.flapped then
            self.flapCounter = self.flapCounter - dt
        end

        if self.flapCounter <= 0 then
            self.flapped = false
            self.flapCounter = 0
        end

		self.animationTimer = self.animationTimer - dt

		if self.animationTimer < 0 then
			--GROUNDED ANIMATION
			taxi1Sprite:setViewport(self.frame + (self.width * (self.frame - 1)), 0, self.width, 24, self.atlas:getDimensions())
			self.frame = self.frame + 1
			if self.frame > 4 then
				self.frame = 1
			end
			self.animationTimer = .06
		end

		if not self.grounded and not self.flapped then
			taxi1Sprite:setViewport(6 + (self.width * 5), 0, self.width, 16, self.atlas:getDimensions())
        elseif not self.grounded and self.flapped then
			taxi1Sprite:setViewport(6 + (self.width * 6), 0, self.width, 16, self.atlas:getDimensions())
		end

	else -- IF GRAVEYARD
		self.x = -40
		self.y = -40
		self.dx = 0
		self.dy = 0
	end
end

function Taxi:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	if self.facingRight then
		--love.graphics.print(tostring(self.index), self.x, self.y)
		--love.graphics.print(tostring(self:checkGrounded(platform2)), self.x, self.y)
		--love.graphics.print(tostring(self.grounded), self.x, self.y)
		love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, 1, 1)
	else
		--love.graphics.print(tostring(self.index), self.x, self.y)
		--love.graphics.print(tostring(self:checkGrounded(platform2)), self.x, self.y)
		--love.graphics.print(tostring(self.grounded), self.x, self.y)
		love.graphics.draw(self.atlas, taxi1Sprite, self.x, self.y, 0, -1, 1, self.width)
	end

end
