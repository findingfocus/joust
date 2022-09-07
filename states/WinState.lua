WinState = Class{__includes = BaseState}

function WinState:init() 

end

function WinState:update(dt)
	
end


function WinState:render()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.printf('Hello TripState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end
