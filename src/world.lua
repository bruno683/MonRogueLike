--local Player = require("/src/player")
local Map = require("/src/map")
local Level = require("/src/level")
local Camera = require("/libs/camera")
local Entity = require("/src/entity")




local World = {}
--local playerHasMoved = false -- Variable pour suivre si le joueur a bougé
-- constructeur

function World:Load()
    -- chargement des instances
    self.camera = Camera()
    self.player = Entity:New(4,4, "@")
    self.npc1 = Entity:New(10, 14, "npc1")
    self.map = Map:New(Level.grid,41,25,32)
    -- initialisation du tour
    self.turn = 0
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
    self.player:Render(self.map)
    self.npc1:Render(self.map)
    self.camera:detach()
    love.graphics.setColor(0,0,1)
    love.graphics.print("Tour: " .. self.turn, 10, 10)  
    love.graphics.setColor(1,1,1)
end

function World:MoveEntity(entity, dx, dy)
    -- Déplace le joueur d'une case si la position cible est praticable.
    local entity = entity 
    local nextX = entity.x + dx
    local nextY = entity.y + dy
    
    if self.map:IsWalkable(nextX, nextY) then
        entity:SetPosition(nextX, nextY)
        return true  
    end
    return false
end

function World:AdvanceTurn()
    -- Ici, vous pouvez ajouter la logique pour faire avancer le tour du jeu.
    -- Par exemple, vous pourriez mettre à jour les ennemis, gérer les événements, etc.
    
        self.turn = self.turn  + 1
    -- les actions dans le monde sont jouées ici, par exemple les déplacements des ennemis, les effets de statut, etc.
    -- si le joueur a bougé, on peut déclencher les actions des ennemis
    -- on verifie que les cases sont valides pour le deplacement 
    local nextX = self.npc1.x + 1
    local nextY = self.npc1.y
    if self.map:IsWalkable(nextX, nextY) then
        World:MoveEntity(self.npc1, 1, 0)
    end
end


return World