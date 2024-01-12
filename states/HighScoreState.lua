HighScoreState = Class{__includes = BaseState}

function HighScoreState:init()
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
    highScoresExist = love.filesystem.exists('highScores.txt')
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
    findInsertionIndex()
end

function saveDefaultScoreBoard()
    saveData = {}
    table.insert(saveData, HighScores(1, {'A', 'A', 'A'}, 255))
    table.insert(saveData, HighScores(2, {'B', 'B', 'B'}, 254))
    table.insert(saveData, HighScores(3, {'C', 'C', 'C'}, 253))
    table.insert(saveData, HighScores(4, {'D', 'D', 'D'}, 252))
    table.insert(saveData, HighScores(5, {'E', 'E', 'E'}, 251))
    table.insert(saveData, HighScores(6, {'F', 'F', 'F'}, 249))
    table.insert(saveData, HighScores(7, {'G', 'G', 'G'}, 248))
    table.insert(saveData, HighScores(8, {'H', 'H', 'H'}, 247))
    table.insert(saveData, HighScores(9, {'I', 'I', 'I'}, 246))
    table.insert(saveData, HighScores(10, {'J', 'J', 'J'}, 245))
    --table.insert(saveData, HighScores(11, {'X', 'X', 'X'}, 200)) --DUMMY VALUE TO OVERWRITE
    --saveData.score1 = Score --USER SCORE
    love.filesystem.write('highScores.txt', serialize(saveData))
end

function loadHighScore()
    saveData = love.filesystem.load('highScores.txt')()
    return saveData
end

function shiftTrailingScores(index)
    startingIndex = 10
    for i = 10, i < startingIndex, -1 do
       saveData[startingIndex + 1].place = saveData[startingIndex].place
       saveData[startingIndex + 1].name = saveData[startingIndex].name
       saveData[startingIndex + 1].score = saveData[startingIndex].score
       startingIndex = startingIndex - 1
       --saveData[i + 1].place = saveData[i].place
                --saveData[i + 1].name = saveData[i].name
                --saveData[i + 1].score = saveData[i].score
    end
--[[
    while  startingIndex > index do
       saveData[startingIndex + 1].place = saveData[startingIndex].place
       saveData[startingIndex + 1].name = saveData[startingIndex].name
       saveData[startingIndex + 1].score = saveData[startingIndex].score
       startingIndex = startingIndex - 1
       --saveData[i + 1].place = saveData[i].place
                --saveData[i + 1].name = saveData[i].name
                --saveData[i + 1].score = saveData[i].score
    end
  --]]
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
    if not playerScoreInserted then
        for i, k in pairs(saveData) do
            count = #saveData
            if Score >= saveData[i].score then
                --shiftTrailingScores(i) --FIX THIS FUNCTION NEXT
                table.insert(saveData, insertionIndex, HighScores(insertionIndex, scoreInitials, Score))
                playerScoreInserted = true
                --REMOVE SCORE 11
                table.remove(saveData, 11)

                love.filesystem.write('highScores.txt', serialize(saveData))
                break
            else
                break
            end
        end
    end
    --DELETE THE 11TH SCORE, DO WE NEED DUMMY HIGH SCORE OBJECT?
end

function HighScoreState:update(dt)
    if scoreNeedsInsertion then
            insertPlayerScore()
            --table.insert(saveData, insertionIndex, HighScores(insertionIndex, scoreInitials, Score))
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
            if love.keyboard.wasPressed('down') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter1Index = letter1Index + 1
                if letter1Index == 27 then
                    letter1Index = 1
                end
            end
            if love.keyboard.wasPressed('up') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter1Index = letter1Index - 1
                if letter1Index == 0 then
                    letter1Index = 26
                end
            end
        elseif letter2InputChoice then
            if love.keyboard.wasPressed('down') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter2Index = letter2Index + 1
                if letter2Index == 27 then
                    letter2Index = 1
                end
            end
            if love.keyboard.wasPressed('up') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter2Index = letter2Index - 1
                if letter2Index == 0 then
                    letter2Index = 26
                end
            end
        elseif letter3InputChoice then
            if love.keyboard.wasPressed('down') then
                sounds['beep']:play()
                flashing = false
                flashTimer = .5
                letter3Index = letter3Index + 1
                if letter3Index == 27 then
                    letter3Index = 1
                end
            end
            if love.keyboard.wasPressed('up') then
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

    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
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
    love.graphics.setFont(smallFont)
    love.graphics.printf('HELLO HIGHSCORE STATE!', 0, 0, VIRTUAL_WIDTH, 'center')
    --PRINT TOP TEN SCORES
    if playerInitialsLocked then
        love.graphics.printf(tostring(saveData[1].place ..  ' ' .. saveData[1].name[1] .. saveData[1].name[2] .. saveData[1].name[3]), 50, 30, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[1].score), -50, 30, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[2].place ..  ' ' .. saveData[2].name[1] .. saveData[2].name[2] .. saveData[2].name[3]), 50, 40, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[2].score), -50, 40, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[3].place ..  ' ' .. saveData[3].name[1] .. saveData[3].name[2] .. saveData[3].name[3]), 50, 50, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[3].score), -50, 50, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[4].place ..  ' ' .. saveData[4].name[1] .. saveData[4].name[2] .. saveData[4].name[3]), 50, 60, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[4].score), -50, 60, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[5].place ..  ' ' .. saveData[5].name[1] .. saveData[5].name[2] .. saveData[5].name[3]), 50, 70, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[5].score), -50, 70, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[6].place ..  ' ' .. saveData[6].name[1] .. saveData[6].name[2] .. saveData[6].name[3]), 50, 80, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[6].score), -50, 80, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[7].place ..  ' ' .. saveData[7].name[1] .. saveData[7].name[2] .. saveData[7].name[3]), 50, 90, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[7].score), -50, 90, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[8].place ..  ' ' .. saveData[8].name[1] .. saveData[8].name[2] .. saveData[8].name[3]), 50, 100, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[8].score), -50, 100, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[9].place ..  ' ' .. saveData[9].name[1] .. saveData[9].name[2] .. saveData[9].name[3]), 50, 110, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[9].score), -50, 110, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(saveData[10].place ..  ' ' .. saveData[10].name[1] .. saveData[10].name[2] .. saveData[10].name[3]), 42, 120, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('         ' .. tostring(saveData[10].score), -50, 120, VIRTUAL_WIDTH, 'right')
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
    --]]

    --[[
    if Score > saveData[1].score then
       love.graphics.print('SCORE IS GREATER THAN SAVEDATA 10', 0, 200)
    end
    --]]
--    love.graphics.print('playerInitialsLocked: ' .. tostring(playerInitialsLocked), 10, VIRTUAL_HEIGHT - 20)

    if playerScoreInserted then
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.print('PLAYER SCORE INSERTED', 0, VIRTUAL_HEIGHT - 35)
        love.graphics.print('saveData count: ' .. tostring(count), 0, VIRTUAL_HEIGHT - 45)
    end
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.print('HIGHSCORES.TXT: ' .. tostring(highScoresExist), 0, VIRTUAL_HEIGHT - 25)
    love.graphics.print('insertionIndex: ' .. tostring(insertionIndex), 0, VIRTUAL_HEIGHT - 55)
end
