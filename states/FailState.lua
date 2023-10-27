FailState = Class{__includes = BaseState}

function FailState:init()

end

function FailState:update(dt)

end


function FailState:render()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.printf('GAMEOVER', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end
