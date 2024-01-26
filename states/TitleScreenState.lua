TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT, 2)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT, 5)
    lavaRise = 0
    twoPlayerMode = false
    startInstructions = false
    modeSelectInstructions = false
    instructionTimer = 0
	groundPlatform = Platform('groundPlatform', -200, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + 300 , 36)
    attractModePlayer1 = Ostrich(-20, -20, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET - 24 , 1, 'escape', 'escape', 'escape')
    attractModePlayer1.graveyard = true
    attractModePlayer2 = Ostrich(-20, -20, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET - 24 , 2, 'escape', 'escape', 'escape')
    attractModePlayer2.graveyard = true
    attractModeBounder = Vulture(-20, -20, 16, 24, -20, 0.4, 1, 0)
    attractModeHunter = Vulture(-20, -20, 16, 24, -20, 0.4, 1, 0)
    attractModeShadowLord = Vulture(-20, -20, 16, 24, -20, 0.4, 1, 0)
	collidablePlatforms = {groundPlatform}
	PteroSpawnPoints = {}
	PteroSpawnPoints[1] = SpawnZonePoint(-24, 12, 1.8)
	PteroSpawnPoints[2] = SpawnZonePoint(-24, 75, 1.8)
	PteroSpawnPoints[3] = SpawnZonePoint(-24, VIRTUAL_HEIGHT - 80, 1.8)
	randomPteroIndex = math.random(3)
    attractModeMonster = Pterodactyl(PteroSpawnPoints[randomPteroIndex].x, PteroSpawnPoints[randomPteroIndex].y, PteroSpawnPoints[randomPteroIndex].dx)
    sounds['leftStep']:setVolume(0)
    sounds['rightStep']:setVolume(0)
    attractModePlayer1Timer = 0
    attractModePlayer2Timer = 0
    attractModeBounderTimer = 0
    attractModeHunterTimer = 0
    attractModeShadowLordTimer = 0
    resetTimer = 0
    pteroTimer = 39
    sfx = false
end

local highlighted = 1

function TitleScreenState:update(dt)
    if not sfx then
        sounds['bleep']:play()
        sfx = true
    end
    if attractModePlayer1Timer >= 0 then
        attractModePlayer1Timer = attractModePlayer1Timer + dt
    end
    if attractModePlayer2Timer >= 0 then
        attractModePlayer2Timer = attractModePlayer2Timer + dt
    end
    if attractModeBounderTimer >= 0 then
        attractModeBounderTimer = attractModeBounderTimer + dt
    end
    if attractModeHunterTimer >= 0 then
        attractModeHunterTimer = attractModeHunterTimer + dt
    end
    if attractModeShadowLordTimer >= 0 then
        attractModeShadowLordTimer = attractModeShadowLordTimer + dt
    end
    if attractModePlayer1Timer > 0.1 then
        attractModePlayer1 = Ostrich(ATTRACTMODETEXTOFFSET, VIRTUAL_HEIGHT - GROUND_OFFSET -24, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET - 24 , 1, 'escape', 'escape', 'escape')
        attractModePlayer1.spawning = false
        attractModePlayer1.grounded = true
        attractModePlayer1.temporarySafety = false
        attractModePlayer1.dx = 0.4
        attractModePlayer1.attractMode = true
        attractModePlayer1Timer = -1
    end
    if attractModePlayer2Timer > 5 then
        attractModePlayer2 = Ostrich(ATTRACTMODETEXTOFFSET, VIRTUAL_HEIGHT - GROUND_OFFSET -24, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET - 24 , 2, 'escape', 'escape', 'escape')
        attractModePlayer2.spawning = false
        attractModePlayer2.grounded = true
        attractModePlayer2.temporarySafety = false
        attractModePlayer2.dx = 0.4
        attractModePlayer2.attractMode = true
        attractModePlayer2Timer = -1
    end
    if attractModeBounderTimer > 11.5 then
        attractModeBounder = Vulture(ATTRACTMODETEXTOFFSET, VIRTUAL_HEIGHT - GROUND_OFFSET -24, 16, 24, -20, 0.4, 1, 0)
        attractModeBounder.spawnDelay = 0
        attractModeBounder.graveyard = false
        attractModeBounder.spawning = false
        attractModeBounder.grounded = true
        attractModeBounder.dx = 0.4
        attractModeBounder.attractMode = true
        attractModeBounderTimer = -1
    end
    if attractModeHunterTimer > 18 then
        attractModeHunter = Vulture(ATTRACTMODETEXTOFFSET, VIRTUAL_HEIGHT - GROUND_OFFSET -24, 16, 24, -20, 0.4, 1, 0)
        attractModeHunter.tier = 2
        attractModeHunter.spawnDelay = 0
        attractModeHunter.graveyard = false
        attractModeHunter.spawning = false
        attractModeHunter.grounded = true
        attractModeHunter.dx = 0.4
        attractModeHunter.attractMode = true
        attractModeHunterTimer = -1
    end
    if attractModeShadowLordTimer > 26 then
        attractModeShadowLord = Vulture(ATTRACTMODETEXTOFFSET, VIRTUAL_HEIGHT - GROUND_OFFSET -24, 16, 24, -20, 0.4, 1, 0)
        attractModeShadowLord.tier = 3
        attractModeShadowLord.spawnDelay = 0
        attractModeShadowLord.graveyard = false
        attractModeShadowLord.spawning = false
        attractModeShadowLord.grounded = true
        attractModeShadowLord.dx = 0.4
        attractModeShadowLord.attractMode = true
        attractModeShadowLordTimer = -1
    end
    if pteroTimer > 0 then
        pteroTimer = pteroTimer - dt
    end
    if pteroTimer < 0 then
        attractModeMonster = Pterodactyl(PteroSpawnPoints[randomPteroIndex].x, PteroSpawnPoints[randomPteroIndex].y, PteroSpawnPoints[randomPteroIndex].dx)
        attractModeMonster.attractMode = true
        attractModeMonster.graveyard = false
        pteroTimer = 39
        resetTimer = 3
    end
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
    elseif resetTimer < 0 then
        attractModePlayer1Timer = 0
        attractModePlayer2Timer = 0
        attractModeBounderTimer = 0
        attractModeHunterTimer = 0
        attractModeShadowLordTimer = 0
        pteroTimer = 39
        resetTimer = 0
    end
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

    attractModePlayer1:update(dt)
    attractModePlayer2:update(dt)
    attractModeBounder:update(dt)
    attractModeHunter:update(dt)
    attractModeShadowLord:update(dt)
    attractModeMonster:update(dt)

    if attractModePlayer1.x > VIRTUAL_WIDTH then
        attractModePlayer1.graveyard = true
    end
    if attractModePlayer2.x > VIRTUAL_WIDTH then
        attractModePlayer2.graveyard = true
    end
    if attractModeBounder.x > VIRTUAL_WIDTH then
        attractModeBounder.graveyard = true
    end
    if attractModeHunter.x > VIRTUAL_WIDTH then
        attractModeHunter.graveyard = true
    end
    if attractModeShadowLord.x > VIRTUAL_WIDTH then
        attractModeShadowLord.graveyard = true
    end
    if attractModeMonster.x > VIRTUAL_WIDTH then
        attractModeMonster.graveyard = true
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

	if highlighted == 1 then
        love.graphics.setFont(smallFont)
		love.graphics.setColor(5/255, 158/255, 235/255, 255/255)
        love.graphics.printf('ONE PLAYER', 0, VIRTUAL_HEIGHT / 2 + 23 -35, VIRTUAL_WIDTH, 'center')
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('ONE PLAYER', 0, VIRTUAL_HEIGHT / 2 + 23 -35, VIRTUAL_WIDTH, 'center', 0, 1, 1, 1, 1)

	end

	if highlighted == 2 then
        love.graphics.setFont(smallFont)
		love.graphics.setColor(5/255, 158/255, 235/255, 255/255)
        love.graphics.printf('TWO PLAYERS', 0, VIRTUAL_HEIGHT / 2 + 23 -35, VIRTUAL_WIDTH, 'center')
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('TWO PLAYERS', 0, VIRTUAL_HEIGHT / 2 + 23 -35, VIRTUAL_WIDTH, 'center', 0, 1, 1, 1, 1)

    end

	love.graphics.setFont(largeFont)
    love.graphics.setColor(163/255, 3/255, 19/255, 255/255)
	love.graphics.printf('JOUST', 2, VIRTUAL_HEIGHT / 2 - 19 -35, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(240/255, 234/255, 51/255, 255/255)
	love.graphics.printf('JOUST', 0, VIRTUAL_HEIGHT / 2 - 21 -35, VIRTUAL_WIDTH, 'center')

    --ATTRACT MODE RENDERS
    attractModePlayer1:render()
    attractModePlayer2:render()
    attractModeBounder:render()
    attractModeHunter:render()
    attractModeShadowLord:render()
    attractModeMonster:render()
    --LAVA
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT, VIRTUAL_WIDTH, LAVAHEIGHT + 100)

    --GROUND
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', groundPlatform.x, groundPlatform.y, groundPlatform.width, 4)
    --GROUND PLATFORM
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)
	love.graphics.draw(groundBottom, 38, VIRTUAL_HEIGHT - 36)
    love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
    love.graphics.rectangle('fill', 100, 210, 20, 10)
	lavaBubble1:render()
	lavaBubble2:render()

	love.graphics.setFont(smallFont)
    if startInstructions then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('PRESS ENTER TO START GAME', 0, 10, VIRTUAL_WIDTH, "center")
    end
    if modeSelectInstructions then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('LEFT OR RIGHT TO SELECT MODE', 0, 10, VIRTUAL_WIDTH, "center")
    end
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.print('PLAYER 1', attractModePlayer1.x + ATTRACTMODEX, attractModePlayer1.y + ATTRACTMODEY)
    love.graphics.print('PLAYER 2', attractModePlayer2.x + ATTRACTMODEX, attractModePlayer2.y + ATTRACTMODEY)
    love.graphics.print('BOUNDER (500)', attractModeBounder.x + ATTRACTMODEX, attractModeBounder.y + ATTRACTMODEY)
    love.graphics.print('HUNTER (750)', attractModeHunter.x + ATTRACTMODEX, attractModeHunter.y + ATTRACTMODEY)
    love.graphics.print('SHADOWLORD (1500)', attractModeShadowLord.x + ATTRACTMODEX, attractModeShadowLord.y + ATTRACTMODEY)
end
