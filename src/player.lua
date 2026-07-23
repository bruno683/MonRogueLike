Player = {}


function Player:New(x, y, cellsize)
    local this = 
    {   
        cellsize = cellsize or 16,
        x = x ,
        y = y ,

    }
    self.__index = self
    setmetatable(this,self)

    return this
end

function Player:CheckCollision(map, x, y)
    local cellX = math.floor(x / self.cellsize)
    local cellY = math.floor(y / self.cellsize)

    return map:IsWalkable(cellX, cellY)
end


function Player:Move(map, dx, dy)
-- Déplace le joueur d'une case si la position cible est praticable.
-- dx et dy indiquent la direction du déplacement sur la grille.
    local nextX = self.x + dx * self.cellsize
    local nextY = self.y + dy * self.cellsize

    if self:CheckCollision(map, nextX, nextY) then
        self.x = nextX
        self.y = nextY
    end
end

function Player:Render()
    local sx = self.x 
    local sy = self.y 
    love.graphics.setColor(1, 0.5, 0.8)
    love.graphics.print("@", sx-1, sy-1, 0, 3.5, 3.5, 0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

return Player