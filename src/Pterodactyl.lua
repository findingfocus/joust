Pterodactyl = Class{}

function Pterodactyl:init(x, y)
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
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

function Pterodactyl:update(dt)
	self.x = self.x + 1

	if self.x > VIRTUAL_WIDTH then
		self.x = -self.width
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
	love.graphics.draw(self.atlas, self.pterodactylSprite, self.x, self.y)
end