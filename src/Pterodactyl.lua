Pterodactyl = Class{}

function Pterodactyl:init(x, y, dx)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = .5
	self.width = 24
	self.height = 16
	self.fps = 3
	self.animationTimer = 1 / self.fps
	self.frame = 1
	self.xoffset = 1
	self.totalFrames = 3
	self.facingRight = true
	self.exploded = false
	self.graveyard = true
	self.atlas = pterodactylAtlas
	self.pterodactylSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	self.mouseX = 0
	self.mouseY = 0
	self.lastX = 0
	self.lastY = 0
	self.explodedTimer = 2
end

function Pterodactyl:leftCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x > collidable.x + collidable.width - 4 then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end

function Pterodactyl:rightCollides(collidable)
	if self.x + self.width < collidable.x + 4 and self.x + self.width > collidable.x then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end

function Pterodactyl:topCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x + self.width > collidable.x then
		if self.y < collidable.y + collidable.height and self.y > collidable.y + collidable.height - 3 then
			return true
		end
	end

	return false
end

function Pterodactyl:bottomCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x + self.width > collidable.x then
		if self.y + self.height < collidable.y + 3 and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end



function Pterodactyl:update(dt)
	if not self.exploded then
		if not self.graveyard then
			self.x = self.x + self.dx
			self.y = self.y + self.dy
		--self.mouseX = love.mouse.getX()
		--self.mouseY = love.mouse.getY()
		--self.x = self.mouseX
		--self.y = self.mouseY
			self.lastX = self.x
			self.lastY = self.y
		end

		if self.dx > 0 then
			self.facingRight = true
		else
			self.facingRight = false
		end

		--OVERWRITES DIRECTION, PLEASE ADJUST WHEN SPAWNING LOGIC IN PLACE
		--self.facingRight = false


	---[[
		if not self.graveyard then
			if self.x > VIRTUAL_WIDTH then
				self.x = -self.width
			end

			if self.x + self.width < 0 then
				self.x = VIRTUAL_WIDTH
			end

			--BOUNCES PTERO OFF FLOOR
			if self.y + self.height > groundPlatform.y then --GROUND
				self.y = groundPlatform.y - self.height
				self.dy = self.dy * -1
			end
			--BOUNCES PTERO OFF TOP OF SCREEN
			if self.y < 0 then --TOP OF SCREEN COLLISION
				self.y = 0
				self.dy = math.abs(self.dy)
			end
		end
	--]]
		self.animationTimer = self.animationTimer - dt

		if self.animationTimer <= 0 then
			self.animationTimer = 1 / self.fps
			self.frame = self.frame + 1
			if self.frame > self.totalFrames then self.frame = 1 end
			self.xoffset = (self.width * (self.frame - 1)) + self.frame
			self.pterodactylSprite:setViewport(self.xoffset, 0, self.width, self.height)
		end
	else -- If exploded
		self.x = -25
		self.y = -25
		self.dx = 0
		self.dy = 0

		if self.explodedTimer > 0 then
			self.explodedTimer = self.explodedTimer - dt
		end
	end
end

function Pterodactyl:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	if not self.exploded then
		if self.facingRight then
			love.graphics.draw(self.atlas, self.pterodactylSprite, self.x, self.y)
		else
			love.graphics.draw(self.atlas, self.pterodactylSprite, self.x, self.y, 0, -1, 1, self.width)
		end
	else --IF EXPLODED
		self.pterodactylSprite:setViewport(75, 0, self.width, self.height)
		if self.explodedTimer > 0 then
			if self.facingRight then
				love.graphics.draw(self.atlas, self.pterodactylSprite, self.lastX, self.lastY)
			else
				love.graphics.draw(self.atlas, self.pterodactylSprite, self.lastX, self.lastY, 0, -1, 1, self.width)
			end
		end
	end
end
