HelpState = Class{__includes = BaseState}

function HelpState:init()

end

function HelpState:update(dt)
	if love.keyboard.wasPressed('h') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('r') then
		gStateMachine:change('titleState')
	end
end

function HelpState:render()
	love.graphics.printf('Arrow left and right to move', 0, VIRTUAL_HEIGHT - 650, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Enter to select', 0, VIRTUAL_HEIGHT - 550, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Spacebar to jump', 0, VIRTUAL_HEIGHT - 450, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('"R" to restart from title screen', 0, VIRTUAL_HEIGHT - 350, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('"H" to toggle help from title screen', 0, VIRTUAL_HEIGHT - 250, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Have fun to win ;)', 0, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')
end

