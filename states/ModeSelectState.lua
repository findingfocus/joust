ModeSelectState = Class{__includes = BaseState}

function ModeSelectState:init()

end

function ModeSelectState:update(dt)

end

function ModeSelectState:render()
    love.graphics.setFont(smallFont)
    love.graphics.print('Hello ModeSelectState', 0, 0)
end

