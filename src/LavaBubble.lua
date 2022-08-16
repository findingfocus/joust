LavaBubble = Class{}

function LavaBubble:init(x, y)
	self.x = x
	self.y = y
	self.popped = false
	particleSpawn = false
	bubbleSpawn = false
	popSpawn = false
	bubbleTimer = 0
	popTimer = 0
	counter = 0
	self.randomSpawn = math.random(4, 11)
end

function LavaBubble:update(dt)
	counter = counter + dt

	--Spawns particle at determined randomSpawn time
	if counter > self.randomSpawn then
		particleSpawn = true
	end

	--Moves particle upwards
	if particleSpawn then
		self.y = self.y - .2
	end

	--Triggers bubble spawn once particle at top of lava
	if self.y < VIRTUAL_HEIGHT - LAVAHEIGHT - 2 then
		self.y = VIRTUAL_HEIGHT - LAVAHEIGHT - 2
		particleSpawn = false
		bubbleSpawn = true	
	end

	--Triggers popSpawn
	if bubbleSpawn then
		bubbleTimer = bubbleTimer + dt
		if bubbleTimer > .1 then
			bubbleSpawn = false
			popSpawn = true
		end
	end

	--Triggers popped
	if popSpawn then
		popTimer = popTimer + dt
		if popTimer > .1 then
			popSpawn = false
			self.popped = true
		end
	end
end

function LavaBubble:render()
	if particleSpawn then
		love.graphics.draw(particle, self.x, self.y)
	elseif bubbleSpawn then
		love.graphics.draw(bubble, self.x - 1, self.y)
	elseif popSpawn then
		love.graphics.draw(pop, self.x - 2, self.y - 1)
	end
end