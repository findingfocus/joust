SpawnZonePoint = Class{}

function SpawnZonePoint:init(x, y, dx, identity)
	self.x = x
	self.y = y
	self.dx = dx
    self.identity = identity
end

function SpawnZonePoint:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.print(tostring(self.identity), self.x - 10, self.y - 10)

end
