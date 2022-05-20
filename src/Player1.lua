Player1 = Class{}

function Player1:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dy = 0
	self.dx = 0
	self.speedTier = 0
	self.grounded = true
	self.skid = false
	self.facingRight = true
--[[
	player1Speed = 1.3  == .39  ->.312
	player1Speed2 = 1.8 == .702 ->.468
	player1Speed3 = 3   == 1.17 ->.585
	player1Speed4 = 4.5 == 1.755 ->.585
	player1Speed5 = 6   == 2.34
--]]
end

function Player1:update(dt)

	--APPLY GRAVITY WHEN IN AIR
	if not self.grounded then
		self.dy =  self.dy + GRAVITY * dt
	end
	
	--CLAMPS Y TO GROUND
	self.y = math.min(VIRTUAL_HEIGHT - self.height - GROUND_OFFSET, self.y + self.dy)


	--
	if self.y == VIRTUAL_HEIGHT - self.height - GROUND_OFFSET then
		self.height = 20
		--Sets y to appropriate height
		self.y = VIRTUAL_HEIGHT - self.height - GROUND_OFFSET --depends on where ground is, right now its only the bottom floor
		self.grounded = true
		--[[
		if self.speedTier > 0 and self.facingRight then
			self.facingRight = true
		else
			self.facingRight = false
		end
		--]]
		self.dy = 0
	elseif self.y < VIRTUAL_HEIGHT - self.height - 36 then
		self.grounded = false
		self.height = 17
	end

	--ENSURES OSTRICH FACING DIRECTION OF DX
	---[[
	if self.grounded and self.speedTier > 0 and self.dx > 0 then
		self.facingRight = true
	elseif self.grounded and self.speedTier > 0 and self.dx < 0 then
		self.facingRight = false
	end
--]]
	
	--bouncing off top
	if self.y < 0 then
		self.y = 0
		self.dy = 1
	end
	
		--LOOPS player to left side of screen
	if self.x > VIRTUAL_WIDTH then
		self.x = -self.width
	end

	--LOOPS player to right side of screen
	if self.x < -self.width then
		self.x = VIRTUAL_WIDTH
	end

		--PLAYER1 JUMPING
	if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('up') then
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

	--TURN AND GO LEFT IF STOPPED
	if love.keyboard.wasPressed('left') and self.speedTier == 0 and self.facingRight and self.grounded then
		self.facingRight = false
		self.speedTier = self.speedTier + 1

	--INCREMENT PLAYER1 SPEEDTIER WHILE ALREADY MOVING LEFT
	elseif love.keyboard.wasPressed('left') and self.speedTier < 5 and self.grounded and not self.facingRight then
		self.speedTier = self.speedTier + 1

	--STOPS when facing right
	elseif love.keyboard.wasPressed('left') and self.facingRight and self.speedTier == 1 then
		self.speedTier = 0

	--SKID FLAG
	elseif love.keyboard.wasPressed('left') and self.facingRight and self.speedTier > 1 and self.grounded then
		self.skid = true
		sounds['speed1']:stop()
		sounds['speed2']:stop()
		sounds['speed3']:stop()
		sounds['speed4']:stop()
		sounds['skid']:setLooping(true)
		sounds['skid']:play()

	--TURNING LEFT MIDAIR
	elseif love.keyboard.wasPressed('left') and self.facingRight and not self.grounded then
		self.facingRight = false
	end



	--TURN AND GO RIGHT IF STOPPED
	if love.keyboard.wasPressed('right') and self.speedTier == 0 and not self.facingRight and self.grounded then
		self.facingRight = true
		self.speedTier = self.speedTier + 1
	
	--INCREMENT PLAYER1 SPEEDTIER WHILE ALREADY MOVING RIGHT
	elseif love.keyboard.wasPressed('right') and self.speedTier < 5 and self.grounded and self.facingRight then
		self.speedTier = self.speedTier + 1

	--STOPS when facing left
	elseif love.keyboard.wasPressed('right') and not self.facingRight and self.speedTier == 1 then
		self.speedTier = 0
	--SKID FLAG
	elseif love.keyboard.wasPressed('right') and not self.facingRight and self.speedTier > 1 and self.grounded then
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


	--UPDATES PLAYER X RIGHT VELOCITY BASED ON DX
	if self.dx > 0 and not self.skid then
		self.x = self.x + self.dx
	elseif self.dx > 0 and self.skid then
		self.dx = math.max(0, self.dx - .08)
		self.x = self.x + self.dx
		if self.dx == 0 then
			self.speedTier = 0
			sounds['skid']:stop()
			self.skid = false
		end 
	end


	--UPDATES PLAYER X LEFT VELOCITY BASED ON DX
	if self.dx < 0 and not self.skid then
		self.x = self.x + self.dx
	elseif self.dx < 0 and self.skid then
		self.dx = math.min(0, self.dx + .08)
		self.x = self.x + self.dx
		if self.dx == 0 then
			self.speedTier = 0
			sounds['skid']:stop()
			self.skid = false
		end
	end

	--[[
	if player1.speedTier > 0 and player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x + player1Speed * slowScale
		elseif player1.speedTier == 2 then
			player1.x = player1.x + player1Speed * slowScale * player1Speed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x + player1Speed * slowScale * player1Speed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x + player1Speed * slowScale * player1Speed4
		else
			player1.x = player1.x + player1Speed * slowScale * player1Speed5
		end
	end
--]]


	--[[
if love.keyboard.isDown('right') then
		self.x = (self.x + PLAYER_SPEED * dt) % VIRTUAL_WIDTH
		self.dx = 6
	end

---[[
	repeat
		PLAYER_SPEED = PLAYER_SPEED + self.dx
	until (PLAYER_SPEED >= 1800)

	if love.keyboard.isDown('left') then
		self.x = (self.x - PLAYER_SPEED * dt) % VIRTUAL_WIDTH
		PLAYER_SPEED = self.dx + 300
	end

	if love.keyboard.wasPressed('space') and grounded then
		self.dy = -30
	end
	--]]
	-- SOUNDS FOR WALKING
---[[
	if self.speedTier == 0 then
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

--[[
	if player2.speedTier == 0 then
		sounds['2speed1']:stop()
		sounds['2speed2']:stop()
		sounds['2speed3']:stop()
		sounds['2speed4']:stop()
	end
--]]

	if self.speedTier == 1 and self.grounded then
		sounds['speed1']:setLooping(true)
		sounds['speed1']:play()
	end

--[[]
	if player2.speedTier == 1 then
		sounds['2speed1']:setLooping(true)
		sounds['2speed1']:play()
	end
--]]

	if self.speedTier == 2 and self.grounded then
		sounds['speed1']:stop()
		sounds['speed2']:setLooping(true)
		sounds['speed2']:play()
	end

--[[
	if player2.speedTier == 2 then
		sounds['2speed1']:stop()
		sounds['2speed2']:setLooping(true)
		sounds['2speed2']:play()
	end
--]]
---[[
	if self.speedTier == 3 and self.grounded then
		sounds['speed2']:stop()
		sounds['speed3']:setLooping(true)
		sounds['speed3']:play()
	end
--]]	
--[[
	if player2.speedTier == 3 then
		sounds['2speed2']:stop()
		sounds['2speed3']:setLooping(true)
		sounds['2speed3']:play()
	end
--]]


	if self.speedTier == 4 and self.grounded then
		sounds['speed3']:stop()
		sounds['speed4']:setLooping(true)
		sounds['speed4']:play()
	end

	if self.speedTier == 5 and self.grounded then
		sounds['speed3']:stop()
		sounds['speed4']:setLooping(true)
		sounds['speed4']:play()
	end

--[[
	if player2.speedTier == 4 then
		sounds['2speed3']:stop()
		sounds['2speed4']:setLooping(true)
		sounds['2speed4']:play()
	end
--]]
end

function Player1:render()

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
--[[
	if player1.facingRight then
		love.graphics.draw(ostrichAtlas, ostrichSprite, self.x, self.y, 0, -1, 1, 100)
	else
		love.graphics.draw(ostrichAtlas, ostrichSprite, self.x, self.y)
	end
--]]
end