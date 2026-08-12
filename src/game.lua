-- chargement des modules
local World = require("/src/world")
--local Input = require("/src/input")


local Game = {}
--local input

function Game:load()
 --   input = Input
    World:Load()
    
end

function Game:update(dt)

    World:Update(dt)

end 

function Game:draw()

    World:Draw()

end

function Game:keypressed(key)
    if key == "escape" then
        love.event.quit() 
    elseif key == "d" then
        World:MovePlayer(1, 0)
    end
   -- World:Keypressed(key)

end

return Game