

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    game = require("/src/game")
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
