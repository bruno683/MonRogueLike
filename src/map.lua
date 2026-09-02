local Map = {}
local Tiles = require ("/src/tiles")

-- constructeur

function Map:New(data, width,height, cellsize)
    assert(data ~= nil, "Map:New() nécessite un tableau de Tiles")
    assert(width ~= nil and height ~= nil, "Map:New() nécessite width et height")
    assert(#data == width * height, "Map:New() le tableau de Tiles doit avoir une taille égale à width * height")
    local this = {
        Tiles = data,
        width = width,
        height = height,
        cellsize = cellsize or 64,
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

-- Méthodes Publiques

function Map:Render()
    

   for l= 0, self.height -1 do 
        for c = 0, self.width -1 do 
            local sx = c * self.cellsize
            local sy = l * self.cellsize
            local tile = self:GetTile(c, l)
            
            if tile == Tiles[1].id then 
                love.graphics.rectangle("line",sx,sy, self.cellsize, self.cellsize)          
            elseif tile == Tiles[2].id then
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
            elseif tile == Tiles[3].id  then
                love.graphics.setColor(Tiles[3].color)
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
                love.graphics.setColor(1, 1, 1)
            elseif tile == Tiles[4].id then
                love.graphics.setColor(Tiles[4].color)
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
                love.graphics.setColor(1, 1, 1)
            elseif tile == Tiles[5].id then 
                love.graphics.setColor(Tiles[5].color)
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
                love.graphics.setColor(1,1,1)
            end
        end
   end
end
 
function Map:GetTile(x,y)
    if x < 0 or y < 0 or x > self.width - 1 or y > self.height - 1 then
        return 0
    end

    return self.Tiles[y * self.width + x + 1] 
end


function Map:SetTile(x,y, tile)
    if x < 0 or y < 0 or x > self.width - 1 or y > self.height - 1 then
        return 0
    end

    self.Tiles[y * self.width + x + 1] = tile
    return 1
end

function Map:IsTransparent(x,y)
    return self:GetTile(x,y) == 0
end

function Map:IsWalkable(x,y)
    return self:GetTile(x,y) == 0
end

return Map