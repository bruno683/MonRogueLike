local Game = require("/src/game")
local Input = require("/src/input")

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
    if Input:isKeyPressed("d") then
        love.graphics.print("D key is pressed", 60, 60)
    else
        love.graphics.print("D key is not pressed", 60, 60)
    end
end

function love.keypressed(key)
    game:keypressed(key)
    --Input:keypressed(key)
end

function love.keyreleased(key)
    Input:keyreleased(key)
        
end
