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
    local acted = false
    if key == "escape" then
        love.event.quit() 
    elseif key == "d" then
        acted = World:MovePlayer(1, 0)
    elseif key == "q" then
        acted = World:MovePlayer(-1, 0)
    elseif key == "s" then
        acted = World:MovePlayer(0, 1)
    elseif key == "z" then
        World:MovePlayer(0, -1) 
    else acted = false
    end
    if acted then
        World:AdvanceTurn()
    end
end

return Game