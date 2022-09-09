Ostrich = Class{}

function Ostrich:init(x, y, width, height, platformSpawnY)
	self.x = x
	self.y = platformSpawnY
	self.width = width
	self.height = height
	self.atlas = playerAtlas
	self.platformSpawnY = platformSpawnY
	self.dy = 0
	self.dx = 0
	self.justStoppedTimer = INPUTLAG
	self.justTurnedTimer = INPUTLAG
	self.grounded = false
	self.skid = false
	self.facingRight = true
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
	self.explosionTimer = 0
	self.spawnHeight = 0
	self.spawning = true
	self.exploded = false
	self.death = false
	self.xoffset = self.width
	ostrichSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	ostrichSpawnViewport = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	self.ground = Platform('name', 1, 1, 1, 1)
end

function Ostrich:checkGrounded(collidablePlatforms)
	if self.y == collidablePlatforms.y - self.height then
		if self.x < collidablePlatforms.x + collidablePlatforms.width - BUFFER and self.x + self.width > collidablePlatforms.x + BUFFER then
			return true
		else
			return false
		end
	end
	return false
end

function Ostrich:topCollides(collidable)
	if (self.y < collidable.y + collidable.height and self.y > collidable.y) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Ostrich:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width - BUFFER and self.x + self.width > collidable.x + BUFFER) then
			return true
		end
	end

	return false
end

function Ostrich:rightCollides(collidable)
	if (self.x + self.width > collidable.x + BUFFER / 2 and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Ostrich:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width - BUFFER / 2 and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Ostrich:collidesEnemy(enemy)
	if self.x < enemy.x + enemy.width and self.x > enemy.x then
		if self.y < enemy.y + enemy.height and self.y + self.height > enemy.y then
			return true
		end
	end

	return false
end

lastInput = {"right"}


function Ostrich:update(dt)
	

		---[[
	if self.spawning then
		self.y = self.y - 0.5
		self.spawnHeight = self.spawnHeight + 0.5	

		if self.spawnHeight > 24 then
			self.spawnHeight = 24
		end

		if self.y < self.platformSpawnY - self.height then
			self.y = self.platformSpawnY - self.height
			ostrichSpawnViewport:setViewport(1, 0, self.width, self.spawnHeight)
			self.spawning = false
			self.grounded = true
		end
--[[
		if self.spawnHeight >= 24 then
			self.spawnHeight = 24
			self.y = self.platformSpawnY - self.height
			self.dy = 0
			self.grounded = true
		end

		if self.y <= self.platformSpawnY - self.height then
			self.spawning = false
			self.grounded = true
			self.y = self.platformSpawnY - self.height
		end
--]]

		ostrichSpawnViewport:setViewport(1, 0, self.width, self.spawnHeight)

	else
		if not self.exploded then
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

			--Check Enemy Collision
			for k, vulture in pairs(Vultures) do
				if self:collidesEnemy(vulture) then
					--Check Y position
					--PLAYER AND VULTURE ARE SAME HEIGHT
					if self.y == vulture.y then
						--Once working, see if you can evaluate facingRight as boolean to compare if vulture bool is same
						if self.facingRight and vulture.facingRight then
							--explode vulture into egg
						elseif not self.facingRight and not vulture.facingRight then
							--explode vulture into egg
						end
						--Moves vulture x to be not colliding
						--vulture1.x = self.x + self.width
						--Reverse objects DX
						self.dx = self.dx * -1
						vulture.dx = vulture.dx * -1
					--PLAYER JOUST IS HIGHER
					elseif self.y < vulture.y then
						--explode vulture into egg
					elseif self.y > vulture.y then
					--VULTURE JOUST IS HIGHER
						self.exploded = true
						--player explodes
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
				self.facingRight = true
		--OLD SKID WHILE IN AIR LOGIC PLACE
			elseif self.grounded and self.dx < 0 then
				self.facingRight = false
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


			--INPUT HANDLING

			--MULTIPLE DIRECTION INPUT HANDLING
			if love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
				self.rightPriority = false
				lastInput = {}
				table.insert(lastInput, "left")

			elseif love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
				self.rightPriority = true
				lastInput = {}
				table.insert(lastInput, "right")

			elseif love.keyboard.isDown('right') and love.keyboard.isDown('left') and not self.lastInputLocked then
				--assign only one value until a key is released
				if lastInput[1] == "left" then
					lastInput = {}
					table.insert(lastInput, "right")
				elseif lastInput[1] == "right" then
					lastInput = {}
					table.insert(lastInput, "left")
				end

				self.lastInputLocked = true
			end

			if love.keyboard.wasReleased('left') or love.keyboard.wasReleased('right') then
				self.lastInputLocked = false
			end



			--INPUT LAG BOOLEANS AND DECREMENT
			if self.justStopped then
				if self.justStoppedTimer > 0 then
					self.justStoppedTimer = self.justStoppedTimer - dt
				else
					self.justStopped = false
					self.justStoppedTimer = INPUTLAG
				end
			end

			if self.justTurned then
				if self.justTurnedTimer > 0 then
					self.justTurnedTimer = self.justTurnedTimer - dt
				else
					self.justTurned = false
					self.justTurnedTimer = INPUTLAG
				end
			end

			if self.grounded then
				self.height = 24
				---[[SKID UPON LANDING __MAKE THIS ONLY PLAY ONCE***
				if love.keyboard.isDown('left') and lastInput[1] == "left" and self.dx >= SKIDTHRESHOLD and not self.skid then
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
					sounds['skid']:play()
					self.skid = true
				end

				if love.keyboard.isDown('right') and lastInput[1] == "right" and self.dx <= -SKIDTHRESHOLD and not self.skid then
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
					sounds['skid']:play()
					self.skid = true
				end
				--]]
				if self.facingRight then
					--MOVE TO THE RIGHT IF NOT JUSTTURNED OR SKIDDING
					if love.keyboard.isDown('right') and lastInput[1] == "right" and not self.skid and not self.justTurned then
						self.dx = math.max(.12, (math.min(self.dx + SPEEDRAMP, MAXSPEED)))
					end
			
					if self.dx == 0 then
						--TURNS LEFT WHEN STOPPED
						if love.keyboard.isDown('left') and lastInput[1] == "left" and not self.justStopped then
							self.facingRight = false
							self.justTurned = true
						end

					--IF MOVING TO THE RIGHT IN SPEED1
					elseif (self.dx > 0 and self.dx < SKIDTHRESHOLD) then
						
						--STOPS WHEN FACING RIGHT
						if love.keyboard.isDown('left') and lastInput[1] == "left" then
							self.dx = 0
							self.justStopped = true
						end

					--SKID FLAG
					elseif self.dx >= SKIDTHRESHOLD then
						if love.keyboard.isDown('left') and love.keyboard.wasReleased('right') then
							self.skid = true
							sounds['skid']:play()
						end

						if love.keyboard.wasPressed('left') and not self.skid then
							self.skid = true
							sounds['skid']:play()
							sounds['leftStep']:stop()
							sounds['rightStep']:stop()
						end
					end

				elseif not self.facingRight then

					--MOVE TO THE LEFT IF NOT JUSTTURNED OR SKIDDING
					if love.keyboard.isDown('left') and lastInput[1] == "left" and not self.skid and not self.justTurned then
							self.dx = math.min(-.12, (math.max(self.dx - SPEEDRAMP, -MAXSPEED)))
					end

					if self.dx == 0 then
						--TURNS RIGHT WHEN STOPPED
						if love.keyboard.isDown('right') and lastInput[1] == "right" and not self.justStopped then
							self.facingRight = true
							self.justTurned = true
						end

					--IF MOVING TO THE LEFT IN SPEED1
					elseif (self.dx < 0 and self.dx > -SKIDTHRESHOLD) then
						--STOPS WHEN FACING LEFT
						if love.keyboard.isDown('right') and lastInput[1] == "right" then
							self.dx = 0
							self.justStopped = true
						end
					--SKID FLAG
					elseif self.dx < -SKIDTHRESHOLD then
						if love.keyboard.isDown('right') and love.keyboard.wasReleased('left') then
								self.skid = true
								sounds['leftStep']:stop()
								sounds['rightStep']:stop()
								sounds['skid']:play()
						end

						if love.keyboard.wasPressed('right') and not self.skid then
							self.skid = true
							sounds['leftStep']:stop()
							sounds['rightStep']:stop()
							sounds['skid']:play()
						end
					end
				end
				
			--AERIAL HANDLING
			elseif not self.grounded then
				self.skid = false
				self.height = 16
				--TURNING LEFT MIDAIR
				if love.keyboard.isDown('left') and lastInput[1] == 'left' then
					self.facingRight = false
				end

				if love.keyboard.isDown('right') and lastInput[1] == 'right' then
					self.facingRight = true
				end

				--FLAPPING DX CHANGE TO DO
				if love.keyboard.isDown('left') and lastInput[1] == 'left' and love.keyboard.wasPressed('a') then
					self.dx = math.max(self.dx - FLAPAMOUNT, -MAXSPEED)
				end

				if love.keyboard.isDown('right') and lastInput[1] == 'right' and love.keyboard.wasPressed('a') then
					self.dx = math.min(self.dx + FLAPAMOUNT, MAXSPEED)
				end
			end

				--PLAYER1 JUMPING
			if love.keyboard.wasPressed('a') then
				self.grounded = false
				sounds['flap']:play()

				--JUMPING DY
				if (self.dy < -.5) then
					self.dy = -1.5
				elseif(self.dy < -.3) then
					self.dy = -.7
				elseif (self.dy < -.1) then
					self.dy = -.5
				else
					self.dy = -.3
				end
			end


			if self.dx == 0 then
				sounds['skid']:stop()
				self.skid = false
				self.justStopped = true
			elseif self.dx > 0 and self.skid and self.grounded then
				self.dx = math.max(0, self.dx - .08)
				self.x = self.x + self.dx
			elseif self.dx < 0 and self.skid and self.grounded then
				self.dx = math.min(0, self.dx + .08)
				self.x = self.x + self.dx
			else
				self.x = self.x + self.dx
			end

		-- OSTRICH1 ANIMATION CYCLE

			self.fps = (math.abs(self.dx)) * .42 - (math.abs(self.dx) / 20 - .15)

			self.animationTimer = self.animationTimer - self.fps

			--STANDING STILL VIEWPORT
			if self.dx == 0 and self.grounded then
				self.frame = 1
				ostrichSprite:setViewport(1, 0, self.width, self.height)
			end

			--PLAYER WALKING ANIMATION
			if self.dx ~= 0 and self.grounded then 
				self.animationTimer = self.animationTimer - dt
				if self.animationTimer <= 0 then
					self.animationTimer = 1 / self.fps
					self.frame = self.frame + 1
					---[[
					if self.frame == 2 and self.alternate then
						self.alternate = false
						sounds['leftStep']:play()
					elseif self.frame == 2 and not self.alternate then
						self.alternate = true
						sounds['rightStep']:play()
					end
					--]]
			end
					--LOOP FRAME BACK TO 1
					if self.frame > self.totalFrames then self.frame = 1 end

				self.xoffset = self.frame + (self.width * (self.frame - 1))
				ostrichSprite:setViewport(self.xoffset, 0, self.width, self.height)
			end

			--PLAYER AERIAL ANIMATION
				if not self.grounded then
					ostrichSprite:setViewport((self.width * 5) + 5, 0, self.width, self.height)
					if love.keyboard.wasPressed('a') then
						self.jumpTimer = 0
						self.flapped = true
					end

					if self.flapped then
						ostrichSprite:setViewport((self.width * 6) + 6, 0, self.width, self.height)				
						self.jumpTimer = self.jumpTimer + dt
						if self.jumpTimer > .1 then
							self.flapped = false
						end
					end
				end
				
			--PLAYER SKID ANIMATION
			if self.skid then
				ostrichSprite:setViewport((self.width * 4) + 4, 0, self.width, self.height)
			end
		elseif self.exploded then
			self.explosionTimer = self.explosionTimer + dt
		end

		if self.explosionTimer > .3 then
			self.death = true
		end
	end

end



function Ostrich:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	love.graphics.setFont(smallFont)
	love.graphics.print('x: ' .. tostring(self.spawning), 5, 5)
	if not self.spawning then
		if not self.exploded then
			if self.facingRight then
				love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y, 0, 1, 1) 
			else
				love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y, 0, -1, 1, self.width)
			end
		elseif self.exploded then
			--Render explosion sprites
			if self.explosionTimer <= .1 then
				love.graphics.draw(explosion1, self.x, self.y)
				--render explosionSprite1
			elseif self.explosionTimer <= .2 then
				love.graphics.draw(explosion2, self.x, self.y)
				--render explosionSprite2
			elseif self.explosionTimer <= .3 then
				love.graphics.draw(explosion3, self.x, self.y)
				--render explosionSprite3
			end
		end

		--IF SPAWNING
	else
		if not self.exploded then
			if self.facingRight then
				love.graphics.draw(self.atlas, ostrichSpawnViewport, self.x, self.y, 0, 1, 1) 
			else
				love.graphics.draw(self.atlas, ostrichSpawnViewport, self.x, self.y, 0, -1, 1, self.width)
			end
		end
	end
end