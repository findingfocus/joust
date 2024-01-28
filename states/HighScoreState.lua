HighScoreState = Class{__includes = BaseState}

function HighScoreState:init()
    loopCount = 0
    letters = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
    scoreInitials = {'X', 'X', 'X'}
    letter1Index = 1
    letter2Index = 1
    letter3Index = 1
    insertionIndex = 0
    counter = 0
    count = 0
    scoreNeedsInsertion = false
    flashing = false
    playerScoreInserted = false
    letter1InputChoice = false
    letter2InputChoice = false
    letter3InputChoice = false
    playerInitialsLocked = false
    letter1Locked = 'A'
    flashTimer = .5
    sounds['beep']:setVolume(0.3)
    sounds['select']:setVolume(0.3)
    highScoresExist = love.filesystem.getInfo('highScores.txt', file)
    if not highScoresExist then
        saveDefaultScoreBoard()
    else
        loadHighScore()
    end
    --
    --CHECK IF PLAYER BEATS 10th PLACE SCOREBOARD
    if Score > saveData[10].score and counter == 0 then
        playerInitialsLocked = false
        letter1InputChoice = true
        --counter = 1
    elseif Score < saveData[10].score then
        letter1InputChoice = false
        letter2InputChoice = false
        letter3InputChoice = false
        playerInitialsLocked = true
    end
end

function saveDefaultScoreBoard()
    saveData = {}
    table.insert(saveData, HighScores(1, {'J', 'D', 'H'}, 255))
    table.insert(saveData, HighScores(2, {'J', 'D', 'H'}, 254))
    table.insert(saveData, HighScores(3, {'J', 'D', 'H'}, 253))
    table.insert(saveData, HighScores(4, {'J', 'D', 'H'}, 252))
    table.insert(saveData, HighScores(5, {'J', 'D', 'H'}, 251))
    table.insert(saveData, HighScores(6, {'J', 'D', 'H'}, 249))
    table.insert(saveData, HighScores(7, {'J', 'D', 'H'}, 248))
    table.insert(saveData, HighScores(8, {'J', 'D', 'H'}, 247))
    table.insert(saveData, HighScores(9, {'J', 'D', 'H'}, 246))
    table.insert(saveData, HighScores(10, {'J', 'D', 'H'}, 245))
    table.insert(saveData, HighScores(11, {'J', 'D', 'H'}, 200)) --DUMMY VALUE TO OVERWRITE
    --saveData.score1 = Score --USER SCORE
    love.filesystem.write('highScores.txt', serialize(saveData))
end

function loadHighScore()
    saveData = love.filesystem.load('highScores.txt')()
    return saveData
end

function shiftTrailingScores(index)
    startingIndex = 10
    for i = startingIndex, index, -1 do
       saveData[i + 1].place = saveData[i].place + 1
       saveData[i + 1].name = saveData[i].name
       saveData[i + 1].score = saveData[i].score
       loopCount = loopCount + 1
    end
    newHighScoreLocked = true
end

function findInsertionIndex()
    for i = 1, 10 do
        if Score >= saveData[i].score then
            insertionIndex = i
            return
        end
    end
end

function insertPlayerScore()
    findInsertionIndex()
    if not playerScoreInserted then
            shiftTrailingScores(insertionIndex) 
            saveData[insertionIndex] = HighScores(insertionIndex, scoreInitials, Score)
            playerScoreInserted = true
            love.filesystem.write('highScores.txt', serialize(saveData))
    end
end

function HighScoreState:update(dt)
    if scoreNeedsInsertion then
            insertPlayerScore(insertionIndex)
            scoreNeedsInsertion = false
    end
    flashTimer = flashTimer - dt
    if flashTimer <= 0 then
        flashing = not flashing
        flashTimer = .5
    end

    if twoPlayerMode then
        letter1InputChoice = false
        letter2InputChoice = false
        letter3InputChoice = false
        playerInitialsLocked = true
    end

    if not playerInitialsLocked then
        if letter1InputChoice then
            if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('right') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter1Index = letter1Index + 1
                if letter1Index == 27 then
                    letter1Index = 1
                end
            end
            if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('left') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter1Index = letter1Index - 1
                if letter1Index == 0 then
                    letter1Index = 26
                end
            end
        elseif letter2InputChoice then
            if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('right') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter2Index = letter2Index + 1
                if letter2Index == 27 then
                    letter2Index = 1
                end
            end
            if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('left') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter2Index = letter2Index - 1
                if letter2Index == 0 then
                    letter2Index = 26
                end
            end
        elseif letter3InputChoice then
            if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('right') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter3Index = letter3Index + 1
                if letter3Index == 27 then
                    letter3Index = 1
                end
            end
            if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('left') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter3Index = letter3Index - 1
                if letter3Index == 0 then
                    letter3Index = 26
                end
            end
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not playerInitialsLocked then
            sounds['select']:play()
            if letter1InputChoice then
                scoreInitials[1] = letters[letter1Index]
                letter1InputChoice = false
                letter2InputChoice = true
            elseif letter2InputChoice then
                scoreInitials[2] = letters[letter2Index]
                letter2InputChoice = false
                letter3InputChoice = true
            elseif letter3InputChoice then
                scoreInitials[3] = letters[letter3Index]
                letter3InputChoice = false
                playerInitialsLocked = true
                initialInput = false
                scoreNeedsInsertion = true
            end
        end
    end
end

function HighScoreState:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    if playerInitialsLocked then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('HIGHSCORES', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('THANKS FOR PLAYING!', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('ENTER INITIALS', 0, 10, VIRTUAL_WIDTH, 'center')
    end
    --PRINT TOP TEN SCORES
    if playerInitialsLocked then
        love.graphics.printf(tostring(saveData[1].place ..  ' ' .. saveData[1].name[1] .. saveData[1].name[2] .. saveData[1].name[3]), 50, 30, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[1].score), -65, 30, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[2].place ..  ' ' .. saveData[2].name[1] .. saveData[2].name[2] .. saveData[2].name[3]), 50, 40, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[2].score), -65, 40, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[3].place ..  ' ' .. saveData[3].name[1] .. saveData[3].name[2] .. saveData[3].name[3]), 50, 50, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[3].score), -65, 50, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[4].place ..  ' ' .. saveData[4].name[1] .. saveData[4].name[2] .. saveData[4].name[3]), 50, 60, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[4].score), -65, 60, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[5].place ..  ' ' .. saveData[5].name[1] .. saveData[5].name[2] .. saveData[5].name[3]), 50, 70, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[5].score), -65, 70, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[6].place ..  ' ' .. saveData[6].name[1] .. saveData[6].name[2] .. saveData[6].name[3]), 50, 80, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[6].score), -65, 80, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[7].place ..  ' ' .. saveData[7].name[1] .. saveData[7].name[2] .. saveData[7].name[3]), 50, 90, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[7].score), -65, 90, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[8].place ..  ' ' .. saveData[8].name[1] .. saveData[8].name[2] .. saveData[8].name[3]), 50, 100, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[8].score), -65, 100, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[9].place ..  ' ' .. saveData[9].name[1] .. saveData[9].name[2] .. saveData[9].name[3]), 50, 110, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[9].score), -65, 110, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[10].place ..  ' ' .. saveData[10].name[1] .. saveData[10].name[2] .. saveData[10].name[3]), 42, 120, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('      ' .. tostring(saveData[10].score), -65, 120, VIRTUAL_WIDTH, 'right')
        --love.graphics.printf(tostring(saveData[11].place ..  ' ' .. saveData[11].name[1] .. saveData[11].name[2] .. saveData[11].name[3]), 42, 130, VIRTUAL_WIDTH, 'left')
        --love.graphics.printf('         ' .. tostring(saveData[11].score), -50, 130, VIRTUAL_WIDTH, 'right')
    end
---[[
    if not playerInitialsLocked then
        if letter1InputChoice then
            love.graphics.printf('A', 8, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('A', 16, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            if flashing then
                love.graphics.setColor(255/255, 255/255, 255/255, 0/255)
            else
                love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            end
            love.graphics.printf(tostring(letters[letter1Index]), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
        elseif letter2InputChoice then
            love.graphics.printf(tostring(scoreInitials[1]), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            love.graphics.printf(tostring('A'), 16, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            if flashing then
                love.graphics.setColor(255/255, 255/255, 255/255, 0/255)
            else
                love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            end
            love.graphics.printf(tostring(letters[letter2Index]), 8, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
       elseif letter3InputChoice then
            love.graphics.printf(tostring(scoreInitials[1]), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            love.graphics.printf(tostring(scoreInitials[2]), 8, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
            if flashing then
                love.graphics.setColor(255/255, 255/255, 255/255, 0/255)
            else
                love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            end
            love.graphics.printf(tostring(letters[letter3Index]), 16, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
        end
    end

    if twoPlayerMode then
        love.graphics.printf('PLAYER 1 SCORE: ' .. tostring(Score), 0, VIRTUAL_HEIGHT - 80, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('PLAYER 2 SCORE: ' .. tostring(Score2), 0, VIRTUAL_HEIGHT - 60, VIRTUAL_WIDTH, 'center')
    end

    --]]

    --[[
    if Score > saveData[1].score then
       love.graphics.print('SCORE IS GREATER THAN SAVEDATA 10', 0, 200)
    end
    --]]
--    love.graphics.print('playerInitialsLocked: ' .. tostring(playerInitialsLocked), 10, VIRTUAL_HEIGHT - 20)

    --[[
    if playerScoreInserted then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('PLAYER SCORE INSERTED', 0, VIRTUAL_HEIGHT - 35)
        love.graphics.print('saveData count: ' .. tostring(count), 0, VIRTUAL_HEIGHT - 45)
    end
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.print('HIGHSCORES.TXT: ' .. tostring(highScoresExist), 0, VIRTUAL_HEIGHT - 25)
    love.graphics.print('insertionIndex: ' .. tostring(insertionIndex), 0, VIRTUAL_HEIGHT - 55)
    love.graphics.print('loopCount: ' .. tostring(loopCount), 0, VIRTUAL_HEIGHT - 75)
    --]]
end
