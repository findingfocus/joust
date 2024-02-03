PlayState = Class{__includes = BaseState}

function PlayState:init()
    conflict = false
    sounds['theme']:stop()
	platform1 = Platform('platform1R', 233, 68, 69, 7)
	platform1L = Platform('platform1L', -35, 68, 69, 7)
	platform2 = Platform('platform2', 70, 77, 94, 7)
	platform3 = Platform('platform3', 192, 120, 50, 7)
	platform4 = Platform('platform4', 233, 129, 79, 7)
	platform4L = Platform('platform4L', -35, 129, 79, 7)
	platform5 = Platform('platform5', 86, 146, 69, 7)
    platform2LeftWipeX = 70
    platform2LeftWipeY = 77
    platform2RightWipeX = 164
    platform2RightWipeWidth = 0
    platform2LeftWipeWidth = 0
    platform2WipeTimer = 0
    Score = 0
    Score2 = 0
	lavaBubble1 = LavaBubble(22, VIRTUAL_HEIGHT, 2)
	lavaBubble2 = LavaBubble(VIRTUAL_WIDTH - 11, VIRTUAL_HEIGHT, 5)
	collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
    platform2Removed = false
	Vultures = {}
	Eggs = {}
	Jockeys = {}
	Taxis = {}
	scoresTable = {}
    eggsCaught = 0
    timesEggHatched = {} -- {0, 0, 0, 0}
    legalSpawns = {1, 2, 3, 4}
	wave = 1
	lives = 5
    player2Lives = 5
	spawnPointIndex = 0
	vultureSpawnPointIndex = 0
    enemyObjects = 0
    lavaRise = 0
    waveTimer = 3
    eggWaveTextTimer = 3
    grabTimer = 0
    groundX = 0
    groundY = VIRTUAL_HEIGHT - 36
    backgroundTransparency = 100
    eggWaveTransitionTimer = 0
    wave5Timer = 0
    wave10Timer = 0
    wave15Timer = 0
    wave20Timer = 0
    wave25Timer = 0
    leftFireTimer = 0
    rightFireTimer = 0
    groundWidth = VIRTUAL_WIDTH
	helpToggle = false
	gameOver = false
	tablesPopulated = false
    leftFireCollided = false
    rightFireCollided = false
    SpawnZone1Conflict = false
    SpawnZone2Conflict = false
    SpawnZone3Conflict = false
    SpawnZone4Conflict = false
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 5, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET, 1, 'o', 'p', 'i')
	player1.y = VIRTUAL_HEIGHT - GROUND_OFFSET - player1.height
	player1.temporarySafety = false
    if twoPlayerMode then
        player2 = Ostrich(VIRTUAL_WIDTH / 3 + 25, VIRTUAL_HEIGHT - GROUND_OFFSET, 16, 24, VIRTUAL_HEIGHT - GROUND_OFFSET, 2, 'x', 'c', 'z')
        player2.y = VIRTUAL_HEIGHT - GROUND_OFFSET - player2.height
        player2.temporarySafety = false
    end
    floorRetracted = false
	groundPlatform = Platform('groundPlatform', -player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	vultureCount = 0
	pteroTimer = 0
	SpawnZonePoints = {}
	SpawnZonePoints[1] = SpawnZonePoint(platform3.x + 20, platform3.y, 0, 1)
	SpawnZonePoints[2] = SpawnZonePoint(platform4L.x + platform4L.width - 27, platform4L.y, 0, 2)
	SpawnZonePoints[3] = SpawnZonePoint(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y, 0, 3)
	SpawnZonePoints[4] = SpawnZonePoint(platform2.x + 20, platform2.y, 0, 4)
	PteroSpawnPoints = {}
	PteroSpawnPoints[1] = SpawnZonePoint(-24, 12, 1.8)
	PteroSpawnPoints[2] = SpawnZonePoint(VIRTUAL_WIDTH, 12, -1.8)
	PteroSpawnPoints[3] = SpawnZonePoint(-24, 75, 1.8)
	PteroSpawnPoints[4] = SpawnZonePoint(VIRTUAL_WIDTH, 75, -1.8)
	PteroSpawnPoints[5] = SpawnZonePoint(-24, VIRTUAL_HEIGHT - 80, 1.8)
	PteroSpawnPoints[6] = SpawnZonePoint(VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 80, -1.8)
	randomPteroIndex = math.random(6)
	monster = Pterodactyl(-30, -30, 0)
    wave = 1
    fireAnimation = .2
    fireSprite = 1
    sounds['leftStep']:setVolume(1)
    sounds['rightStep']:setVolume(1)
    gameOverTimer = 0
    roarTimer = 0
end

function leftTrollCollide(player)
    if player.x < 28 and player.x + player.width > 20 then
        if player.y < VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise and player.y + player.height > VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 12 then
            return true
        end
    else
        return false
    end
end

function rightTrollCollide(player)
    if player.x < VIRTUAL_WIDTH - 16 and player.x + player.width > VIRTUAL_WIDTH - 16 then
        if player.y < VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise and player.y + player.height > VIRTUAL_HEIGHT -LAVAHEIGHT - lavaRise - 12 then
            return true
        end
    else
        return false
    end
end


function PlayState:checkGrounded(topObject, bottomObject)
	if topObject.y == bottomObject.y - bottomObject.height then
		return true
	else
		return false
	end
end

function waveAdvance(enemies)
    for i = 1, enemies do
        if not Eggs[i].collected then
            return false
        end
    end
    wave = wave + 1
    Score = Score + 3000
    if twoPlayerMode then
        Score2 = Score2 + 3000
    end
    waveTimer = 3
    eggsCaught = 0
    tablesPopulated = false
    return true
end

function spawnEnemies(enemyAmount, zoneAmount)
    for i = 1, enemyAmount do
        vultureSpawnPointIndex = math.random(zoneAmount)
        Vultures[i] = Vulture(SpawnZonePoints[vultureSpawnPointIndex].x, SpawnZonePoints[vultureSpawnPointIndex].y, 16, 24, SpawnZonePoints[vultureSpawnPointIndex].y, -1, i, i + 2)
        pteroTimer = pteroTimer + 20
    end
end

function floorRetract()
    if groundPlatform.width > 183 then
        groundPlatform.x = groundPlatform.x + .1
        groundPlatform.width  = groundPlatform.width - .2
    else
        floorRetracted = true
        groundPlatform.width = 183
    end
end

function eggWavePrint(dt)
    if eggWaveTextTimer == 3 then
        eggWaveText = true
    end
    if eggWaveText then
        eggWaveTextTimer = eggWaveTextTimer - dt
        if eggWaveTextTimer < 0 then
            eggWaveText = false
        end
    end
end

function platformRetract(platform)
    platform.retracting = true
    if platform.retractingLeftWidth < (platform.width / 2) then
        platform.retractingLeftWidth = platform.retractingLeftWidth + 1
    else
        platform.retractingLeftWidth = (platform.width / 2)
        platform.retracted = true
    end

    if platform.retractingRightX > (platform.x + (platform.width / 2)) then
        platform.retractingRightX = platform.retractingRightX - 1
        platform.retractingRightWidth = platform.retractingRightWidth + 1
    else
        platform.retractingRightX = (platform.x + (platform.width / 2))
        platform.retracted = true
    end
    --REMOVE RETRACTED TABLE FROM COLLIDABLE TABLE PLATFORMS
    for k, platform in pairs(collidablePlatforms) do
        if platform.retracted then
            table.remove(collidablePlatforms, k)
        end
    end
end

function eggPlacement()
    Eggs[1].x = platform1L.x + platform1L.width - Eggs[1].width - 12
    Eggs[1].y = platform1L.y - Eggs[1].height
    Eggs[1].graveyard = false
    Eggs[1].hatchCountdown = 30
    Eggs[2].x = platform2.x + 16
    Eggs[2].y = platform2.y - Eggs[2].height
    Eggs[2].graveyard = false
    Eggs[2].hatchCountdown = 30
    Eggs[3].x = platform2.x + platform2.width - 27
    Eggs[3].y = platform2.y - Eggs[3].height
    Eggs[3].graveyard = false
    Eggs[3].hatchCountdown = 30
    Eggs[4].x = platform4.x + 4
    Eggs[4].y = platform4.y - Eggs[4].height
    Eggs[4].graveyard = false
    Eggs[4].hatchCountdown = 30
    Eggs[5].x = platform5.x + 35
    Eggs[5].y = platform5.y - Eggs[5].height
    Eggs[5].graveyard = false
    Eggs[5].hatchCountdown = 30
    Eggs[6].x = 58
    Eggs[6].y = groundPlatform.y - Eggs[6].height
    Eggs[6].graveyard = false
    Eggs[6].hatchCountdown = 30
    Eggs[7].x = 145
    Eggs[7].y = groundPlatform.y - Eggs[7].height
    Eggs[7].graveyard = false
    Eggs[7].hatchCountdown = 30
end

function legalSpawn()
    --PLAYER1 SPAWN CONFLICTS
    --POINT 1
    if player1.x > platform3.x + 20 - player1.width and player1.x + player1.width < platform3.x + 20 + SPAWNSAFETYWIDTH then
        if player1.y < platform3.y and player1.y > platform3.y - SPAWNSAFETYHEIGHT then
            SpawnZone1Conflict = true
        else
            SpawnZone1Conflict = false
        end
    else
        SpawnZone1Conflict = false
    end
    --POINT 2
    if player1.x > platform4L.x + platform4L.width - 27 -player1.width and player1.x + player1.width < platform4L.x + platform4L.width - 27 + SPAWNSAFETYWIDTH then
        if player1.y < platform4L.y and player1.y > platform4L.y - SPAWNSAFETYHEIGHT then
            SpawnZone2Conflict = true
        else
            SpawnZone2Conflict = false
        end
    else
        SpawnZone2Conflict = false
    end
    --POINT 3
    if player1.x > VIRTUAL_WIDTH / 2 - 30 - player1.width and player1.x + player1.width < VIRTUAL_WIDTH / 2 - 30 + SPAWNSAFETYWIDTH then
        if player1.y < groundPlatform.y and player1.y > groundPlatform.y - SPAWNSAFETYHEIGHT then
            SpawnZone3Conflict = true
        else
            SpawnZone3Conflict = false
        end
    else
        SpawnZone3Conflict = false
    end
    --POINT 4
    if player1.x > platform2.x + 20 - player1.width and player1.x + player1.width < platform2.x + 20 + SPAWNSAFETYWIDTH then
        if player1.y < platform2.y and player1.y > platform2.y - SPAWNSAFETYHEIGHT then
            SpawnZone4Conflict = true
        else
            SpawnZone4Conflict = false
        end
    else
        SpawnZone4Conflict = false
    end

    --PLAYER2 SPAWN CONFLICTS
    --POINT 1
    ---[[
    if twoPlayerMode then
        if player2.x > platform3.x + 20 - player2.width and player2.x + player2.width < platform3.x + 20 + SPAWNSAFETYWIDTH then
            if player2.y < platform3.y and player2.y > platform3.y - SPAWNSAFETYHEIGHT then
                SpawnZone1Conflict2 = true
            else
                SpawnZone1Conflict2 = false
            end
        else
            SpawnZone1Conflict2 = false
        end

        --POINT 2
        if player2.x > platform4L.x + platform4L.width - 27 -player2.width and player2.x + player2.width < platform4L.x + platform4L.width - 27 + SPAWNSAFETYWIDTH then
            if player2.y < platform4L.y and player2.y > platform4L.y - SPAWNSAFETYHEIGHT then
                SpawnZone2Conflict2 = true
            else
                SpawnZone2Conflict2 = false
            end
        else
            SpawnZone2Conflict2 = false
        end
        --POINT 3
        if player2.x > VIRTUAL_WIDTH / 2 - 30 - player2.width and player2.x + player2.width < VIRTUAL_WIDTH / 2 - 30 + SPAWNSAFETYWIDTH then
            if player2.y < groundPlatform.y and player2.y > groundPlatform.y - SPAWNSAFETYHEIGHT then
                SpawnZone3Conflict2 = true
            else
                SpawnZone3Conflict2 = false
            end
        else
            SpawnZone3Conflict2 = false
        end
        --POINT 4
        if player2.x > platform2.x + 20 - player2.width and player2.x + player2.width < platform2.x + 20 + SPAWNSAFETYWIDTH then
            if player2.y < platform2.y and player2.y > platform2.y - SPAWNSAFETYHEIGHT then
                SpawnZone4Conflict2 = true
            else
                SpawnZone4Conflict2 = false
            end
        else
            SpawnZone4Conflict2 = false
        end
    end

    --PLAYER 1 CONFLICT SPAWNZONE REMOVAL
    for i, v in pairs(legalSpawns) do
        if legalSpawns[i] == 1 then
            if SpawnZone1Conflict then
                table.remove(legalSpawns, i)
            end
        end
        if legalSpawns[i] == 2 then
            if SpawnZone2Conflict then
                table.remove(legalSpawns, i)
            end
        end
        if legalSpawns[i] == 3 then
            if SpawnZone3Conflict then
                table.remove(legalSpawns, i)
            end
        end
        if legalSpawns[i] == 4 then
            if SpawnZone4Conflict then
                table.remove(legalSpawns, i)
            end
        end
    end

    if twoPlayerMode then
        --PLAYER 2 CONFLICT SPAWNZONE REMOVAL
        for i, v in pairs(legalSpawns) do
            if legalSpawns[i] == 1 then
                if SpawnZone1Conflict2 then
                    table.remove(legalSpawns, i)
                end
            end
            if legalSpawns[i] == 2 then
                if SpawnZone2Conflict2 then
                    table.remove(legalSpawns, i)
                end
            end
            if legalSpawns[i] == 3 then
                if SpawnZone3Conflict2 then
                    table.remove(legalSpawns, i)
                end
            end
            if legalSpawns[i] == 4 then
                if SpawnZone4Conflict2 then
                    table.remove(legalSpawns, i)
                end
            end
        end
    end
end


function PlayState:update(dt)

    if not helpToggle then
        if leftFireCollided then
            love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
            love.graphics.rectangle('fill', 16, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 8, 16)
        end
        if rightFireCollided then
            love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
            love.graphics.rectangle('fill', VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 8, 16)
        end

        --LAVA FIRE ANIMATION
        fireAnimation = fireAnimation - dt
        if fireAnimation < 0 then
            fireAnimation = .2
            fireSprite = fireSprite + 1
            if fireSprite > 3 then
                fireSprite = 1
            end
        end

        --PTERODACTYL SPAWN
        if pteroTimer > 0 then
            pteroTimer = pteroTimer - dt
        end

        if pteroTimer < 0 then
            sounds['ptero']:play()
            monster = Pterodactyl(PteroSpawnPoints[randomPteroIndex].x, PteroSpawnPoints[randomPteroIndex].y, PteroSpawnPoints[randomPteroIndex].dx)
            monster.graveyard = false
            pteroTimer = 0
        end

        if monster.graveyard == false then
                roarTimer = roarTimer + dt
                if roarTimer > 7 then
                    sounds['ptero']:play()
                    roarTimer = 0
                end
        end

        if waveTimer > 0 then
            waveTimer = waveTimer - dt
        end

        if love.keyboard.wasPressed('h') then
            helpToggle = not helpToggle
        end

        ---[[WAVE LOGIC
        if wave == 1 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()

            enemyObjects = 3
            --GLOBAL OBJECT TABLE DUMMY INITIALIZATION
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                    sounds['explode']:stop()
                end
                spawnEnemies(enemyObjects, 4)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 2 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 4
            if lavaRise < 5 then
                lavaRise = lavaRise + dt
            end
            --GLOBAL OBJECT TABLE DUMMY INITIALIZATION
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 3 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            if not floorRetracted then
                floorRetract()
            end
            enemyObjects = 5
            if lavaRise < 11 then
                lavaRise = lavaRise + dt
            end

            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 4 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 5
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 5 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            eggWaveTransitionTimer = eggWaveTransitionTimer + dt
            eggWavePrint(dt)
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 0)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                end
                eggPlacement()
                tablesPopulated = true
            end

            if eggWaveTransitionTimer > 18 then
                wave = 6
                waveTimer = 3
                eggWaveTextTimer = 3
                eggsCaught = 0
                tablesPopulated = false
                for i = 1, enemyObjects do
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Eggs[i].collected = true
                end
                eggWaveTransitionTimer = 0
            end
        end

        if wave == 6 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            --PLATFORM 2 RETRACTION
            if not platform2.retracted then
                platformRetract(platform2)
                --TODO add gravity for ostrich standing on removed platform
                if platform2.retracted then
                    player1.ground = Platform('name', 1, 1, 1, 1)
                    legalSpawns = {1, 2, 3}
                    --REMOVE SPAWN POINT
                    --[[
                    for i, v in pairs(legalSpawns) do
                        if legalSpawns[i] == 2 then
                            table.remove(legalSpawns, i)
                        end
                    end
                    --]]
                end
            end

            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 7 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            --PLATFORM 1 and 1L RETRACTION
            if not platform1.retracted then
                platformRetract(platform1)
            end
            if not platform1L.retracted then
                platformRetract(platform1L)
            end
            platform2.retracted = true
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
            end
            waveAdvance(enemyObjects)
        end

        if wave == 8 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform2.retracted = true
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 9 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform2.retracted = true
            if not platform5.retracted then
                platformRetract(platform5)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 10 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            eggWaveTransitionTimer = eggWaveTransitionTimer + dt
            eggWavePrint(dt)
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 0)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                end
                platform1 = Platform('platform1R', 233, 68, 69, 7)
                platform1L = Platform('platform1L', -35, 68, 69, 7)
                platform2 = Platform('platform2', 70, 77, 94, 7)
                platform5 = Platform('platform5', 86, 146, 69, 7)
                collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
                eggPlacement()
                tablesPopulated = true
            end

            if eggWaveTransitionTimer > 18 then
                wave = 11
                waveTimer = 3
                eggWaveTextTimer = 3
                eggsCaught = 0
                tablesPopulated = false
                for i = 1, enemyObjects do
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Eggs[i].collected = true
                end
                eggWaveTransitionTimer = 0
            end
        end

        if wave == 11 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            if not platform1.retracted then
                platformRetract(platform1)
            end
            if not platform1L.retracted then
                platformRetract(platform1L)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 12 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            ---[[
            platform1.retracted = true
            platform1L.retracted = true
            --]]
            if not platform5.retracted then
                platformRetract(platform5)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 13 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            ---[[
            platform5.retracted = true
            platform1.retracted = true
            platform1L.retracted = true
            --]]
            if not platform2.retracted then
                platformRetract(platform2)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 14 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform2.retracted = true
            ---[[
            collidablePlatforms = {platform3, platform4, platform4L}
            --]]
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end
        if wave == 15 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            eggWaveTransitionTimer = eggWaveTransitionTimer + dt
            eggWavePrint(dt)
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 0)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                end
                platform1 = Platform('platform1R', 233, 68, 69, 7)
                platform1L = Platform('platform1L', -35, 68, 69, 7)
                platform2 = Platform('platform2', 70, 77, 94, 7)
                platform5 = Platform('platform5', 86, 146, 69, 7)
                collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
                eggPlacement()
                tablesPopulated = true
            end

            if eggWaveTransitionTimer > 18 then
                wave = 16
                waveTimer = 3
                eggsCaught = 0
                tablesPopulated = false
                for i = 1, enemyObjects do
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Eggs[i].collected = true
                end
                eggWaveTransitionTimer = 0
            end
        end
        if wave == 16 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            if not platform5.retracted then
                platformRetract(platform5)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 17 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            platform5.retracted = true
            if not platform1.retracted then
                platformRetract(platform1)
            end
            if not platform1L.retracted then
                platformRetract(platform1L)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end

        if wave == 18 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            platform1.retracted = true
            platform1L.retracted = true
            platform5.retracted = true
            if not platform2.retracted then
                platformRetract(platform2)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end
        if wave == 19 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform1.retracted = true
            platform1L.retracted = true
            platform2.retracted = true
            platform5.retracted = true
            collidablePlatforms = {platform3, platform4, platform4L}
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 2
            end
            waveAdvance(enemyObjects)
        end
        if wave == 20 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            eggWaveTransitionTimer = eggWaveTransitionTimer + dt
            eggWavePrint(dt)
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 0)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                end
                platform1 = Platform('platform1R', 233, 68, 69, 7)
                platform1L = Platform('platform1L', -35, 68, 69, 7)
                platform2 = Platform('platform2', 70, 77, 94, 7)
                platform5 = Platform('platform5', 86, 146, 69, 7)
                collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
                eggPlacement()
                tablesPopulated = true
            end

            if eggWaveTransitionTimer > 18 then
                wave = 21
                waveTimer = 3
                eggWaveTextTimer = 3
                eggsCaught = 0
                tablesPopulated = false
                for i = 1, enemyObjects do
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Eggs[i].collected = true
                end
                eggWaveTransitionTimer = 0
            end
        end
        if wave == 21 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            if not platform5.retracted then
                platformRetract(platform5)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
                Vultures[3].tier = 2
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 3
            end
            waveAdvance(enemyObjects)
        end
        if wave == 22 then
            legalSpawns = {1, 2, 3, 4}
            legalSpawn()
            enemyObjects = 7
            platform5.retracted = true
            if not platform1.retracted then
                platformRetract(platform1)
            end
            if not platform1L.retracted then
                platformRetract(platform1L)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 4)
                Vultures[3].tier = 2
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 3
            end
            waveAdvance(enemyObjects)
        end
        if wave == 23 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform5.retracted = true
            platform1.retracted = true
            platform1L.retracted = true
            if not platform2.retracted then
                platformRetract(platform2)
            end
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[3].tier = 2
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 3
            end
            waveAdvance(enemyObjects)
        end
        if wave == 24 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            platform5.retracted = true
            platform1.retracted = true
            platform1L.retracted = true
            platform2.retracted = true
            collidablePlatforms = {platform3, platform4, platform4L}
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 5)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    tablesPopulated = true
                end
                spawnEnemies(enemyObjects, 3)
                Vultures[3].tier = 2
                Vultures[4].tier = 2
                Vultures[5].tier = 2
                Vultures[6].tier = 2
                Vultures[7].tier = 3
            end
            waveAdvance(enemyObjects)
        end
        if wave == 25 then
            legalSpawns = {1, 2, 3}
            legalSpawn()
            enemyObjects = 7
            eggWaveTransitionTimer = eggWaveTransitionTimer + dt
            eggWavePrint(dt)
            if not tablesPopulated then
                for i = 1, enemyObjects do
                    timesEggHatched[i] = 0
                    table.insert(scoresTable, PrintScore(-20, -20, 0, true, i))
                    Vultures[i] = Vulture(-20, -20, 16, 24, -20, -1, i, 0)
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Jockeys[i] = Jockey(-20, -20, i)
                    Taxis[i] = Taxi(-40, -40, 16, 24, i)
                end
                platform1 = Platform('platform1R', 233, 68, 69, 7)
                platform1L = Platform('platform1L', -35, 68, 69, 7)
                platform2 = Platform('platform2', 70, 77, 94, 7)
                platform5 = Platform('platform5', 86, 146, 69, 7)
                collidablePlatforms = {platform1, platform1L, platform2, platform3, platform4, platform4L, platform5}
                eggPlacement()
                tablesPopulated = true
            end

            if eggWaveTransitionTimer > 18 then
                gStateMachine:change('highScoreState')
                --[[
                waveTimer = 3
                eggWaveTextTimer = 3
                eggsCaught = 0
                tablesPopulated = false
                for i = 1, enemyObjects do
                    Eggs[i] = Egg(-10, -10, 0, i)
                    Eggs[i].collected = true
                end
                eggWaveTransitionTimer = 0
                --]]
            end
        end
        --]]

        ---[[RESETS
        --RESET PLAYER
        if love.keyboard.wasPressed('r') then
            player1 = Ostrich(platform3.x, platform3.y, 16, 24, platform3.y, 1, 'o', 'p', 'i')
            sounds['leftStep']:stop()
            sounds['rightStep']:stop()
            sounds['skid']:stop()
        end

        if love.keyboard.wasPressed('n') then
            for i = 1, enemyObjects do
                Vultures[i].graveyard = true
                Eggs[i].collected = true
            end
        end

        --RESET VULTURES
        if love.keyboard.wasPressed('v') and not Vultures[3].spawning then
            Vulture1 = Vulture(VIRTUAL_WIDTH / 2 - 30, groundPlatform.y, 16, 24, groundPlatform.y, -1, 1, 1)
            Vulture2 = Vulture(VIRTUAL_WIDTH / 2, groundPlatform.y, 16, 24, groundPlatform.y, -1, 2, 1)
            Vulture3 = Vulture(VIRTUAL_WIDTH / 2 + 30, groundPlatform.y, 16, 24, groundPlatform.y, -1, 3, 1)
            Vulture1.graveyard = false
            Vulture2.graveyard = false
            Vulture3.graveyard = false
            Vultures[1] = Vulture1
            Vultures[2] = Vulture2
            Vultures[3] = Vulture3
            Vultures[1].tier = 1
            Vultures[2].tier = 1
            Vultures[3].tier = 1
            Eggs[1].midairBonus = true
            Eggs[2].midairBonus = true
            Eggs[3].midairBonus = true
            scoresTable[1].bonus = true
            scoresTable[2].bonus = true
            scoresTable[3].bonus = true
        end
        --]]

        --PLAYER 1 RESPAWN
        if player1.exploded and player1.explosionTimer > .35 then
            --SENDS PTERO TO GRAVEYARD UPON PLAYER DEATH
            monster = Pterodactyl(-30, -30, 0)
            pteroTimer = vultureCount * 20
            if lives == 1 then
                lives = lives - 1
                gameOver = true
            else
                --player1.exploded = false
                lives = lives - 1

                randomIndex = math.random(#legalSpawns)
                spawnPointIndex = legalSpawns[randomIndex]
                if lives > 0 then
                    player1 = Ostrich(SpawnZonePoints[spawnPointIndex].x, SpawnZonePoints[spawnPointIndex].y, 16, 24, SpawnZonePoints[spawnPointIndex].y, 1, 'o', 'p', 'i')
                    sounds['respawn']:stop()
                    sounds['respawn']:play()
                else
                    lives = 0
                    player1.graveyard = true
                end
            end
        end

        --HIGHSCORE STATE TRIGGER
        if gameOver then
            gameOverTimer = gameOverTimer + dt
            if gameOverTimer > 3 then
                gStateMachine:change('highScoreState')
            end
        end


        --PLAYER 2 RESPAWN
        if twoPlayerMode then
            if player2.exploded and player2.explosionTimer > .35 then
                pteroTimer = vultureCount * 20
                if player2Lives == 1 then
                    player2Lives = player2Lives - 1
                    gameOver = true
                else
                    player2Lives = player2Lives - 1

                    randomIndex = math.random(#legalSpawns)
                    spawnPointIndex = legalSpawns[randomIndex]

                    if player2Lives > 0 then
                        player2 = Ostrich(SpawnZonePoints[spawnPointIndex].x, SpawnZonePoints[spawnPointIndex].y, 16, 24, SpawnZonePoints[spawnPointIndex].y, 2, 'x', 'c', 'z')
                        sounds['respawn2']:stop()
                        sounds['respawn2']:play()
                    end
                end
            end
        end

        if vultureCount == 0 then --KILLS PTERO IF NO VULTURES ON SCREEN
            monster = Pterodactyl(-30, -30, 0)
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
        --]]

        ---[[VULTURE TO VULTURE COLLISION
        for i, vulture in pairs(Vultures) do
            for index, others in pairs(Vultures) do
                if vulture.index ~= index then
                    if vulture:Collides(others) then
                        vulture.dx = vulture.dx * -1
                        others.dx = others.dx * -1
                        if vulture.x < others.x then
                            others.x = vulture.x + vulture.width + 2
                        else
                            others.x = vulture.x - others.width - 2
                        end
                    end
                end
            end
        end
        --]]
        ---[[PLAYER TO PLAYER COLLISION
        if twoPlayerMode then
            --PLAYER 2 BOTTOM COLLIDES
            if player2:bottomCollides(player1) then
                if player2.dy ~= 0 then
                    player2.dy = -.4
                end
                player1.dy = 0
                player1.y = player2.y + player2.height
            end
            --PLAYER 1 TOP COLLIDES
            if player1:topCollides(player2) then
                if player1.dy ~= 0 then
                    player1.dy = .4
                end
                player1.y = player2.y + player2.height
            end

            --PLAYER 1 BOTTOM COLLIDES
            if player1:bottomCollides(player2) then
                if player1.dy ~= 0 then
                    player1.dy = -.4
                end
                player2.dy = 0
                player2.y = player1.y + player1.height
            end

            --PLAYER 1 RIGHT COLLIDES
            if player1:rightCollides(player2) then
                sounds['bleep']:stop()
                sounds['bleep']:play()
                if player2.dx == 0 then --PLAYER1 BOUNCES OFF STATIONARY PLAYER 2
                    player1.x = player2.x - player1.width
                    player1.dx = math.abs(player1.dx) * -1
                else
                    player2.x = player1.x + player1.width
                    player2.dx = math.abs(player2.dx)
                    player1.dx = math.abs(player1.dx) * -1
                end
            end
            --PLAYER 1 LEFT COLLIDES
            if player1:leftCollides(player2) then
                sounds['bleep']:stop()
                sounds['bleep']:play()
                if player2.dx == 0 then
                    player1.x = player2.x + player2.width
                    player1.dx = math.abs(player1.dx)
                else
                    player2.x = player1.x - player2.width
                    player2.dx = math.abs(player2.dx) * -1
                    player1.dx = math.abs(player1.dx)
                end
            end
        end
        --]]

        ---[[PLAYER TO ENEMY COLLISIONS
        for i = 1, enemyObjects do
            if not player1.temporarySafety then
                if Vultures[i].spawning == false then
                    if player1:enemyTopCollides(Vultures[i]) then
                        player1.exploded = true
                        sounds['explode']:play()
                        player1.graveyard = true
                        Vultures[i].dy = Vultures[i].dy * -1
                    elseif player1:enemyBottomCollides(Vultures[i]) then
                        Vultures[i].exploded = true
                        sounds['explode']:play()
                        Vultures[i].graveyard = true
                        Vultures[i].dxAssigned = false
                        Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                        Eggs[i].graveyard = false
                        Eggs[i].invulnerable = true
                        pteroTimer = vultureCount * 20 - 20
                        Vultures[i].firstFrameExploded = true
                        player1.dy = player1.dy * -1
                        Score = Score + Vultures[i].pointTier
                    elseif player1:enemyLeftCollides(Vultures[i]) then
                        if player1.facingRight and Vultures[i].facingRight then
                            player1.exploded = true
                            sounds['explode']:play()
                            player1.graveyard = true
                        elseif not player1.facingRight and not Vultures[i].facingRight then
                            player1.x = Vultures[i].x + Vultures[i].width
                            player1.dx = math.abs(player1.dx) / 2
                        elseif player1.facingRight and not Vultures[i].facingRight then
                            sounds['bleep']:play()
                            player1.dx = player1.dx * -1
                            player1.x = Vultures[i].x + Vultures[i].width
                        elseif not player1.facingRight and Vultures[i].facingRight then
                            if player1.y == Vultures[i].y then
                                sounds['collide']:play()
                                player1.dx = player1.dx * -1
                                Vultures[i].dx = Vultures[i].dx * -1
                                Vultures[i].x = player1.x - Vultures[i].width
                            elseif player1.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
                                sounds['explode']:play()
                                player1.exploded = true
                                player1.graveyard = true
                            elseif player1.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
                                sounds['explode']:play()
                                Vultures[i].exploded = true
                                Vultures[i].graveyard = true
                                Vultures[i].dxAssigned = false
                                Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                                Eggs[i].graveyard = false
                                Eggs[i].invulnerable = true
                                pteroTimer = vultureCount * 20 - 20
                                Vultures[i].firstFrameExploded = true
                                Score = Score + Vultures[i].pointTier
                            end
                        end
                    elseif player1:enemyRightCollides(Vultures[i]) then
                        if player1.facingRight and Vultures[i].facingRight then
                            player1.x = Vultures[i].x - player1.width
                            player1.dx = (math.abs(player1.dx) * -1) / 2
                        elseif not player1.facingRight and not Vultures[i].facingRight then
                            sounds['explode']:play()
                            player1.exploded = true
                            player1.graveyard = true
                        elseif player1.facingRight and not Vultures[i].facingRight then
                            if player1.y == Vultures[i].y then
                                sounds['collide']:play()
                                player1.dx = player1.dx * -1
                                Vultures[i].dx = Vultures[i].dx * -1
                                Vultures[i].x = player1.x + player1.width
                            elseif player1.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
                                pteroTimer = vultureCount * 20 - 20
                                Vultures[i].exploded = true
                                sounds['explode']:play()
                                Vultures[i].graveyard = true
                                Vultures[i].dxAssigned = false
                                Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                                Eggs[i].graveyard = false
                                Eggs[i].invulnerable = true
                                Vultures[i].firstFrameExploded = true
                                Score = Score + Vultures[i].pointTier
                            elseif player1.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
                                player1.exploded = true
                                sounds['explode']:play()
                                player1.graveyard = true
                            end
                        elseif not player1.facingRight and Vultures[i].facingRight then
                            sounds['collide']:play()
                            player1.dx = player1.dx * -1
                            player1.x = Vultures[i].x - player1.width
                        end
                    end
                end
            end

            --PLAYER 2 ENEMY COLLISIONS
            if twoPlayerMode then
                if not player2.temporarySafety then
                    if Vultures[i].spawning == false then
                        if player2:enemyTopCollides(Vultures[i]) then
                            player2.exploded = true
                            sounds['explode']:play()
                            player2.graveyard = true
                            Vultures[i].dy = Vultures[i].dy * -1
                        elseif player2:enemyBottomCollides(Vultures[i]) then
                            Vultures[i].exploded = true
                            sounds['explode']:play()
                            Vultures[i].graveyard = true
                            Vultures[i].dxAssigned = false
                            Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                            Eggs[i].graveyard = false
                            Eggs[i].invulnerable = true
                            pteroTimer = vultureCount * 20 - 20
                            Vultures[i].firstFrameExploded = true
                            player2.dy = player2.dy * -1
                            Score = Score + Vultures[i].pointTier
                        elseif player2:enemyLeftCollides(Vultures[i]) then
                            if player2.facingRight and Vultures[i].facingRight then
                                player2.exploded = true
                                sounds['explode']:play()
                                player2.graveyard = true
                            elseif not player2.facingRight and not Vultures[i].facingRight then
                                sounds['bleep']:play()
                                player2.x = Vultures[i].x + Vultures[i].width
                                player2.dx = math.abs(player2.dx) / 2
                            elseif player2.facingRight and not Vultures[i].facingRight then
                                sounds['collide']:play()
                                player2.dx = player2.dx * -1
                                player2.x = Vultures[i].x + Vultures[i].width
                            elseif not player2.facingRight and Vultures[i].facingRight then
                                if player2.y == Vultures[i].y then
                                    sounds['collide']:play()
                                    player2.dx = player2.dx * -1
                                    Vultures[i].dx = Vultures[i].dx * -1
                                    Vultures[i].x = player2.x - Vultures[i].width
                                elseif player2.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
                                    player2.exploded = true
                                    sounds['explode']:play()
                                    player2.graveyard = true
                                elseif player2.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
                                    Vultures[i].exploded = true
                                    sounds['explode']:play()
                                    Vultures[i].graveyard = true
                                    Vultures[i].dxAssigned = false
                                    Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                                    Eggs[i].graveyard = false
                                    Eggs[i].invulnerable = true
                                    pteroTimer = vultureCount * 20 - 20
                                    Vultures[i].firstFrameExploded = true
                                    Score = Score + Vultures[i].pointTier
                                end
                            end
                        elseif player2:enemyRightCollides(Vultures[i]) then
                            if player2.facingRight and Vultures[i].facingRight then
                                sounds['bleep']:play()
                                player2.x = Vultures[i].x - player2.width
                                player2.dx = (math.abs(player2.dx) * -1) / 2
                            elseif not player2.facingRight and not Vultures[i].facingRight then
                                player2.exploded = true
                                sounds['explode']:play()
                                player2.graveyard = true
                            elseif player2.facingRight and not Vultures[i].facingRight then
                                if player2.y == Vultures[i].y then
                                    sounds['collide']:play()
                                    player2.dx = player2.dx * -1
                                    Vultures[i].dx = Vultures[i].dx * -1
                                    Vultures[i].x = player2.x + player2.width
                                elseif player2.y < Vultures[i].y then --OSTRICH HAS HIGHER LANCE
                                    pteroTimer = vultureCount * 20 - 20
                                    Vultures[i].exploded = true
                                    sounds['explode']:play()
                                    Vultures[i].graveyard = true
                                    Vultures[i].dxAssigned = false
                                    Eggs[i] = Egg(Vultures[i].lastX + 4, Vultures[i].lastY + 2, Vultures[i].lastDX)
                                    Eggs[i].graveyard = false
                                    Eggs[i].invulnerable = true
                                    Vultures[i].firstFrameExploded = true
                                    Score = Score + Vultures[i].pointTier
                                elseif player2.y > Vultures[i].y then --VULTURE HAS HIGHER LANCE
                                    player2.exploded = true
                                    sounds['explode']:play()
                                    player2.graveyard = true
                                end
                            elseif not player2.facingRight and Vultures[i].facingRight then
                                sounds['collide']:play()
                                player2.dx = player2.dx * -1
                                player2.x = Vultures[i].x - player2.width
                            end
                        end
                    end
                end
            end
        end
        --]]

        ---[[JOCKEY AND TAXI SPAWN
        for i = 1, enemyObjects do
            if Eggs[i].hatched then
                timesEggHatched[i] = timesEggHatched[i] + 1
                Jockeys[i] = Jockey(Eggs[i].lastX, Eggs[i].lastY, i)
                Jockeys[i].graveyard = false
                if Jockeys[i].x <= VIRTUAL_WIDTH / 2 then --IF JOCKEY LEFT SIDE OF SCREEN
                    Taxis[i] = Taxi(VIRTUAL_WIDTH, Jockeys[i].y - 25, 16, 24, -1, i)
                else --JOCKEY IS ON RIGHT SIDE OF SCREEN
                    Taxis[i] = Taxi(-16, Jockeys[i].y - 25, 16, 24, 1, i)
                end

                Taxis[i].graveyard = false
                Eggs[i].graveyard = true
                Eggs[i].hatched = false
            end

            if Eggs[i].y > VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - Eggs[i].height then --EGGS EXPLODING IN LAVA
                Eggs[i].graveyard = true
                Eggs[i].collected = true
            end
        end

        if player1.y > VIRTUAL_HEIGHT - LAVAHEIGHT - player1.height - lavaRise then --PLAYER 1 EXPLODING IN LAVA
            if not player1.temporarySafety then
                player1.exploded = true
            end
        end
        ---[[
        --PLAYER 2 EXPLODING IN LAVA
        if twoPlayerMode then
            if player2.y > VIRTUAL_HEIGHT - 25 - 10 then
                if not player2.temporarySafety then
                    player2.exploded = true
                    sounds['explode']:play()
                end
            end
        end
        --]]

        --]]

        ---[[PLAYER TO OBJECT COLLISIONS
        for i = 1, enemyObjects do
            if player1:Collides(Eggs[i]) and not Eggs[i].invulnerable and not Eggs[i].collected then --PLAYER TO EGG COLLISIONS
                if math.abs(player1.dx) < .3 then --SLOW COLLISION
                    if player1.x + (player1.width / 2) < Eggs[i].x + 4.2 and player1.x + (player1.width / 2) > Eggs[i].x + 3.8 then
                        sounds['egg']:play()
                        eggsCaught = eggsCaught + 1
                        Eggs[i].graveyard = true
                        Eggs[i].collected = true
                        scoresTable[i].lastX = Eggs[i].lastX
                        scoresTable[i].lastY = Eggs[i].lastY
                        scoresTable[i].timer = 1.5
                        if scoresTable[i].bonus then
                            Score = Score + 500
                        end
                        if eggsCaught > 3 then
                            scoresTable[i].scoreAmount = 1000
                            Score = Score + scoresTable[i].scoreAmount
                        else
                            scoresTable[i].scoreAmount = eggsCaught * 250
                            Score = Score + scoresTable[i].scoreAmount
                        end
                    end
                elseif math.abs(player1.dx) >= .3 then --FAST COLLISION
                    if Eggs[i].midairBonus then
                        sounds['airEgg']:play()
                    else
                        sounds['egg']:play()
                    end
                    eggsCaught = eggsCaught + 1
                    Eggs[i].graveyard = true
                    Eggs[i].collected = true
                    scoresTable[i].lastX = Eggs[i].lastX
                    scoresTable[i].lastY = Eggs[i].lastY
                    scoresTable[i].timer = 1.5
                    if scoresTable[i].bonus then
                        Score = Score + 500
                    end
                    if eggsCaught > 3 then
                        scoresTable[i].scoreAmount = 1000
                        Score = Score + scoresTable[i].scoreAmount
                    else
                        scoresTable[i].scoreAmount = eggsCaught * 250
                        Score = Score + scoresTable[i].scoreAmount
                    end
                end
            elseif twoPlayerMode then
                if player2:Collides(Eggs[i]) and not Eggs[i].invulnerable and not Eggs[i].collected then --PLAYER 2 TO EGG COLLISIONS
                    if math.abs(player2.dx) < .3 then --SLOW COLLISION
                        if player2.x + (player2.width / 2) < Eggs[i].x + 4.2 and player2.x + (player2.width / 2) > Eggs[i].x + 3.8 then
                            sounds['egg']:play()
                            eggsCaught = eggsCaught + 1
                            Eggs[i].graveyard = true
                            Eggs[i].collected = true
                            scoresTable[i].lastX = Eggs[i].lastX
                            scoresTable[i].lastY = Eggs[i].lastY
                            scoresTable[i].timer = 1.5
                            if scoresTable[i].bonus then
                                Score2 = Score2 + 500
                            end
                            if eggsCaught > 3 then
                                scoresTable[i].scoreAmount = 1000
                                Score2 = Score2 + scoresTable[i].scoreAmount
                            else
                                scoresTable[i].scoreAmount = eggsCaught * 250
                                Score2 = Score2 + scoresTable[i].scoreAmount
                            end
                        end
                    elseif math.abs(player2.dx) >= .3 then --FAST COLLISION
                        if Eggs[i].midairBonus then
                            sounds['airEgg']:play()
                        else
                            sounds['egg']:play()
                        end
                        eggsCaught = eggsCaught + 1
                        Eggs[i].graveyard = true
                        Eggs[i].collected = true
                        scoresTable[i].lastX = Eggs[i].lastX
                        scoresTable[i].lastY = Eggs[i].lastY
                        scoresTable[i].timer = 1.5
                        if scoresTable[i].bonus then
                            Score2 = Score2 + 500
                        end
                        if eggsCaught > 3 then
                            scoresTable[i].scoreAmount = 1000
                            Score2 = Score2 + scoresTable[i].scoreAmount
                        else
                            scoresTable[i].scoreAmount = eggsCaught * 250
                            Score2 = Score2 + scoresTable[i].scoreAmount
                        end
                    end
                end
            end

            ---[[PLAYER TO JOCKEY COLLISION
            if not Jockeys[i].graveyard and player1:Collides(Jockeys[i]) then
                Jockeys[i].collected = true
                scoresTable[i].bonus = false
                scoresTable[i].scoreAmount = 250
                Score = Score + scoresTable[i].scoreAmount
                scoresTable[i].timer = 1.5
                scoresTable[i].lastX = Jockeys[i].lastX
                scoresTable[i].lastY = Jockeys[i].lastY
                Jockeys[i].graveyard = true
                Eggs[i].collected = true
                Taxis[i].graveyard = true
            end

            --PLAYER 2 TO JOCKEY COLLISION
            if twoPlayerMode then
                if not Jockeys[i].graveyard and player2:Collides(Jockeys[i]) then
                    Jockeys[i].collected = true
                    scoresTable[i].bonus = false
                    scoresTable[i].scoreAmount = 250
                    Score = Score + scoresTable[i].scoreAmount
                    scoresTable[i].timer = 1.5
                    scoresTable[i].lastX = Jockeys[i].lastX
                    scoresTable[i].lastY = Jockeys[i].lastY
                    Jockeys[i].graveyard = true
                    Eggs[i].collected = true
                    Taxis[i].graveyard = true
                end
            end
            --]]

            ---[[EGGS TO FLOOR COLLISION
            --EGGS ON GROUND COLLISION
            if Eggs[i]:groundCollide(groundPlatform) then
                Eggs[i].bouncedOffFloor = true
                Eggs[i].y = groundPlatform.y - Eggs[i].height
                Eggs[i].dy = math.max(-Eggs[i].dy + .25, -.9)
            end

            --EGGS AND PLATFORM COLLISION
            for m, platform in pairs(collidablePlatforms) do
                if Eggs[i]:groundCollide(platform) then
                    Eggs[i].bouncedOffFloor = true
                    Eggs[i].y = platform.y - Eggs[i].height
                    Eggs[i].dy = math.max(-Eggs[i].dy + .25, -.9)
                end
                if Eggs[i]:leftCollide(platform) then
                    Eggs[i].x = platform.x + platform.width
                    Eggs[i].dx = math.abs(Eggs[i].dx)
                end
                if Eggs[i]:rightCollide(platform) then
                    Eggs[i].x = platform.x - Eggs[i].width
                    Eggs[i].dx = -1 * Eggs[i].dx
                end
            end

            if Eggs[i]:rightCollide(groundPlatform) then
                Eggs[i].x = groundPlatform.x - Eggs[i].width
                Eggs[i].dx =  Eggs[i].dx * -1
            end

            if Eggs[i]:leftCollide(groundPlatform) then
                Eggs[i].x = groundPlatform.x + groundPlatform.width
                Eggs[i].dx = math.abs(Eggs[i].dx)
            end
        end

        for i = 1, enemyObjects do
            if Eggs[i].bouncedOffFloor and not Eggs[i].collected then
                Eggs[i].midairBonus = false
                scoresTable[i].bonus = false
            end
        end
        --]]

        for k, v in pairs(scoresTable) do
            scoresTable[k]:update(dt)
        end

        ---[[PTERODACTYL COLLISION

        --PTERODACTYL AND PLATFORM COLLISION
        for k, platform in pairs(collidablePlatforms) do
            if monster:leftCollides(platform) then
                monster.x = platform.x + platform.width
                monster.dx = monster.dx * -1
            elseif monster:rightCollides(platform) then
                monster.x = platform.x - monster.width
                monster.dx = monster.dx * -1
            elseif monster:topCollides(platform) then
                monster.y = platform.y + platform.height
                monster.dy = math.abs(monster.dy)
            elseif monster:bottomCollides(platform) then
                monster.y = platform.y - monster.height
                monster.dy = monster.dy * -1
            end
        end

        --PTERODACTYL AND VULTURE COLLISION
        for i, vulture in pairs(Vultures) do
            if monster:leftCollides(vulture) then
                vulture.dx = math.abs(vulture.dx) * -1
                monster.x = vulture.x + vulture.width
                monster.dx = math.abs(monster.dx)
            elseif monster:rightCollides(vulture) then
                vulture.dx = math.abs(vulture.dx)
                monster.x = vulture.x - monster.width
                monster.dx = math.abs(monster.dx) * -1
            elseif monster:topCollides(vulture) then
                vulture.dy = math.abs(vulture.dy) * -1
                monster.y = vulture.y + vulture.height
                monster.dy = math.abs(monster.dy)
            elseif monster:bottomCollides(vulture) then
                vulture.dy = math.abs(vulture.dy)
                monster.y = vulture.y - monster.height
                monster.dy = math.abs(monster.dy) * -1
            end
        end

        --LANCE TO PTERODACTYL COLLISION
        if not player1.temporarySafety and not monster.facingRight then
            if player1.facingRight then
                if monster:leftCollides(player1) then
                    if player1.y + 4 > monster.y + 1 and player1.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
                        monster.exploded = true
                        sounds['ptero']:play()
                        monster.graveyard = true
                    elseif monster:leftCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
                        player1.exploded = true
                        sounds['explode']:play()
                    end
                end
            end

        elseif not player1.temporarySafety and monster.facingRight then
            if not player1.facingRight then
                if monster:rightCollides(player1) then
                    if player1.y + 4 > monster.y + 1 and player1.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
                        monster.exploded = true
                        sounds['ptero']:play()
                        monster.graveyard = true
                    elseif monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
                        player1.exploded = true
                        sounds['explode']:play()
                    end
                end
            end
        end

        --PLAYER2 TO PTERO COLLISION
        if twoPlayerMode then
            if not player2.temporarySafety and not monster.facingRight then
                if player2.facingRight then
                    if monster:leftCollides(player2) then
                        if player2.y + 4 > monster.y + 1 and player2.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
                            monster.exploded = true
                            sounds['ptero']:play()
                            monster.graveyard = true
                        elseif monster:leftCollides(player2) or monster:topCollides(player2) or monster:bottomCollides(player2) then
                            player2.exploded = true
                            sounds['explode']:play()
                        end
                    end
                end

            elseif not player2.temporarySafety and monster.facingRight then
                if not player2.facingRight then
                    if monster:rightCollides(player2) then
                        if player2.y + 4 > monster.y + 1 and player2.y + 4 < monster.y + 8 and monster.frame == 3 then --KILLS PTERO
                            monster.exploded = true
                            sounds['explode']:play()
                            monster.graveyard = true
                        elseif monster:rightCollides(player2) or monster:topCollides(player2) or monster:bottomCollides(player2) then
                            player2.exploded = true
                            sounds['explode']:play()
                        end
                    end
                end
            end
        end


        if player1.facingRight and monster.facingRight then --KILLS PLAYER IF TOUCHES PTERO OUTSIDE OF WEAKSPOT
            if monster:leftCollides(player1) or monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
                player1.exploded = true
                sounds['explode']:play()
            end
        elseif not player1.facingRight and not monster.facingRight then
            if monster:leftCollides(player1) or monster:rightCollides(player1) or monster:topCollides(player1) or monster:bottomCollides(player1) then
                player1.exploded = true
                sounds['explode']:play()
            end
        end

        if twoPlayerMode then
            --PLAYER2 DEATH BY PTERO
            if player2.facingRight and monster.facingRight then --KILLS PLAYER IF TOUCHES PTERO OUTSIDE OF WEAKSPOT
                if monster:leftCollides(player2) or monster:rightCollides(player2) or monster:topCollides(player2) or monster:bottomCollides(player2) then
                    player2.exploded = true
                    sounds['explode']:play()
                end
            elseif not player2.facingRight and not monster.facingRight then
                if monster:leftCollides(player2) or monster:rightCollides(player2) or monster:topCollides(player2) or monster:bottomCollides(player2) then
                    player2.exploded = true
                    sounds['explode']:play()
                end
            end
        end

        --TAXI TO JOCKEY COLLISION --INSTANTIATES HIGHER TIER VULTURE
        ---[[
        for i = 1, enemyObjects do
            if Taxis[i]:collides(Jockeys[i]) then
                Taxis[i].graveyard = true
                Jockeys[i].graveyard = true
                if Taxis[i].facingRight then
                    Vultures[i] = Vulture(Taxis[i].lastX, Taxis[i].lastY, 16, 16, Taxis[i].lastY - 8, 1, Vultures[i].index, 0)
                    Vultures[i].graveyard = false
                    Vultures[i].dx = Vultures[i].spawningDX
                else
                    Vultures[i] = Vulture(Taxis[i].lastX, Taxis[i].lastY, 16, 16, Taxis[i].lastY - 8, -1, Vultures[i].index, 0)
                    Vultures[i].graveyard = false
                    Vultures[i].dx = Vultures[i].spawningDX
                end
                Vultures[i].graveyard = false
                Vultures[i].grounded = false
                Vultures[i].tier = timesEggHatched[i] + 1
                Eggs[i].midairBonus = true
                Eggs[i].bouncedOffFloor = false
                scoresTable[i].bonus = true
                pteroTimer = pteroTimer + 20
            end
        end
        --]]
        if player1.exploded then
            eggsCaught = 0
        end

        if twoPlayerMode then
            if player2.exploded then
                eggsCaught = 0
            end
        end

        ---[[OBJECT UPDATES
        for i = 1, enemyObjects do
            Eggs[i]:update(dt)
            Vultures[i]:update(dt)
            Jockeys[i]:update(dt)
            Taxis[i]:update(dt)
        end

        monster:update(dt)
        lavaBubble1:update(dt)
        lavaBubble2:update(dt)
        player1:update(dt)
        if twoPlayerMode then
            player2:update(dt)
        end

        ---[[VULTURE COUNT
        vultureCount = 0

        for i = 1, enemyObjects do
            if not Vultures[i].graveyard then
                vultureCount = vultureCount + 1
            end
        end

        if leftTrollCollide(player1) then
            leftFireCollided = true
            leftFireTimer = leftFireTimer + dt * 4
            if leftFireTimer > 3 then
                player1.x = 12
                player1.y = VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 26
                player1.dy = 0
                player1.dx = 0
                player1.grabbed = true
            end
        else
            leftFireCollided = false
            leftFireTimer = 0
        end
        if rightTrollCollide(player1) then
            rightFireCollided = true
            rightFireTimer = rightFireTimer + dt * 4
            if rightFireTimer > 3 then
                player1.x = VIRTUAL_WIDTH - 24
                player1.y = VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 26
                player1.dy = 0
                player1.dx = 0
                player1.grabbed = true
            end
        else
            rightFireCollided = false
            rightFireTimer = 0
        end

        if player1.grabbed then
            grabTimer = grabTimer + dt
            if grabTimer > 5 then
                grabTimer = 0
                player1.grabbed = false
                player1.y = player1.y - 10
                player1.dy = -.5
                player1.escapeJump = 0
            end
            if love.keyboard.wasPressed('x') then
                player1.escapeJump = player1.escapeJump + 1
            end
            if player1.escapeJump > 5 then
                player1.grabbed = false
                grabTimer = 0
                player1.y = player1.y - 10
                player1.dy = -.5
                player1.escapeJump = 0
            end
        end
    elseif love.keyboard.wasPressed('h') then
        helpToggle = not helpToggle
    end
end

function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	--draw ground top level **to be made retractable
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', groundPlatform.x, groundPlatform.y, groundPlatform.width, 4)

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise, VIRTUAL_WIDTH, LAVAHEIGHT + 100)

	--ground bottom stand-in
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)
	love.graphics.draw(groundBottom, 38, VIRTUAL_HEIGHT - 36)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.setFont(smallFont)
	for k, v in pairs(scoresTable) do
		scoresTable[k]:render()
	end

	player1:render()
    if twoPlayerMode then
        player2:render()
    end

	monster:render()

	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(tostring(lives), 123, VIRTUAL_HEIGHT - 28)

---[[RENDER OBJECT TABLES
	for i = 1, enemyObjects do
		if not Vultures[i].graveyard or Vultures[i].explosionTimer ~= 0 then
			Vultures[i]:render()
		end

		if not Eggs[i].graveyard and not Eggs[i].collected then
			Eggs[i]:render()
		end

		if not Jockeys[i].graveyard then
			Jockeys[i]:render()
		end

		if not Taxis[i].graveyard then
			Taxis[i]:render()
		end
	end
	--]]

	lavaBubble1:render()
	lavaBubble2:render()

	for k, platform in pairs(collidablePlatforms) do
        if platform.retracting then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            if not platform2.retracted then --RENDERS PLATFORM SPAWN ONLY IF PLATFORM 2 HASNT BEEN RETRACTED YET
                love.graphics.draw(platformSpawn, platform2.x + 15, platform2.y)
            end
            ---[[
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(platformSpawn, platform3.x + 15, platform3.y)
            love.graphics.draw(platformSpawn, platform4L.x + platform4.width - 33, platform4L.y)
            love.graphics.draw(platformSpawn, VIRTUAL_WIDTH / 2 - 35, groundPlatform.y)
            --]]
            platform:render()
        else
            platform:render()
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(platformSpawn, platform3.x + 15, platform3.y)
            love.graphics.draw(platformSpawn, platform4L.x + platform4.width - 33, platform4L.y)
            love.graphics.draw(platformSpawn, VIRTUAL_WIDTH / 2 - 35, groundPlatform.y)
        end
	end

	--SCORE
	love.graphics.setFont(smallFont)
	love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
	love.graphics.print(string.format("%06d", Score), 53, VIRTUAL_HEIGHT - 28)
    if twoPlayerMode then
        love.graphics.print(string.format("%06d", Score2), 142, VIRTUAL_HEIGHT - 28)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.draw(lifeCount, VIRTUAL_WIDTH - 68, VIRTUAL_HEIGHT - 29)
        love.graphics.setColor(254/255, 224/255, 50/255, 255/255)
        love.graphics.print(tostring(player2Lives), VIRTUAL_WIDTH - 58, VIRTUAL_HEIGHT - 28)
    end

	if gameOver then
		love.graphics.setColor(255/255, 30/255, 30/255, 100/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 + 55, VIRTUAL_WIDTH, 'center', 0, 1, 1, -1, -1)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 + 55, VIRTUAL_WIDTH, 'center')
	end

    love.graphics.setFont(smallFont)

    if waveTimer > 0 then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('WAVE ' .. tostring(wave), 0, VIRTUAL_HEIGHT / 2 - 3, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(205/255, 205/255, 205/255, 255/255)
    end

    if eggWaveText then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('EGG WAVE', 0, VIRTUAL_HEIGHT / 2 + 7, VIRTUAL_WIDTH, "center")
    end

   if not floorRetracted then
       if fireSprite == 1 and groundPlatform.width < VIRTUAL_WIDTH + (player1.width * 2) then
           love.graphics.draw(fire1, groundPlatform.x - 4, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
           love.graphics.draw(fire1, groundPlatform.x + groundPlatform.width - 7 + 4, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
       elseif fireSprite == 2 and groundPlatform.width < VIRTUAL_WIDTH + (player1.width * 2) then
           love.graphics.draw(fire2, groundPlatform.x - 4, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
           love.graphics.draw(fire2, groundPlatform.x + groundPlatform.width - 7 + 4, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
       elseif fireSprite == 3 and groundPlatform.width < VIRTUAL_WIDTH + (player1.width * 2) then
           love.graphics.draw(fire3, groundPlatform.x - 4, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
           love.graphics.draw(fire3, groundPlatform.x + groundPlatform.width - 7 + 4,  VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
       end
    end

    if wave >= 3 and floorRetracted then
        if fireSprite == 1 then
            love.graphics.draw(fire1, 16, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
            love.graphics.draw(fire1, VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        elseif fireSprite == 2 then
            love.graphics.draw(fire2, 16, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
            love.graphics.draw(fire2, VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        elseif fireSprite == 3 then
            love.graphics.draw(fire3, 16, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
            love.graphics.draw(fire3, VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        end

        --TROLL HAND ANIMATION
        if leftFireCollided and player1.grabbed then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll4, 12, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        elseif leftFireCollided and leftFireTimer > 2 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll3, player1.x, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        elseif leftFireCollided and leftFireTimer > 1 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll2, player1.x, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        elseif leftFireCollided and leftFireTimer > 0 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll1, player1.x, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16)
        end

        if rightFireCollided and player1.grabbed then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll4, VIRTUAL_WIDTH - 7, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 0, -1, 1)
        elseif rightFireCollided and rightFireTimer > 2 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll3, player1.x + 12, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 0, -1, 1)
        elseif rightFireCollided and rightFireTimer > 1 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll2, player1.x + 12, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 0, -1, 1)
        elseif rightFireCollided and rightFireTimer > 0 then
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.draw(troll1, player1.x + 12, VIRTUAL_HEIGHT - LAVAHEIGHT - lavaRise - 16, 0, -1, 1)
        end
    end

	if helpToggle and not gameOver then
		love.graphics.setColor(200/255, 30/255, 30/255, 150/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setFont(smallFont)

        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('PLAYER 1 CONTROLS:', 11, PLAYER1CONTROLY + 1)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('PLAYER 1 CONTROLS:', 10, PLAYER1CONTROLY)

        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'I\' - FLAP YOUR WINGS', 11, PLAYER1CONTROLY + 11)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'I\' - FLAP YOUR WINGS', 10, PLAYER1CONTROLY + 10)

        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'O\' - MOVE LEFT', 11, PLAYER1CONTROLY + 21)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'O\' - MOVE LEFT', 10, PLAYER1CONTROLY + 20)
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'P\' - MOVE RIGHT', 11, PLAYER1CONTROLY + 31)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'P\' - MOVE RIGHT', 10, PLAYER1CONTROLY + 30)

---[[
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('PLAYER 2 CONTROLS:', 11, PLAYER2CONTROLY + 1)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('PLAYER 2 CONTROLS:', 10, PLAYER2CONTROLY)
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'Z\' - FLAP YOUR WINGS', 11, PLAYER2CONTROLY + 11)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'Z\' - FLAP YOUR WINGS', 10, PLAYER2CONTROLY + 10)
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'X\' - MOVE LEFT', 11, PLAYER2CONTROLY + 21)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'X\' - MOVE LEFT', 10, PLAYER2CONTROLY + 20)
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'C\' - MOVE RIGHT', 11, PLAYER2CONTROLY + 31)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'C\' - MOVE RIGHT', 10, PLAYER2CONTROLY + 30)
        --]]
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print('   \'H\' - TOGGLE HELP', 11, 156)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('   \'H\' - TOGGLE HELP', 10, 155)
        love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
        love.graphics.print(' \'ESC\' - EXIT GAME', 11, 166)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print(' \'ESC\' - EXIT GAME', 10, 165)
	end
--[[
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    for i, platform in pairs(collidablePlatforms) do
        love.graphics.print(tostring(platform.name), 0, i * 8)
    end
    --]]

    --[[
    for i, v in pairs(legalSpawns) do
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print(tostring(legalSpawns[i]), 5, i * 10)
    end
	SpawnZonePoints[1]:render()
	SpawnZonePoints[2]:render()
	SpawnZonePoints[3]:render()
	SpawnZonePoints[4]:render()
    --]]
end
