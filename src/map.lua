local Map = {}
local Tiles = require ("/src/tiles")
local tiles = {
    [1] = Tiles[1],
    [2] = Tiles[2],
    [3] = Tiles[3],
    [4] = Tiles[4],
}

-- constructeur

function Map:New(data, width,height, cellsize)
    assert(data ~= nil, "Map:New() nécessite un tableau de tiles")
    assert(width ~= nil and height ~= nil, "Map:New() nécessite width et height")
    assert(#data == width * height, "Map:New() le tableau de tiles doit avoir une taille égale à width * height")
    local this = {
        tiles = data,
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
            if tile == tiles[1].id then 
                love.graphics.rectangle("line",sx,sy, self.cellsize, self.cellsize)
            elseif tile == tiles[2].id then
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
            elseif tile == tiles[3].id  then
                love.graphics.setColor(0, 0.5, 0)
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
                love.graphics.setColor(1, 1, 1)
            elseif tile == tiles[4].id then
                love.graphics.setColor(0, 0, 0.8)
                love.graphics.rectangle("fill", sx, sy, self.cellsize, self.cellsize)
                love.graphics.setColor(1, 1, 1)
            end
        end
   end
end
 
function Map:GetTile(x,y)
    if x < 0 or y < 0 or x > self.width - 1 or y > self.height - 1 then
        return 0
    end

    return self.tiles[y * self.width + x + 1] 
end


function Map:SetTile(x,y, tile)
    if x < 0 or y < 0 or x > self.width - 1 or y > self.height - 1 then
        return 0
    end

    self.tiles[y * self.width + x + 1] = tile
    return 1
end


function Map:IsWalkable(x,y)
    local tile = self:GetTile(x,y)
    if tile == 0 then
        return true
    end
    return false
end

return Map