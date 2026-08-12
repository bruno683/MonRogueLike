-- chargement des modules
local World = require("/src/world")



local Game = {}


function Game:load()
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
    elseif key == "q" then
        World:MovePlayer(-1, 0)
    elseif key == "s" then
        World:MovePlayer(0, 1)
    elseif key == "z" then
        World:MovePlayer(0, -1) 
    end
end

return Game