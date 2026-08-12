local Game = require("/src/game")


love.graphics.setDefaultFilter("nearest", "nearest")
local game
function love.load()
    game = Game 
    game:load()
end


function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end


