HighScoreState = Class{__includes = BaseState}

function HighScoreState:init()
    letters = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
    scoreInitials = {'X', 'X', 'X'}
    letter1Index = 1
    letter2Index = 1
    letter3Index = 1
    flashing = false
    letter1InputChoice = true
    letter2InputChoice = false
    letter3InputChoice = false
    playerScoreLocked = false
    letter1Locked = 'A'
    flashTimer = .5
    sounds['beep']:setVolume(0.3)
    sounds['select']:setVolume(0.3)
end

function loadDummyScores()
    saveData = {}
    table.insert(saveData, HighScores(1, {'J', 'D', 'H'}, 9250))
    table.insert(saveData, HighScores(2, {'J', 'D', 'H'},8250))
    table.insert(saveData, HighScores(3, {'J', 'D', 'H'}, 7650))
    table.insert(saveData, HighScores(4, {'J', 'D', 'H'}, 7250))
    table.insert(saveData, HighScores(5, {'J', 'D', 'H'}, 6250))
    table.insert(saveData, HighScores(6, {'J', 'D', 'H'}, 5555))
    table.insert(saveData, HighScores(7, {'J', 'D', 'H'}, 4250))
    table.insert(saveData, HighScores(8, {'J', 'D', 'H'}, 3250))
    table.insert(saveData, HighScores(9, {'J', 'D', 'H'}, 2250))
    table.insert(saveData, HighScores(10, {'J', 'D', 'H'}, 1250))
    --saveData.score1 = Score --USER SCORE
    love.filesystem.write('highScores.txt', serialize(saveData))
end

function saveHighScore()
    saveData = {}
    table.insert(saveData, HighScores(1, {'J', 'D', 'H'}, 1250))
    table.insert(saveData, HighScores(2, {'J', 'D', 'H'}, 2250))
    table.insert(saveData, HighScores(3, {'J', 'D', 'H'}, 3250))
    table.insert(saveData, HighScores(4, {'J', 'D', 'H'}, 4250))
    table.insert(saveData, HighScores(5, {'J', 'D', 'H'}, 5555))
    table.insert(saveData, HighScores(6, {'J', 'D', 'H'}, 6250))
    table.insert(saveData, HighScores(7, {'J', 'D', 'H'}, 7250))
    table.insert(saveData, HighScores(8, {'J', 'D', 'H'}, 7250))
    table.insert(saveData, HighScores(9, {'J', 'D', 'H'}, 8250))
    table.insert(saveData, HighScores(10, {'J', 'D', 'H'}, 9250))
    --saveData.score1 = Score --USER SCORE
    love.filesystem.write('highScores.txt', serialize(saveData))
end

function loadHighScore()
    saveData = love.filesystem.load('highScores.txt')()
    return saveData
end

function HighScoreState:update(dt)
    saveHighScore()
    loadHighScore()
    saveData[2].score = Score
    flashTimer = flashTimer - dt
    if flashTimer <= 0 then
        flashing = not flashing
        flashTimer = .5
    end
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

    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not playerScoreLocked then
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
                playerScoreLocked = true
            end
        end
    end
end

function HighScoreState:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.setFont(smallFont)
    love.graphics.printf('HELLO HIGHSCORE STATE!', 0, 0, VIRTUAL_WIDTH, 'center')
    --love.graphics.printf('flashing: ' .. tostring(flashing), 0, 20, VIRTUAL_WIDTH, 'center')
    --PRINT TOP TEN SCORES
    if playerScoreLocked then
        love.graphics.printf(tostring(saveData[1].place ..  ' ' .. saveData[1].name[1] .. saveData[1].name[2] .. saveData[1].name[3] .. '         ' .. saveData[1].score), 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[2].place ..  ' ' .. scoreInitials[1] .. scoreInitials[2] .. scoreInitials[3] .. '         ' .. saveData[2].score), -3, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[3].place ..  ' ' .. saveData[3].name[1] .. saveData[3].name[2] .. saveData[3].name[3] .. '         ' .. saveData[3].score), 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[4].place ..  ' ' .. saveData[4].name[1] .. saveData[4].name[2] .. saveData[4].name[3] .. '         ' .. saveData[4].score), 0, 60, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[5].place ..  ' ' .. saveData[5].name[1] .. saveData[5].name[2] .. saveData[5].name[3] .. '         ' .. saveData[5].score), 0, 70, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[6].place ..  ' ' .. saveData[6].name[1] .. saveData[6].name[2] .. saveData[6].name[3] .. '         ' .. saveData[6].score), 0, 80, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[7].place ..  ' ' .. saveData[7].name[1] .. saveData[7].name[2] .. saveData[7].name[3] .. '         ' .. saveData[7].score), 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[8].place ..  ' ' .. saveData[8].name[1] .. saveData[8].name[2] .. saveData[8].name[3] .. '         ' .. saveData[8].score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[9].place ..  ' ' .. saveData[9].name[1] .. saveData[9].name[2] .. saveData[9].name[3] .. '         ' .. saveData[9].score), 0, 110, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(saveData[10].place ..  ' ' .. saveData[10].name[1] .. saveData[10].name[2] .. saveData[10].name[3] .. '         ' .. saveData[10].score), -5, 120, VIRTUAL_WIDTH, 'center')
    end

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
    if playerSCoreLocked then
        --love.graphics.printf('CONGRATULATIONS, ' .. scoreInitials[1] .. scoreInitials[2] .. scoreInitials[3] .. '!!!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
end
