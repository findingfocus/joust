LavaBubble = Class{}

function LavaBubble:init(x, y, spawn)
	self.x = x
	self.y = y
	self.popped = false
	self.particleSpawn = false
	self.bubbleSpawn = false
	self.popSpawn = false
	self.bubbleTimer = 0
	self.popTimer = 0
	self.counter = 0
	self.randomSpawn = spawn
end

function LavaBubble:update(dt)
	self.counter = self.counter + dt

	--Spawns particle at determined randomSpawn time
	if self.counter > self.randomSpawn then
		self.counter = 0
		self.particleSpawn = true
	end
	--Moves particle upwards
	if self.particleSpawn then
		self.y = self.y - .2
	end

	--Triggers bubble spawn once particle at top of lava
	if self.y < VIRTUAL_HEIGHT - LAVAHEIGHT - 2 then
		self.y = VIRTUAL_HEIGHT - LAVAHEIGHT - 2
		self.particleSpawn = false
		self.bubbleSpawn = true	
	end

	--Triggers popSpawn
	if self.bubbleSpawn then
		self.bubbleTimer = self.bubbleTimer + dt
		if self.bubbleTimer > .1 then
			self.bubbleSpawn = false
			self.popSpawn = true
		end
	end

	--Triggers popped
	if self.popSpawn then
		self.popTimer = self.popTimer + dt
		if self.popTimer > .1 then
			self.popSpawn = false
			self.popped = true
		end
	end
end

function LavaBubble:render()
	if self.particleSpawn then
		love.graphics.draw(particle, self.x, self.y)
	elseif self.bubbleSpawn then
		love.graphics.draw(bubble, self.x - 1, self.y)
	elseif self.popSpawn then
		love.graphics.draw(pop, self.x - 2, self.y - 1)
	end
end