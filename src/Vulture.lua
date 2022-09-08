Vulture = Class{}

function Vulture:init(x, y, width, height, platformSpawn)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.atlas = vultureAtlas
	self.dy = 0
	self.dx = 0
	self.justStoppedTimer = INPUTLAG
	self.justTurnedTimer = INPUTLAG
	self.grounded = false
	self.skid = false
	self.facingRight = false
	self.flapped = false
	self.justStopped = false
	self.justTurned = false
	self.lastInputLocked = false
	self.alternate = false
	self.collideTimer = 0 
	self.justCollided = false
	self.fps = 1
	self.animationTimer = 2 / self.fps
	self.jumpTimer = 0
	self.frame = 1
	self.totalFrames = 4
	self.xoffset = self.width
	self.ground = Platform('name', 1, 1, 1, 1)
	vultureSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	vultureSpawnViewport = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	self.jumping = false
	self.jumpCounter = math.random(3, 5)
	self.spawning = true
	self.exploded = false
	self.platformSpawn = platformSpawn
	self.spawnHeight = 0
end

function Vulture:checkGrounded(collidablePlatforms)
	if self.y == collidablePlatforms.y - self.height then
		if self.x < collidablePlatforms.x + collidablePlatforms.width - BUFFER and self.x + self.width > collidablePlatforms.x + BUFFER then
			return true
		else
			return false
		end
	end
	return false
end

function Vulture:topCollides(collidable)
	if (self.y < collidable.y + collidable.height and self.y > collidable.y) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Vulture:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Vulture:rightCollides(collidable)
	if (self.x + self.width > collidable.x + BUFFER / 2 and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Vulture:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width - BUFFER / 2 and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

--lastInput = {"right"}


function Vulture:update(dt)
	
	if self.spawning then
		self.spawnHeight = self.spawnHeight + 0.5
		vultureSpawnViewport:setViewport(0, 0, self.width, self.spawnHeight, self.atlas:getDimensions())
		if self.y < self.platformSpawn.y - self.height then
			self.y = self.platformSpawn.y - self.height
			self.spawning = false
		end
		self.y = self.y - 0.5
	else
		self.jumpCounter = self.jumpCounter - dt

			if self.jumpCounter < 0 then
				self.jumping = true
				self.jumpCounter = math.random(1, 2)
			end
			---[[

			--COLLISION OF MAIN GROUND PLATFORM
			if self:bottomCollides(groundPlatform) then
				self.height = 24
				self.y = groundPlatform.y - self.height
				self.dy = 0
				self.grounded = true
			end

			if self:checkGrounded(groundPlatform) then
				self.ground = groundPlatform
			end

			--CYCLE THROUGH PLATFORMS
			for index, platform in pairs(collidablePlatforms) do
					--BOTTOM COLLIDES
				if self:bottomCollides(platform) then
					self.height = 24
					self.y = platform.y - self.height
					self.dy = 0
					self.grounded = true
				end

				if self:checkGrounded(platform) then
					self.ground = platform
				end

				if self:topCollides(platform) then
					if self.dy < 0 then
						self.dy = math.abs(self.dy) - GRAVITYNEGATE
						self.y = platform.y + platform.height + 1
					end
				end


				--LEFT COLLIDES SETS POSITIVE DX
				if self:leftCollides(platform) then
					if self.dx > .1 or self.dx < -.1 then
						if self.collideTimer == 0 then
							self.justCollided = true
							sounds['collide']:play()
						end
					end
					self.dx = math.abs(self.dx)
				end

				--RIGHT COLLIDES SETS POSITIVE DX
				if self:rightCollides(platform) then
					if self.dx > .1 or self.dx < -.1 then
						if self.collideTimer == 0 then
							self.justCollided = true
							sounds['collide']:play()
						end
					end
					if self.dx > 0 then
						self.dx = -self.dx
					end
				end	

				if self.justCollided then
					self.collideTimer = self.collideTimer + dt
					if self.collideTimer > COLLIDETIMERTHRESHOLD then
						self.justCollided = false
						self.collideTimer = 0
					end
				end
			end

			if not self:checkGrounded(self.ground) then
				self.grounded = false
			end


			--APPLY GRAVITY WHEN IN AIR
			if not self.grounded then
				self.dy =  self.dy + GRAVITY * dt
			end

			self.y = self.y + self.dy

			--ENSURES OSTRICH FACING DIRECTION OF DX - SKID LOGIC FOR > SPEED 2
			if self.grounded and self.dx > 0 then
				--self.facingRight = true
		--OLD SKID WHILE IN AIR LOGIC PLACE
			elseif self.grounded and self.dx < 0 then
				--self.facingRight = false
		---OLD SKID WHILE IN AIR LOGIC PLACE
			end
			
			--BOUNCING OFF TOP
			if self.y < 0 then
				self.y = 0
				self.dy = math.abs(self.dy) - GRAVITYNEGATE
			end
			
			--LOOPS player to left side of screen
			if self.x > VIRTUAL_WIDTH then
				self.x = -self.width
			end

			--LOOPS player to right side of screen
			if self.x < -self.width then
				self.x = VIRTUAL_WIDTH
			end


			

			if self.grounded then
				self.height = 24
				
			--AERIAL HANDLING
			elseif not self.grounded then
				self.skid = false
				self.height = 16
			end

				--VULTURE JUMPING HEIGHT
			if self.jumping then
				self.grounded = false
				self.dy = -.4
			end

			self.jumping = false
			self.dx = -1
			self.x = self.x + self.dx


		-- OSTRICH1 ANIMATION CYCLE

			self.fps = (math.abs(self.dx)) * .42 - (math.abs(self.dx) / 20 - .15)

			self.animationTimer = self.animationTimer - self.fps

			--STANDING STILL VIEWPORT
			if self.dx == 0 and self.grounded then
				self.frame = 1
				vultureSprite:setViewport(1, 0, self.width, self.height)
			end

			--VULTURE WALKING ANIMATION
			if self.dx ~= 0 and self.grounded then 
				self.animationTimer = self.animationTimer - dt
				if self.animationTimer <= 0 then
					self.animationTimer = 1 / self.fps
					self.frame = self.frame + 1
					---[[
					if self.frame == 2 and self.alternate then
						self.alternate = false
						--sounds['leftStep']:play()
					elseif self.frame == 2 and not self.alternate then
						self.alternate = true
						--sounds['rightStep']:play()
					end
					--]]
			end
					--LOOP FRAME BACK TO 1
					if self.frame > self.totalFrames then self.frame = 1 end

				self.xoffset = self.frame + (self.width * (self.frame - 1))
				vultureSprite:setViewport(self.xoffset, 0, self.width, self.height)
			end

			--VULTURE AERIAL ANIMATION
				if not self.grounded then
					vultureSprite:setViewport((self.width * 5) + 5, 0, self.width, self.height)
					if self.jumping then
						self.jumpTimer = 0
						self.flapped = true
					end

					if self.flapped then
						vultureSprite:setViewport((self.width * 6) + 6, 0, self.width, self.height)				
						self.jumpTimer = self.jumpTimer + dt
						if self.jumpTimer > .1 then
							self.flapped = false
						end
					end
				end
				
			--VULTURE SKID ANIMATION
			if self.skid then
				vultureSprite:setViewport((self.width * 4) + 4, 0, self.width, self.height)
			end
		end
	end

function Vulture:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	if self.spawning then
		if facingRight then
			love.graphics.draw(self.atlas, vultureSpawnViewport, self.x, self.y)
		else
			love.graphics.draw(self.atlas, vultureSpawnViewport, self.x, self.y, 0, -1, 1, self.width)
		end
	else
		if self.facingRight then
			love.graphics.draw(self.atlas, vultureSprite, self.x, self.y, 0, 1, 1) 
		else
			love.graphics.draw(self.atlas, vultureSprite, self.x, self.y, 0, -1, 1, self.width)
		end
	end
end