TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT, 2)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT, 5)
    lavaRise = 0
    twoPlayerMode = false
    startInstructions = false
    modeSelectInstructions = false
    instructionTimer = 0
end

local highlighted = 1

function TitleScreenState:update(dt)
    instructionTimer = instructionTimer + dt
    if instructionTimer > 2 and instructionTimer < 4 then
       startInstructions = true 
    else
        startInstructions = false
    end

    if instructionTimer > 6 and instructionTimer < 8 then
        modeSelectInstructions = true
    else
        modeSelectInstructions = false
    end
    if instructionTimer > 8 then
        instructionTimer = 0
    end
---[[BUBBLE LOGIC
	if lavaBubble1.popped then --REMOVES POPPED LAVABUBBLES, REINSTANTIATES NEW ONES
		leftSpawnPoint = {9, 29}
		leftSpawnPoint = leftSpawnPoint[math.random(#leftSpawnPoint)]
		leftSpawnRandom = {1, 2, 5, 5, 7}
		leftSpawnRandom = leftSpawnRandom[math.random(#leftSpawnRandom)]
		lavaBubble1 = LavaBubble(leftSpawnPoint, VIRTUAL_HEIGHT, leftSpawnRandom)
	end

	if lavaBubble2.popped then --REMOVES POPPED LAVABUBBLES, REINSTANTIATES NEW ONES
		rightSpawnPoint = {VIRTUAL_WIDTH - 11, VIRTUAL_WIDTH - 30}
		rightSpawnPoint = rightSpawnPoint[math.random(#rightSpawnPoint)]
		rightSpawnRandom = {1, 2, 5, 5, 7}
		rightSpawnRandom = rightSpawnRandom[math.random(#rightSpawnRandom)]
		lavaBubble2 = LavaBubble(rightSpawnPoint, VIRTUAL_HEIGHT, rightSpawnRandom)
	end
	if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
		highlighted = highlighted == 1 and 2 or 1
		sounds['beep']:play()
	end

	lavaBubble1:update(dt)
	lavaBubble2:update(dt)

	if love.keyboard.wasPressed('h') then
		--gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		if highlighted == 1 then
            sounds['select']:play()
            twoPlayerMode = false
            gStateMachine:change('playState')
		else
            sounds['select']:play()
            twoPlayerMode = true
            gStateMachine:change('playState')
		end
	end
end


function TitleScreenState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

--[[
	love.graphics.setFont(smallFont)
	love.graphics.printf('JOUST small', 0, VIRTUAL_HEIGHT / 3 - 60, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('JOUST medium', 0, (VIRTUAL_HEIGHT / 3) * 2 - 60, VIRTUAL_WIDTH, 'center')
--]]

	if highlighted == 1 then
        love.graphics.setFont(smallFont)
		love.graphics.setColor(5/255, 158/255, 235/255, 255/255)
        love.graphics.printf('ONE PLAYER', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('ONE PLAYER', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center', 0, 1, 1, 1, 1)

	end

	if highlighted == 2 then
        love.graphics.setFont(smallFont)
		love.graphics.setColor(5/255, 158/255, 235/255, 255/255)
        love.graphics.printf('TWO PLAYERS', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('TWO PLAYERS', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center', 0, 1, 1, 1, 1)

    end

	love.graphics.setFont(largeFont)
    love.graphics.setColor(163/255, 3/255, 19/255, 255/255)
	love.graphics.printf('JOUST', 2, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(240/255, 234/255, 51/255, 255/255)
	love.graphics.printf('JOUST', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')



    --LAVA
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT, VIRTUAL_WIDTH, LAVAHEIGHT + 100)

    --GROUND PLATFORM
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)
	love.graphics.draw(groundBottom, 38, VIRTUAL_HEIGHT - 36)
    love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
    love.graphics.rectangle('fill', 100, 210, 20, 10)
	lavaBubble1:render()
	lavaBubble2:render()

	love.graphics.setFont(smallFont)
    --love.graphics.print('TIMER: ' .. tostring(math.floor(instructionTimer)), 0, 0)
    if startInstructions then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('PRESS ENTER TO START GAME', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, "center")
    end
    if modeSelectInstructions then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('LEFT OR RIGHT TO SELECT MODE', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, "center")
    end
end
