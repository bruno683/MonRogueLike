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

    World:Keypressed(key)

end

return Game