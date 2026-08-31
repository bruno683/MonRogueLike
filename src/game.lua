-- chargement des modules
local World = require("/src/world")
local Intent = require("src/intent_system")



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
        return
    end
    World:Keypressed(key)

    local intention = Intent:FromKey(key)

    if intention then 
        acted = World:ResolveIntent(World.player, intention)
    end
    
    if acted then
        World:AdvanceTurn()
    end
end

return Game