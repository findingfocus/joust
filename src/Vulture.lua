Vulture = Class{}

function Vulture:init(x, y, width, height, platformSpawn, dx, index)
	self.index = index
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.index = index
	self.dx = dx
	self.tier = 1
	self.dy = 0
	self.dx = dx
	self.fps = 1
	self.animationTimer = 2 / self.fps
	self.jumpTimer = 1
	self.frame = 1
	self.totalFrames = 3
	self.flapCounter = 0
	self.lastX = 0
	self.lastY = 0
	self.lastDX = 0
	self.xoffset = self.width
	self.timeBetweenJumps = 0
	self.platformSpawnY = platformSpawn
	self.spawnHeight = 0
	self.explosionTimer = 0
	self.pointTier = 500
	self.justStoppedTimer = INPUTLAG
	self.justTurnedTimer = INPUTLAG
	self.grounded = false
	self.skid = false
	self.facingRight = false
	self.flapped = false
	self.justStopped = false
	self.justTurned = false
	self.lastInputLocked = false
	self.collideTimer = 0
	self.justCollided = false
	self.spawning = true
	self.exploded = false
	self.justJumped = false
	self.firstFrameExploded = false
	self.graveyard = true
	self.ground = Platform('name', 1, 1, 1, 1)
    self.dxAssigned = false
	self.atlas = bounderAtlas
	self.vultureSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
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

function Vulture:Collides(vulture)
	if (self.x > vulture.x + vulture.width) or (self.x + self.width < vulture.x) or (self.y > vulture.y + vulture.height) or (self.y + self.height < vulture.y) then
			return false
	else
		return true
	end
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
	if (self.x + self.width > collidable.x and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Vulture:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Vulture:update(dt)
    ---[[
	if self.tier == 1 then
		self.atlas = bounderAtlas
	elseif self.tier == 2 then
		self.atlas = hunterAtlas
        if not self.dxAssigned then
            self.dx = self.dx * 1.5
            self.dxAssigned = true
        end
	else
        self.tier = 3
        self.atlas = shadowlordAtlas
        if not self.dxAssigned then
            self.dx = self.dx * 2.4
            self.dxAssigned = true
        end
	end
    --]]

	if self.graveyard then
		self.x = -20
		self.y = -20
		self.dx = 0
		self.dy = 0
	end

	--UPDATING LAST ALIVE POSITIONS
	if not self.graveyard then
		self.lastX = self.x
		self.lastY = self.y
		self.lastDX = self.dx
	end

	--SETS GROWING VIEWPORT UPON SPAWNING
	if self.spawning then
		self.lastDX = self.dx
		self.spawnHeight = self.spawnHeight + 0.5
		self.vultureSprite:setViewport(1, 0, self.width, self.spawnHeight, self.atlas:getDimensions())
		if self.y < self.platformSpawnY - self.height then
			self.y = self.platformSpawnY - self.height
			self.spawning = false
		end
		self.y = self.y - 0.5
	elseif not self.exploded then -- IF NOT SPAWNING AND NOT EXPLODED

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
---[[PLATFORM COLLISIONS
			--CYCLE THROUGH PLATFORMS
			for index, platform in pairs(collidablePlatforms) do

				if self:checkGrounded(platform) then
					self.ground = platform
					self.grounded = true
				end

				if self:topCollides(platform) then
					if self.dy < 0 then
						self.dy = math.abs(self.dy) / 2
						self.y = platform.y + platform.height + 1
					end
				end

				--BOTTOM COLLIDES
				if self:bottomCollides(platform) then
					self.height = 24
					self.y = platform.y - self.height
					self.dy = 0
					self.grounded = true
					self.ground = platform
				end

				--LEFT COLLIDES SETS POSITIVE DX
				if self:leftCollides(platform) then
                    if not self.justCollided then
                        sounds['collide']:play()
                    end
                    if self.collideTimer == 0 then
                        self.x = platform.x + platform.width
                        self.dx = math.abs(self.dx)
                        self.justCollided = true
                    end
				end

				if self:rightCollides(platform) then
                    if not self.justCollided then
                        sounds['collide']:play()
                    end
					if self.dx > 0 then
						self.dx = self.dx * -1
					end
                    if self.collideTimer == 0 then
                        self.x = platform.x - self.width
                        self.dx = math.abs(self.dx)
                        self.justCollided = true
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
	--]]


			if not self:checkGrounded(self.ground) then
				self.grounded = false
				self.ground = Platform('name', 1, 1, 1, 1)
			end
			--]]


			--APPLY GRAVITY WHEN IN AIR
			if not self.grounded then
				self.dy =  self.dy + GRAVITY * dt
			end

			self.y = self.y + self.dy

			if not self.graveyard then

				self.x = self.x + self.dx

				--BOUNCING OFF TOP
				if self.y < 0 then
					self.y = 0
					self.dy = math.abs(self.dy) / 2
				end

				--LOOPS player to left side of screen
				if self.x > VIRTUAL_WIDTH - 1 then
					self.x = -self.width + 1
				end

				--LOOPS player to right side of screen
				if self.x < -self.width + 1 then
					self.x = VIRTUAL_WIDTH - 1
				end
			end

			if self.grounded then
				self.height = 24

			--AERIAL HANDLING
			elseif not self.grounded then
				self.skid = false
				self.height = 16
			end

			if self.dx < 0 then
				self.facingRight = false
			elseif self.dx > 0 then
				self.facingRight = true
			end


		-- VULTURE ANIMATION CYCLE

			self.fps = (math.abs(self.dx)) * .42 - (math.abs(self.dx) / 20 - .15)

			self.animationTimer = self.animationTimer - self.fps

			--STANDING STILL VIEWPORT
			if self.dx == 0 and self.grounded then
				self.frame = 1
				self.vultureSprite:setViewport(0, 0, self.width, self.height)
			end

			self.timeBetweenJumps = self.timeBetweenJumps - dt

			if self.timeBetweenJumps < 0 then
				love.math.setRandomSeed(self.index)
				self.justJumped = true
                if self.tier == 1 then
                    self.timeBetweenJumps = math.random(.2, .3, .5, 1, 1, 2, 3, 3, 3, 3, 5)
                elseif self.tier == 2 then
                    self.timeBetweenJumps = math.random(.15, .25, .45, .8, .8, 1.8, 2.8, 3, 3, 3, 5)
                elseif self.tier == 3 then
                    self.timeBetweenJumps = math.random(.14, .22, .4, .3, .2, 1, 2.4, 3, 3, 3, 4, 4, 4, 5, 5,5)
                end
			end

			if self.justJumped then
				self.flapped = true
				self.dy = -.25
				self.flapCounter = .1
				self.justJumped = false
			end

			if self.flapped then
				self.flapCounter = self.flapCounter - dt
			end

			if self.flapCounter <= 0 then
				self.flapped = false
				self.flapCounter = 0
			end

			--VULTURE WALKING ANIMATION
			if self.dx ~= 0 and self.grounded then
				self.animationTimer = self.animationTimer - dt
				if self.animationTimer <= 0 then
					self.animationTimer = 1 / self.fps
					self.frame = self.frame + 1
			end
					--LOOP FRAME BACK TO 1
					if self.frame > self.totalFrames then self.frame = 1 end

				self.xoffset = self.frame + (self.width * (self.frame - 1))
				self.vultureSprite:setViewport(self.xoffset, 0, self.width, self.height)
			end

				--VULTURE AERIAL ANIMATION
				if not self.grounded then
					self.vultureSprite:setViewport((self.width * 5) + 6, 0, self.width, self.height)

					if self.flapped then
						self.vultureSprite:setViewport((self.width * 6) + 7, 0, self.width, self.height)
					end
				end

    else -- IF EXPLODED
    	self.explosionTimer = self.explosionTimer + dt
    	if self.explosionTimer > .2 then
    		self.exploded = false
    		self.explosionTimer = 0
    	end
	end
end


function Vulture:render()
---[[
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(smallFont)
	love.graphics.print(tostring(self.index), self.x, self.y - 10)
--]]
	if not self.exploded then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		if self.spawning then

			if self.facingRight then
				love.graphics.draw(self.atlas, self.vultureSprite, math.floor(self.x), self.y, 0, 1, 1)
			else
				love.graphics.draw(self.atlas, self.vultureSprite, math.floor(self.x), self.y, 0, -1, 1, self.width)
			end
		else
			if self.facingRight then
				love.graphics.draw(self.atlas, self.vultureSprite, math.floor(self.x), self.y, 0, 1, 1)
			else
				love.graphics.draw(self.atlas, self.vultureSprite, math.floor(self.x), self.y, 0, -1, 1, self.width)
			end
		end
	elseif self.exploded then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		--Render explosion sprites
		if self.explosionTimer <= .05 then
			love.graphics.draw(explosion1, self.lastX, self.lastY)
			--render explosionSprite1
		elseif self.explosionTimer <= .1 then
			love.graphics.draw(explosion2, self.lastX, self.lastY)
			--render explosionSprite2
		elseif self.explosionTimer <= .15 then
			love.graphics.draw(explosion3, self.lastX, self.lastY)
			--render explosionSprite3
		end
	end
end
