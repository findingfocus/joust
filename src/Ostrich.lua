Ostrich = Class{}

function Ostrich:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.atlas = playerAtlas
	self.dy = 0
	self.dx = 0
	self.justStoppedTimer = INPUTLAG
	self.justTurnedTimer = INPUTLAG
	--self.speedTier = 0
	self.grounded = true
	self.skid = false
	self.facingRight = true
	self.flapped = false
	self.justStopped = false
	self.justTurned = false
	--self.frameTracker = 0
	speedScale = 0
	fps = 1
	animationTimer = 1 / fps
	self.jumpTimer = 0
	self.frame = 1
	totalFrames = 4
	self.xoffset = self.width
	--ostrichAtlas = love.graphics.newImage('src/pics/ostrichAtlas1-6panel.png')
	--ostrichAtlas2 = love.graphics.newImage('src/pics/ostrichAtlas2-6panel.png')
	ostrichSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
	--ostrichSprite2 = love.graphics.newQuad(0, 0, 100, 100, ostrichAtlas2:getDimensions())
--[[
	player1Speed = 1.3  == .39  ->.312
	player1Speed2 = 1.8 == .702 ->.468
	player1Speed3 = 3   == 1.17 ->.585
	player1Speed4 = 4.5 == 1.755 ->.585
	player1Speed5 = 6   == 2.34
--]]
end

function Ostrich:topCollides(collidable)
	if (self.y < collidable.y + collidable.height and self.y > collidable.y) then
		if (self.x < collidable.x + collidable.width and self.x + self.width > collidable.x) then
			return true
		end
	end

	return false
end

function Ostrich:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width and self.x + self.width > collidable.x) then
			return true
		end
	end

	return false
end

function Ostrich:rightCollides(collidable)
	if (self.x + self.width > collidable.x and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end

function Ostrich:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			return true
		end
	end

	return false
end


function Ostrich:update(dt)

	--APPLY GRAVITY WHEN IN AIR
	if not self.grounded then
		self.dy =  self.dy + GRAVITY * dt
	end
	
	--CLAMPS Y TO GROUND
	self.y = math.min(VIRTUAL_HEIGHT - self.height - GROUND_OFFSET, self.y + self.dy)

	--GROUNDING LOGIC
	if self.y == VIRTUAL_HEIGHT - self.height - GROUND_OFFSET then
		self.height = 24
		--Sets y to appropriate height
		self.y = VIRTUAL_HEIGHT - self.height - GROUND_OFFSET --depends on where ground is, right now its only the bottom floor
		self.grounded = true
		self.dy = 0
	elseif self.y < VIRTUAL_HEIGHT - self.height - 36 then
		self.grounded = false
		self.height = 16
	end

---[[
	--ENSURES OSTRICH FACING DIRECTION OF DX - SKID LOGIC FOR > SPEED 2
	if self.grounded and self.dx > 0 then
		self.facingRight = true
		--[[
		if love.keyboard.isDown('left') and self.dx > .7 then
			self.skid = true
			sounds['speed1']:stop()
			sounds['speed2']:stop()
			sounds['speed3']:stop()
			sounds['speed4']:stop()
			sounds['skid']:setLooping(true)
			sounds['skid']:play()
		end
		--]]
	elseif self.grounded and self.dx < 0 then
		self.facingRight = false
		--[[
		if love.keyboard.isDown('right') and self.dx < -.7 then
			self.skid = true
			sounds['speed1']:stop()
			sounds['speed2']:stop()
			sounds['speed3']:stop()
			sounds['speed4']:stop()
			sounds['skid']:setLooping(true)
			sounds['skid']:play()
		end
		--]]
	end
--]]
	
	--BOUNCING OFF TOP
	if self.y < 0 then
		self.y = 0
		self.dy = .8
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


	--PLAYER1 JUMPING
	if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('up') then
		sounds['flap']:play()

		--BE SURE TO ADD LEFT VELOCITY IF LEFT IS DOWN AND FLAPPING


		--JUMPING DY
		if (self.dy < -.5) then
			self.dy = -1.5
		elseif(self.dy < -.4) then
			self.dy = -.7
		elseif (self.dy < -.2) then
			self.dy = -.6
		else
			self.dy = -.4
		end
	end



	--INPUT LAG BOOLEANS AND DECREMENT
---[[
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
--]]
	



	---[[ 							
	if self.grounded then
		if self.facingRight then
			--MOVE TO THE RIGHT IF NOT JUSTTURNED OR SKIDDING
			if love.keyboard.isDown('right') --[[and not self.skid--]] and not self.justTurned then
				self.dx = math.max(.12, (math.min(self.dx + SPEEDRAMP, MAXSPEED)))
			end
	
			if self.dx == 0 then
				--TURNS LEFT WHEN STOPPED
				if love.keyboard.isDown('left') and not self.justStopped then
					self.facingRight = false
					self.justTurned = true
				end

			--IF MOVING TO THE RIGHT IN SPEED1
			elseif (self.dx > 0 and self.dx < .4) then
				
				--STOPS WHEN FACING RIGHT
				if love.keyboard.isDown('left') then
					self.dx = 0
					self.justStopped = true
				end

			--SKID FLAG
			elseif self.dx > .4 then
				if love.keyboard.wasPressed('left') then
					self.skid = true
					sounds['speed1']:stop()
					sounds['speed2']:stop()
					sounds['speed3']:stop()
					sounds['speed4']:stop()
					sounds['skid']:setLooping(true)
					sounds['skid']:play()
				end
			end

		elseif not self.facingRight then

			--MOVE TO THE LEFT IF NOT JUSTTURNED OR SKIDDING
			if love.keyboard.isDown('left') --[[and not self.skid --]]and not self.justTurned then
					self.dx = math.min(-.12, (math.max(self.dx - SPEEDRAMP, -MAXSPEED)))
			end

			if self.dx == 0 then
				--TURNS RIGHT WHEN STOPPED
				if love.keyboard.isDown('right') and not self.justStopped then
					self.facingRight = true
					self.justTurned = true
				end

			--IF MOVING TO THE LEFT IN SPEED1
			elseif (self.dx < 0 and self.dx > -.4) then
				--STOPS WHEN FACING LEFT
				if love.keyboard.isDown('right') then
					self.dx = 0
					self.justStopped = true
				end
			--SKID FLAG
			elseif self.dx < -.4 then
				if love.keyboard.wasPressed('right') then
					self.skid = true
					sounds['speed1']:stop()
					sounds['speed2']:stop()
					sounds['speed3']:stop()
					sounds['speed4']:stop()
					sounds['skid']:setLooping(true)
					sounds['skid']:play()
				end
			end
		end
		
	--AERIAL HANDLING
	elseif not self.grounded then
		--TURNING LEFT MIDAIR
		if love.keyboard.wasPressed('left') and self.facingRight then
			self.facingRight = false
		end

		if love.keyboard.wasPressed('right') and not self.facingRight then
			self.facingRight = true
		end

		--FLAPPING DX CHANGE TO DO

	end

--[[
	if love.keyboard.isDown('left') then
		if love.keyboard.wasPressed('right') then
			--self.skid = true
			--self.dx = math.max(.12, (math.min(self.dx + SPEEDRAMP, MAXSPEED)))
		end
	elseif love.keyboard.isDown('right') then
		if love.keyboard.wasPressed('left') then
			--self.skid = true
			--self.dx = math.min(-.12, (math.max(self.dx - SPEEDRAMP, -MAXSPEED)))
		end
	end
--]]







--[[ TURN THIS BACK ON ONCE LEFT IS WORKING PLEASE:)

	--IF RIGHT IS PRESSED AFTER AND WHILE LEFT IS HELD,
	if love.keyboard.isDown('left') and self.dx < -.4 then
		if love.keyboard.wasPressed('right') then
			self.skid = true
		end
	end

	if love.keyboard.isDown('left') and self.dx == 0 then
		if love.keyboard.isDown('right') then
			self.facingRight = true
			self.dx = self.dx + SPEEDRAMP
		end
	end
--]]







--[[
	-- NEGATIVE DX IF LEFT IS HELD
	if love.keyboard.isDown('left') and self.grounded and not self.facingRight and not self.skid then
		self.dx = self.dx - SPEEDRAMP
	end
--]]

--]]



--[[
	--TURN AND GO RIGHT IF STOPPED
	if love.keyboard.wasPressed('right') and self.dx == 0 and not self.facingRight and self.grounded then
		turnTimer = 0
		self.facingRight = true
		self.dx = self.dx + SPEEDRAMP
	
	--INCREMENT PLAYER1 SPEEDTIER WHILE ALREADY MOVING RIGHT
	elseif love.keyboard.isDown('right') and (self.dx > 0 and self.dx <= MAXSPEED) and self.grounded and self.facingRight and not self.skid then
		self.dx = self.dx + SPEEDRAMP

	--STOPS when facing left
	elseif love.keyboard.wasPressed('right') and not self.facingRight and (self.dx < 0 and self.dx > -.4) and self.grounded then
		self.dx = 0

	--SKID FLAG
	elseif love.keyboard.wasPressed('right') and not self.facingRight and self.dx < -.4 and self.grounded then
		self.skid = true
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
		sounds['skid']:setLooping(true)
		sounds['skid']:play()

	--TURNING RIGHT MIDAIR
	elseif love.keyboard.wasPressed('right') and not self.facingRight and not self.grounded then
		self.facingRight = true
	end
---[[
	--RAMP SPEED UP IF RIGHT IS HELD
	if love.keyboard.isDown('right') and self.grounded and self.facingRight and not self.skid then
			self.dx = self.dx + SPEEDRAMP
	end
	

	--MAKES OSTRICH GO RIGHT IF RIGHT IS CONTINOUSLY HELD
	if love.keyboard.isDown('right') and self.dx == 0 and self.grounded and not self.facingRight then
		turnTimer = turnTimer + dt
		if turnTimer > .2 then
			self.facingRight = true
			turnTimer = 0
		end
	end
--]]



		--UPDATES PLAYER X RIGHT VELOCITY BASED ON DX, DETERMINES SKID STOP
	if self.dx >= 0 and not self.skid then
		self.x = self.x + self.dx
	elseif self.dx >= 0 and self.skid then
		self.dx = math.max(0, self.dx - .08)
		self.x = self.x + self.dx
		if self.dx == 0 then
			sounds['skid']:stop()
			self.skid = false
			self.justStopped = true
		end 
	end


	--UPDATES PLAYER X LEFT VELOCITY BASED ON DX, DETERMINES SKID STOP
	if self.dx <= 0 and not self.skid then
		self.x = self.x + self.dx
	elseif self.dx <= 0 and self.skid then
		self.dx = math.min(0, self.dx + .08)
		self.x = self.x + self.dx
		if self.dx == 0 then
			sounds['skid']:stop()
			self.skid = false
			self.justStopped = true
		end
	end





	--COLLIDE LOGIC
	if self:topCollides(platform1) then
		self.y = platform1.y + platform1.height
		self.dy = .8
	end

	--LEFT COLLIDES SETS POSITIVE DX
	if self:leftCollides(platform1) then
		self.x = platform1.x + platform1.width
		self.facingRight = true
		self.dx = math.abs(self.dx)
	end

	--RIGHT COLLIDES SETS POSITIVE DX
	if self:rightCollides(platform1) then
		self.x = platform1.x - self.width
		self.facingRight = false
		self.dx = -self.dx
	end

--[[
	--PLAYER1 SPEED ASSIGNMENT MOVING RIGHT
	if self.facingRight and not self.skid and self.grounded then
		if self.speedTier == 0 then
			self.dx = 0
		elseif self.speedTier == 1 then
			self.dx = SPEED1
		elseif self.speedTier == 2 then
			self.dx = SPEED2
		elseif self.speedTier == 3 then
			self.dx = SPEED3
		elseif self.speedTier == 4 then
			self.dx = SPEED4
		else
			self.dx = SPEED5
		end
	end

	--PLAYER1 SPEED ASSIGNMENT MOVING LEFT
	if not self.facingRight and not self.skid and self.grounded then
		if self.speedTier == 0 then
			self.dx = 0
		elseif self.speedTier == 1 then
			self.dx = -SPEED1
		elseif self.speedTier == 2 then
			self.dx = -SPEED2
		elseif self.speedTier == 3 then
			self.dx = -SPEED3
		elseif self.speedTier == 4 then
			self.dx = -SPEED4
		else
			self.dx = -SPEED5
		end
	end
--]]



	---[[
-- OSTRICH1 ANIMATION CYCLE

	--STANDING STILL VIEWPORT
	if self.dx == 0 and self.grounded then
		self.frame = 1
		ostrichSprite:setViewport(1, 0, self.width, self.height)
	end
	fps = math.abs(self.dx)
	animationTimer = animationTimer - fps

	--PLAYER WALKING ANIMATION
	if self.dx ~= 0 and self.grounded then 
		animationTimer = animationTimer - dt
		if animationTimer <= 0 then
			animationTimer = 1 / fps
			self.frame = self.frame + 1

			--LOOP FRAME BACK TO 1
			if self.frame > totalFrames then self.frame = 1 end

			self.xoffset = self.frame + (self.width * (self.frame - 1))
			ostrichSprite:setViewport(self.xoffset, 0, self.width, self.height)
		end
	end

	--PLAYER AERIAL ANIMATION
		if not self.grounded then
			ostrichSprite:setViewport((self.width * 5) + 5, 0, self.width, self.height)
			if (love.keyboard.wasPressed('space') or love.keyboard.wasPressed('up')) then
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
--]]

	-- SOUNDS FOR WALKING
	if self.dx == 0 then
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
	end

	if not self.grounded then
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
	end

	if (math.abs(self.dx) > 0 and math.abs(self.dx) < .4) and self.grounded and not self.skid then
		sounds['speed1']:setLooping(true)
		sounds['speed1']:play()
	end

	if (math.abs(self.dx) >= .4 and math.abs(self.dx) < .7) and self.grounded and not self.skid then
		sounds['speed1']:stop()
		sounds['speed2']:setLooping(true)
		sounds['speed2']:play()
	end

	if (math.abs(self.dx) >= .7 and math.abs(self.dx) < 1.2) and self.grounded and not self.skid then
		sounds['speed2']:stop()
		sounds['speed3']:setLooping(true)
		sounds['speed3']:play()
	end

	if (math.abs(self.dx) >= 1.2 and math.abs(self.dx) < 1.75) and self.grounded and not self.skid then
		sounds['speed3']:stop()
		sounds['speed4']:setLooping(true)
		sounds['speed4']:play()
	end

	if (math.abs(self.dx) >= 1.75 and math.abs(self.dx) < 2.35) and self.grounded and not self.skid then
		sounds['speed3']:stop()
		sounds['speed4']:setLooping(true)
		sounds['speed4']:play()
	end
end



function Ostrich:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
---[[
	if player1.facingRight then
		love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y) 
	else
		love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y, 0, -1, 1, self.width)
	end
--]]
end