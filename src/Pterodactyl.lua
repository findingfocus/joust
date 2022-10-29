Pterodactyl = Class{}

function Pterodactyl:init(x, y)
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.width = 24
	self.height = 16
	self.facingRight = true
	self.exploded = true
	self.atlas = pterodactylAtlas
	self.pterodactylSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
end

function Pterodactyl:update(dt)
	self.pterodactylSprite:setViewport(1, 0, self.width, self.height)
end

function Pterodactyl:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(self.atlas, self.pterodactylSprite, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
end