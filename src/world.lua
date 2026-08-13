local Map = require("/src/map")
local Level = require("/src/level")
local Camera = require("/libs/camera")
local Entity = require("/src/entity")




local World = {}



-- constructeur

function World:Load()
    -- loading instances
    self.camera = Camera()
    self.entities = {}
    -- entities instanciations
    self.player = Entity:New(20,14, "@")
    table.insert(self.entities, self.player)
    self.npc1 = Entity:New(10, 14, "npc1")
    table.insert(self.entities, self.npc1)
    self.npc2 = Entity:New(10, 22,"npc2")
    table.insert(self.entities, self.npc2)
    -- map loading
    self.map = Map:New(Level.grid,41,25,32)
    -- initialisation du tour
    self.turn = 0
    print(#self.entities)
end

-- méthodes publiques


function World:Update(dt)
    -- gestion de la caméra pour suivre le joueur
    self.camera:lookAt(self.player.x * self.map.cellsize, self.player.y * self.map.cellsize)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local mapWidth = self.map.width * self.map.cellsize
    local mapHeight = self.map.height * self.map.cellsize

    --Left and right boundaries
    if self.camera.x < w/2 then
        self.camera.x = w/2
    elseif self.camera.x > mapWidth - w/2 then
        self.camera.x = mapWidth - w/2
    end

    --Top and bottom boundaries
    if self.camera.y < h/2 then
        self.camera.y = h/2
    elseif self.camera.y > mapHeight - h/2 then
        self.camera.y = mapHeight - h/2
    end

end

function World:Draw()
    self.camera:attach()
    self.map:Render()
    for _, entity in ipairs(self.entities) do 
        entity:Render(self.map)
    end
    --[[
    self.player:Render(self.map)
    self.npc1:Render(self.map)
    self.npc2:Render(self.map)
    ]]
    
    self.camera:detach()
    love.graphics.setColor(0,0,1)
    love.graphics.print("Tour: " .. self.turn, 10, 10)  
    love.graphics.setColor(1,1,1)
end

function World:GetEntityAt(x,y)
    for _, entity in ipairs(self.entities) do 
        if entity.x == x and entity.y == y then
            return entity
        end
    end

    return nil
end

function World:MoveEntity(entity, dx, dy)
    -- Déplace l'entité d'une case si la position cible est praticable.
    local nextX = entity.x + dx
    local nextY = entity.y + dy
    
    if self.map:IsWalkable(nextX, nextY) and not self:GetEntityAt(nextX, nextY) then  
        entity:SetPosition(nextX, nextY)
        return true  
    end
    
    return false
    

end

function World:AdvanceTurn()
    -- Ici, vous pouvez ajouter la logique pour faire avancer le tour du jeu.
    -- Par exemple, vous pourriez mettre à jour les ennemis, gérer les événements, etc.
    
    self.turn = self.turn  + 1
    -- les actions dans le monde sont jouées ici, par exemple les 
    -- déplacements des ennemis, les effets de statut, etc.
    self:MoveEntity(self.npc1, 1, 0)
    
end


return World