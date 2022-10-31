Pterodactyl = Class{}

function Pterodactyl:init(x, y)
	self.x = x
	self.y = y
	self.dx = 1.5
	self.dy = .5
	self.width = 24
	self.height = 16
	self.fps = 3
	self.animationTimer = 1 / self.fps
	self.frame = 1
	self.xoffset = 1
	self.totalFrames = 3
	self.facingRight = true
	self.exploded = true
	self.atlas = pterodactylAtlas
	self.pterodactylSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
end

function Pterodactyl:leftCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x > collidable.x + collidable.width - 3 then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end

function Pterodactyl:rightCollides(collidable)
	if self.x + self.width - 3 < collidable.x + collidable.width - 3 and self.x + self.width > collidable.x then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end

function Pterodactyl:topCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x + self.width > collidable.x then
		if self.y < collidable.y + collidable.height and self.y + self.height - 3 > collidable.y + collidable.height - 3 then
			return true
		end
	end

	return false
end

function Pterodactyl:bottomCollides(collidable)
	if self.x < collidable.x + collidable.width and self.x + self.width > collidable.x then
		if self.y < collidable.y + collidable.height and self.y + self.height > collidable.y then
			return true
		end
	end

	return false
end



function Pterodactyl:update(dt)
	self.x = self.x + self.dx
	self.y = self.y + self.dy

	if self.dx > 0 then
		self.facingRight = true
	else
		self.facingRight = false
	end

	if self.x > VIRTUAL_WIDTH then
		self.x = -self.width
	end

	if self.x + self.width < 0 then
		self.x = VIRTUAL_WIDTH
	end

	self.animationTimer = self.animationTimer - dt

	if self.animationTimer <= 0 then
		self.animationTimer = 1 / self.fps
		self.frame = self.frame + 1
		if self.frame > self.totalFrames then self.frame = 1 end
		self.xoffset = (self.width * (self.frame - 1)) + self.frame
		self.pterodactylSprite:setViewport(self.xoffset, 0, self.width, self.height)
	end
end

function Pterodactyl:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	
	if self.facingRight then
		love.graphics.draw(self.atlas, self.pterodactylSprite, self.x, self.y)
	else
		love.graphics.draw(self.atlas, self.pterodactylSprite, self.x, self.y, 0, -1, 1, self.width)
	end
end