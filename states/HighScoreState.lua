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
    scoreLocked = false
    letter1Locked = 'A'
    flashTimer = .5
    sounds['beep']:setVolume(0.3)
    sounds['select']:setVolume(0.3)
end

function HighScoreState:update(dt)
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
       if not scoreLocked then
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
               scoreLocked = true
           end
        end
   end
end

function HighScoreState:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.setFont(smallFont)
    love.graphics.printf('HELLO HIGHSCORE STATE!', 0, 0, VIRTUAL_WIDTH, 'center')
    --love.graphics.printf('flashing: ' .. tostring(flashing), 0, 20, VIRTUAL_WIDTH, 'center')

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
    if scoreLocked then
        love.graphics.printf('CONGRATULATIONS, ' .. scoreInitials[1] .. scoreInitials[2] .. scoreInitials[3] .. '!!!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
end
