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
	speed1 = .4
	speed2 = .7
	speed3 = 1.2
	speed4 = 1.75
	speed5 = 2.35
--[[
	player1Speed = 1.3  == .39  ->.312
	player1Speed2 = 1.8 == .702 ->.468
	player1Speed3 = 3   == 1.17 ->.585
	player1Speed4 = 4.5 == 1.755 ->.585
	player1Speed5 = 6   == 2.34
--]]
end

function Player1:update(dt)
	if not self.grounded then
		self.dy =  self.dy + GRAVITY * dt
	end
	
	self.y = math.min(VIRTUAL_HEIGHT - self.height - 36, self.y + self.dy)
	if self.y == VIRTUAL_HEIGHT - self.height - 36 then
		self.y = VIRTUAL_HEIGHT - 56 --depends on where ground is, right now its only the bottom floor
		self.grounded = true
		self.height = 20
		self.dy = 0
	elseif self.y < VIRTUAL_HEIGHT - self.height - 36 then
		self.grounded = false
		self.height = 17
	end
	
	--bouncing off top
	if self.y < 0 then
		self.y = 0
		self.dy = 1
	end


	--PLAYER1 MOVING LEFT
	if self.speedTier > 0 and not self.facingRight and not self.skid then
		if self.speedTier == 1 then
			self.dx = speed1
		elseif self.speedTier == 2 then
			self.dx = speed2
		elseif self.speedTier == 3 then
			self.dx = speed3
		elseif self.speedTier == 4 then
			self.dx = speed4
		else
			self.dx = speed5
		end
	end

	


	--INCREMEMENT PLAYER1 SPEED TO THE RIGHT
	if love.keyboard.wasPressed('right') and player1.speedTier < 5 then
		
		--TURNING
		if player1.speedTier == 0 then
			player1.facingRight = true
		end

		--SPEED INCREMENT
		player1.speedTier = player1.speedTier + 1
	end



	--INCREMENT PLAYER1 SPEED TO THE LEFT
	if love.keyboard.wasPressed('left') and self.speedTier < 5 then

		--TURNING
		if self.speedTier == 0 then
			self.facingRight = false
		end
		--SPEED INCREMEMENT
		self.speedTier = self.speedTier + 1
	end



--[[
		player1.dx = math.max(0, player1.dx - .5)
		if player1.dx == 0 then
			player1.skid = false
		end
	--]]

	--BRAKES when facing right
	if love.keyboard.wasPressed('left') and self.facingRight and self.speedTier < 2 then
		self.speedTier = 0
	elseif love.keyboard.wasPressed('left') and self.facingRight and self.speedTier > 1 then
	--SKID FLAG
		self.skid = true
		--sound['skid']:play()

	end




		--BRAKES when facing left
	if love.keyboard.wasPressed('right') and not self.facingRight and self.speedTier < 2 then
		self.speedTier = 0
	elseif love.keyboard.wasPressed('right') and not self.facingRight and self.speedTier > 1 then
	--SKID FLAG
		self.skid = true
		--sounds['skid']:play()
	end


	--[[
	if player1.speedTier > 0 and not player1.facingRight then
		if player1.speedTier == 1 then
			player1.x = player1.x - player1Speed * slowScale
		elseif player1.speedTier == 2 then
			player1.x = player1.x - player1Speed * slowScale * player1Speed2
		elseif player1.speedTier == 3 then
			player1.x = player1.x - player1Speed * slowScale * player1Speed3
		elseif player1.speedTier == 4 then
			player1.x = player1.x - player1Speed * slowScale * player1Speed4
		else
			player1.x = player1.x - player1Speed * slowScale * player1Speed5
		end
	end
	--]]

	--PLAYER1 MOVING RIGHT
	if self.speedTier > 0 and self.facingRight and not self.skid then
		if self.speedTier == 1 then
			self.dx = speed1
		elseif self.speedTier == 2 then
			self.dx = speed2
		elseif self.speedTier == 3 then
			self.dx = speed3
		elseif self.speedTier == 4 then
			self.dx = speed4
		else
			self.dx = speed5
		end
	end





	--UPDATES PLAYER X RIGHT VELOCITY BASED ON DX
	if self.facingRight and not self.skid then
		self.x = self.x + self.dx
	elseif self.facingRight and self.skid then
		self.dx = math.max(0, self.dx - .08)
		self.x = self.x + self.dx
		if self.dx == 0 then
			self.speedTier = 0
			self.skid = false
		end 
	end


	--UPDATES PLAYER X LEFT VELOCITY BASED ON DX
	if not self.facingRight and not self.skid then
		self.x = self.x - self.dx
	elseif not self.facingRight and self.skid then
		self.dx = math.max(0, self.dx - .08)
		self.x = self.x - self.dx
		if self.dx == 0 then
			self.speedTier = 0
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