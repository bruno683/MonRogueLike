local Player = {}

--constructeur

function Player:New(cellX, cellY)
    local this =
    {
        x = cellX,
        y = cellY,
    }
    self.__index = self
    setmetatable(this, self)

    return this

end

-- Méthodes publiques

function Player:Move(map, dx, dy)
    -- Déplace le joueur d'une case si la position cible est praticable.
    -- dx et dy indiquent la direction du déplacement sur la grille.
    local nextX = self.x + dx
    local nextY = self.y + dy

    if self:CheckCollision(map, nextX, nextY) then
        self.x = nextX
        self.y = nextY
    end
    
end

function Player:Render(map)
    local pixelX = self.x * map.cellsize
    local pixelY = self.y * map.cellsize
    love.graphics.setColor(1, 0.5, 0.8)
    love.graphics.print("@", pixelX, pixelY, 0, 1, 1, 0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

-- mééthodes privées

function Player:CheckCollision(map, x, y)
    return map:IsWalkable(x, y)
end


return Player