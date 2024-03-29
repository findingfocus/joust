Ostrich = Class{}

function Ostrich:init(x, y, width, height, platformSpawnY, playerNumber, leftInput, rightInput, jumpInput)
	self.x = x
    self.y = platformSpawnY
    self.width = width
	self.height = height
    self.leftInput = leftInput
    self.rightInput = rightInput
    self.jumpInput = jumpInput
    self.playerNumber = playerNumber
    if playerNumber == 1 then
        self.atlas = playerAtlas
        self.spawningAtlas = temporarySafetyAtlas
    elseif playerNumber == 2 then
        self.atlas = player2Atlas
        self.spawningAtlas = temporarySafetyAtlas2
    end
    if self.playerNumber == 1 then
        self.temporarySafetyAtlas = temporarySafetyAtlas
    elseif self.playerNumber == 2 then
        self.temporarySafetyAtlas2 = temporarySafetyAtlas2
    end
	self.platformSpawnY = platformSpawnY
    self.grabbed = false
	self.lastX = 0
	self.lastY = 0
	self.dy = 0
	self.dx = 0
	self.collideTimer = 0
	self.fps = 1
	self.animationTimer = 2 / self.fps
	self.jumpTimer = 0
	self.frame = 1
	self.totalFrames = 4
	self.explosionTimer = 0
	self.spawnHeight = 0.5
	self.safetyTime = 5
	self.spawnFrameCount = 0
    self.escapeJump = 0
	self.temporarySafety = true
	self.xoffset = 1
	self.justStoppedTimer = INPUTLAG
	self.justTurnedTimer = INPUTLAG
	self.spawnFrame1 = true
	self.grounded = false
	self.skid = false
	self.facingRight = true
	self.flapped = false
	self.justStopped = false
	self.justTurned = false
	self.lastInputLocked = false
	self.alternate = false
	self.spawning = true
	self.exploded = false
	self.justCollided = false
	self.ground = Platform('name', 1, 1, 1, 1)
	ostrich1Sprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
    ostrich2Sprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
    if self.playerNumber == 1 then
        player1SpawningSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.temporarySafetyAtlas:getDimensions())
    elseif self.playerNumber == 2 then
        player2SpawningSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.temporarySafetyAtlas2:getDimensions())
    end
    self.beginningSpawn = false
    self.attractMode = false
    lastInput = 'right'
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

function Ostrich:Collides(enemy)
	if (self.x > enemy.x + enemy.width) or (self.x + self.width < enemy.x) or (self.y > enemy.y + enemy.height) or (self.y + self.height < enemy.y) then
			return false
	else
		return true
	end
end

function Ostrich:enemyTopCollides(enemy)
	if self.x < enemy.x + enemy.width and self.x + self.width > enemy.x and self.y < enemy.y + enemy.height and self.y + 6 > enemy.y + enemy.height then
		return true
	else
		return false
	end
end

function Ostrich:enemyBottomCollides(enemy)
	if self.x < enemy.x + enemy.width and self.x + self.width > enemy.x and self.y + self.height > enemy.y and self.y + self.height - 6 < enemy.y then
		return true
	else
		return false
	end
end

function Ostrich:enemyLeftCollides(enemy)
	if self.x < enemy.x + enemy.width and self.x + (self.width / 2) > enemy.x + (self.width / 2) and self.y < enemy.y + enemy.height and self.y + self.height > enemy.y then
		return true
	else
		return false
	end
end

function Ostrich:enemyRightCollides(enemy)
	if self.x + (self.width / 2) < enemy.x + (enemy.width / 2) and self.x + self.width > enemy.x and self.y < enemy.y + enemy.height and self.y + self.height > enemy.y then
		return true
	else
		return false
	end
end

function Ostrich:update(dt)
	if self.graveyard then
		self.x = -20
		self.y = -20
		self.dx = 0
		self.dy = 0
	end

---[[TEMPORARY SAFETY SPRITE SWITCHING
	self.safetyTime = self.safetyTime - dt

	if self.safetyTime < 0 then
		self.temporarySafety = false
	end

	if love.keyboard.isDown(self.leftInput) or love.keyboard.isDown(self.rightInput) or love.keyboard.wasPressed(self.jumpInput) then
		if not self.spawning then
			self.temporarySafety = false
            if self.playerNumber == 1 then
                sounds['respawn']:stop()
            else
                sounds['respawn2']:stop()
            end
		end
	end

	if self.temporarySafety then
		if self.spawnFrameCount > 2 then
			self.spawnFrameCount = 0
			if self.spawnFrame1 then
				self.spawnFrame1 = not self.spawnFrame1
			else
				self.spawnFrame1 = true
			end
		end

		if self.spawnFrame1 then
            if self.playerNumber == 1 then
                player1SpawningSprite:setViewport(1, 0, self.width, self.spawnHeight) -- SPAWN FRAME 1
                self.spawnFrameCount = self.spawnFrameCount + 1
            elseif self.playerNumber == 2 then
                player2SpawningSprite:setViewport(1, 0, self.width, self.spawnHeight) -- SPAWN FRAME 1
                self.spawnFrameCount = self.spawnFrameCount + 1
            end
		else
            if self.playerNumber == 1 then
                player1SpawningSprite:setViewport(18, 0, self.width, self.spawnHeight) -- SPAWN FRAME 2
                self.spawnFrameCount = self.spawnFrameCount + 1
            elseif self.playerNumber == 2 then
                player2SpawningSprite:setViewport(18, 0, self.width, self.spawnHeight) -- SPAWN FRAME 2
                self.spawnFrameCount = self.spawnFrameCount + 1
            end
		end
	end
	--]]

---[[SPAWNING LOGIC
	if self.spawning then
		self.y = self.y - 0.5
		self.spawnHeight = self.spawnHeight + 0.5

		if self.spawnHeight > 24 then
			self.spawnHeight = 24
		end

		if self.y <= self.platformSpawnY - self.height then
			self.y = self.platformSpawnY - self.height
			self.spawning = false
			self.grounded = true
		end

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
	else -- IF NOT SPAWNING
		if not self.exploded then
			self.lastX = self.x
			self.lastY = self.y
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

---[[PLATFORMS COLLISIONS
			for index, platform in pairs(collidablePlatforms) do
					--BOTTOM COLLIDES
				if self:checkGrounded(platform) then
					self.ground = platform
				end

				if self:topCollides(platform) then
					self.y = platform.y + platform.height + 1
					if self.dy < 0 then
						self.dy = (math.abs(self.dy / 2)) / 2 -- the divide by is to help negate gravity
					end
				end

				if self:bottomCollides(platform) then
					self.height = 24
					self.y = platform.y - self.height
					self.dy = 0
					self.grounded = true
					self.ground = platform
				end

				--LEFT COLLIDES SETS POSITIVE DX
				if self:leftCollides(platform) then
					if self.dx > .1 or self.dx < -.1 then
						if self.collideTimer == 0 then
							self.dx = math.abs(self.dx)
							self.justCollided = true
							sounds['collide']:play()
						end
					end
				end

				--RIGHT COLLIDES SETS NEGATIVE DX
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

                --GROUNDPLATFORM COLLISION
                if self:leftCollides(groundPlatform) then
                    self.x = groundPlatform.x + groundPlatform.width
                    self.dx = math.abs(self.dx)
                end

                if self:rightCollides(groundPlatform) then
                    self.x = groundPlatform.x - self.width
                    self.dx = self.dx * -1
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
            elseif platform2Removed and self.y == 53 then
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
			elseif self.grounded and self.dx < 0 then
				self.facingRight = false
			end

			--BOUNCING OFF TOP
            if not self.graveyard then
                if self.y <= 0 then
                    self.y = 1
                    self.dy = math.abs(self.dy) / 2 --Division to offset gravity
                end
            end

            if not self.attractMode then
                --LOOPS player to left side of screen
                if self.x > VIRTUAL_WIDTH - 1 then
                    self.x = -self.width + 1
                end

                --LOOPS player to right side of screen
                if self.x < -self.width + 1 then
                    self.x = VIRTUAL_WIDTH - 1
                end
            end

---[[INPUT HANDLING
			--MULTIPLE DIRECTION INPUT HANDLING
			if love.keyboard.isDown(self.leftInput) and not love.keyboard.isDown(self.rightInput) then
				self.rightPriority = false
				lastInput = {}
				table.insert(lastInput, "left")

			elseif love.keyboard.isDown(self.rightInput) and not love.keyboard.isDown(self.leftInput) then
				self.rightPriority = true
				lastInput = {}
				table.insert(lastInput, "right")

			elseif love.keyboard.isDown(self.rightInput) and love.keyboard.isDown(self.leftInput) and not self.lastInputLocked then
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

			if love.keyboard.wasReleased(self.leftInput) or love.keyboard.wasReleased(self.rightInput) then
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
				if love.keyboard.isDown(self.leftInput) and lastInput[1] == "left" and self.dx >= SKIDTHRESHOLD and not self.skid then
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
					sounds['skid']:play()
					self.skid = true
				end

				if love.keyboard.isDown(self.rightInput) and lastInput[1] == "right" and self.dx <= -SKIDTHRESHOLD and not self.skid then
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
					sounds['skid']:play()
					self.skid = true
				end
				--]]
				if self.facingRight then
					--MOVE TO THE RIGHT IF NOT JUSTTURNED OR SKIDDING
					if love.keyboard.isDown(self.rightInput) and lastInput[1] == "right" and not self.skid and not self.justTurned then
						self.dx = math.max(.12, (math.min(self.dx + SPEEDRAMP, MAXSPEED)))
					end

					if self.dx == 0 then
						--TURNS LEFT WHEN STOPPED
						if love.keyboard.isDown(self.leftInput) and lastInput[1] == "left" and not self.justStopped then
							self.facingRight = false
							self.justTurned = true
						end

					--IF MOVING TO THE RIGHT IN SPEED1
					elseif (self.dx > 0 and self.dx < SKIDTHRESHOLD) then

						--STOPS WHEN FACING RIGHT
						if love.keyboard.isDown(self.leftInput) and lastInput[1] == "left" then
							self.dx = 0
							self.justStopped = true
						end

					--SKID FLAG
					elseif self.dx >= SKIDTHRESHOLD then
						if love.keyboard.isDown(self.leftInput) and love.keyboard.wasReleased(self.rightInput) then
							self.skid = true
							sounds['skid']:play()
						end

						if love.keyboard.wasPressed(self.leftInput) and not self.skid then
							self.skid = true
							sounds['skid']:play()
							sounds['leftStep']:stop()
							sounds['rightStep']:stop()
						end
					end

				elseif not self.facingRight then

					--MOVE TO THE LEFT IF NOT JUSTTURNED OR SKIDDING
					if love.keyboard.isDown(self.leftInput) and lastInput[1] == "left" and not self.skid and not self.justTurned then
							self.dx = math.min(-.12, (math.max(self.dx - SPEEDRAMP, -MAXSPEED)))
					end

					if self.dx == 0 then
						--TURNS RIGHT WHEN STOPPED
						if love.keyboard.isDown(self.rightInput) and lastInput[1] == "right" and not self.justStopped then
							self.facingRight = true
							self.justTurned = true
						end

					--IF MOVING TO THE LEFT IN SPEED1
					elseif (self.dx < 0 and self.dx > -SKIDTHRESHOLD) then
						--STOPS WHEN FACING LEFT
						if love.keyboard.isDown(self.rightInput) and lastInput[1] == "right" then
							self.dx = 0
							self.justStopped = true
						end
					--SKID FLAG
					elseif self.dx < -SKIDTHRESHOLD then
						if love.keyboard.isDown(self.rightInput) and love.keyboard.wasReleased(self.leftInput) then
								self.skid = true
								sounds['leftStep']:stop()
								sounds['rightStep']:stop()
								sounds['skid']:play()
						end

						if love.keyboard.wasPressed(self.rightInput) and not self.skid then
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
				if love.keyboard.isDown(self.leftInput) and lastInput[1] == 'left' then
					self.facingRight = false
				end

				if love.keyboard.isDown(self.rightInput) and lastInput[1] == 'right' then
					self.facingRight = true
				end

				--FLAPPING DX CHANGE TO DO
				if love.keyboard.isDown(self.leftInput) and lastInput[1] == 'left' and love.keyboard.wasPressed(self.jumpInput) then
					self.dx = math.max(self.dx - FLAPAMOUNT, -MAXSPEED)
				end

				if love.keyboard.isDown(self.rightInput) and lastInput[1] == 'right' and love.keyboard.wasPressed(self.jumpInput) then
					self.dx = math.min(self.dx + FLAPAMOUNT, MAXSPEED)
				end
			end

            --PLAYER1 JUMPING
			if love.keyboard.wasPressed(self.jumpInput) then
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
	--]]
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

---[[OSTRICH1 ANIMATION CYCLE
			self.fps = (math.abs(self.dx)) * .42 - (math.abs(self.dx) / 20 - .15)

			self.animationTimer = self.animationTimer - self.fps

			--STANDING STILL VIEWPORT
			if self.dx == 0 and self.grounded then
				self.frame = 1
			end

			--PLAYER WALKING ANIMATION
			if self.dx ~= 0 and self.grounded then
				self.animationTimer = self.animationTimer - dt
				if self.animationTimer <= 0 then
					self.animationTimer = 1 / self.fps
					self.frame = self.frame + 1
					if self.frame == 2 and self.alternate then
						self.alternate = false
						sounds['leftStep']:play()
					elseif self.frame == 2 and not self.alternate then
						self.alternate = true
						sounds['rightStep']:play()
					end
				end
			end
				--LOOP FRAME BACK TO 1
				if self.frame > self.totalFrames then self.frame = 1 end

				self.xoffset = self.frame + (self.width * (self.frame - 1))
                if self.playerNumber == 1 then
                    ostrich1Sprite:setViewport(self.xoffset, 0, self.width, self.height)
                else
                    ostrich2Sprite:setViewport(self.xoffset, 0, self.width, self.height)
                end

			--PLAYER AERIAL ANIMATION
				if not self.grounded then
                    if self.playerNumber == 1 then
                        ostrich1Sprite:setViewport((self.width * 5) + 6, 0, self.width, self.height)
                    else
                        ostrich2Sprite:setViewport((self.width * 5) + 6, 0, self.width, self.height)
                    end
					if love.keyboard.wasPressed(self.jumpInput) then
						self.jumpTimer = 0
						self.flapped = true
					end

					if self.flapped then
                        if self.playerNumber == 1 then
                            ostrich1Sprite:setViewport((self.width * 6) + 7, 0, self.width, self.height)
                        else
                            ostrich2Sprite:setViewport((self.width * 6) + 7, 0, self.width, self.height)
                        end
						self.jumpTimer = self.jumpTimer + dt
						if self.jumpTimer > .1 then
							self.flapped = false
						end
					end
				end
	--]]

---[[PLAYER SKID ANIMATION
			if self.skid then
                if self.playerNumber == 1 then
                    ostrich1Sprite:setViewport((self.width * 4) + 4, 0, self.width, self.height)
                else
                    ostrich2Sprite:setViewport((self.width * 4) + 4, 0, self.width, self.height)
                end
			end

		elseif self.exploded then
			if self.explosionTimer < .4 then
				self.explosionTimer = self.explosionTimer + dt
			end
		end
	end
	--]]
end

function Ostrich:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	if not self.spawning then
		if not self.exploded then
			if self.facingRight and not self.temporarySafety then
                if self.playerNumber == 1 then
                    love.graphics.draw(self.atlas, ostrich1Sprite, self.x, self.y, 0, 1, 1)
                else
                    love.graphics.draw(self.atlas, ostrich2Sprite, self.x, self.y, 0, 1, 1)
                end
			elseif not self.temporarySafety then
                if self.playerNumber == 1 then
                    love.graphics.draw(self.atlas, ostrich1Sprite, self.x, self.y, 0, -1, 1, self.width)
                else
                    love.graphics.draw(self.atlas, ostrich2Sprite, self.x, self.y, 0, -1, 1, self.width)
                end
			end
		elseif self.exploded then
			--Render explosion sprites
			if self.explosionTimer <= .1 then
				love.graphics.draw(explosion1, self.lastX, self.lastY)
			elseif self.explosionTimer <= .2 then
				love.graphics.draw(explosion2, self.lastX, self.lastY)
			elseif self.explosionTimer <= .3 then
				love.graphics.draw(explosion3, self.lastX, self.lastY)
			end
		end
	end

	if self.temporarySafety then --IF SPAWNING
		if not self.exploded then
			if self.facingRight then
                if self.playerNumber == 1 then
                    love.graphics.draw(self.temporarySafetyAtlas, player1SpawningSprite, self.x, self.y, 0, 1, 1)
                else
                    love.graphics.draw(self.temporarySafetyAtlas2, player2SpawningSprite, self.x, self.y, 0, 1, 1)
                end
			else
                if self.playerNumber == 1 then
                    love.graphics.draw(self.temporarySafetyAtlas, player1SpawningSprite, self.x, self.y, 0, -1, 1, self.width)
                else
                    love.graphics.draw(self.temporarySafetyAtlas2, player2SpawningSprite, self.x, self.y, 0, -1, 1, self.width)
                end
			end
		end
	end

    if not self.beginningSpawn then --FIXES FRAME 1 RENDER BUG
        if self.playerNumber == 1 then
            ostrich1Sprite:setViewport(1, 0, self.width, self.height)
        else
            ostrich2Sprite:setViewport(1, 0, self.width, self.height)
        end
        self.beginningSpawn = true
    end
end
