Egg = Class{}

function Egg:init(lastX, lastY, dx, index)
	self.x = lastX
	self.y = lastY
	self.index = index
	self.lastX = 0
	self.lastY = 0
	self.width = 8
	self.height = 8
	self.atlas = eggAtlas
	self.dx = dx
	self.dy = 0
	self.eggInvulnerableTimer = .05--.5
	self.bouncedOffFloor = false
	self.invulnerable = false
	self.collected = false
    self.midairBonus = true
	self.jockeySpawned = false
	self.graveyard = true
	self.eggSprite = love.graphics.newQuad(1, 0, self.width, self.height, self.atlas:getDimensions())
	self.hatched = false
	self.hatching = false
	self.hatchCountdown = 3--10
	self.hatchAnim = 0
	self.jockey = Jockey(-20, -20)
end

function Egg:groundCollide(collidable)
	if self.x < collidable.x + collidable.width - (BUFFER / 2) and self.x + self.width > collidable.x + (BUFFER / 2) and self.y + 6 < collidable.y + 2 and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:leftCollide(collidable)
	if self.x < collidable.x + collidable.width - 2 and self.x + (self.width / 2 - 2) > collidable.x + collidable.width - (self.width / 2) and self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:rightCollide(collidable)
	if self.x + (self.width / 2) < collidable.x + (self.width / 2 - 4) and self.x + self.width > collidable.x and self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
		return true
	end

	return false
end

function Egg:update(dt)
	if self.graveyard then
		self.x = -20
		self.y = -20
		self.dx = 0
		self.dy = 0
	else -- IF NOT GRAVEYARD
		if not self.collected then
			self.lastX = self.x
			self.lastY = self.y
		end

		self.x = self.x + self.dx
		if self.dx > 0 then
			self.dx = math.max(0, self.dx - .006)
		elseif self.dx < 0 then
			self.dx = math.min(0, self.dx + .006)
		end

		self.dy = self.dy + .02
		self.y = self.y + self.dy

		--LOOPS EGG to left side of screen
		if self.x > VIRTUAL_WIDTH - 1 and not self.collected then
			self.x = -self.width + 1
		end

		--LOOPS EGG to right side of screen
		if self.x < -self.width + 1 and not self.collected then
			self.x = VIRTUAL_WIDTH - 1
		end

		--EGG HATCHING ANIMATION
		if self.dx == 0 and not self.collected then
			self.hatchCountdown = self.hatchCountdown - dt
		end

		if self.hatchCountdown < 0 then
			self.hatchCountdown = 0
			self.hatching = true
		end

		if self.hatching then
			if self.hatchAnim < .4 then
				self.hatchAnim = self.hatchAnim + dt
			end

			if self.hatchAnim > .4 then
				self.hatching = false
				self.hatched = true
			elseif self.hatchAnim > .3 then --FRAME 4
				self.eggSprite:setViewport(28, 0, self.height, self.height)
			elseif self.hatchAnim > .2 then --FRAME 3
				self.eggSprite:setViewport(19, 0, self.height, self.height)
			elseif self.hatchAnim > .1 then --FRAME 2
				self.eggSprite:setViewport(10, 0, self.height, self.height)
			end
		end

		if self.invulnerable then
			self.eggInvulnerableTimer = self.eggInvulnerableTimer - dt
				if self.eggInvulnerableTimer < 0 then
					self.invulnerable = false
				end
		end

	end
end

function Egg:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(self.atlas, self.eggSprite, self.x, self.y)
    if self.bouncedOffFloor then
        love.graphics.print('bouncedTrue', self.x + 5, self.y)
    else
        love.graphics.print('bouncedFalse', self.x + 5, self.y)
    end
end
