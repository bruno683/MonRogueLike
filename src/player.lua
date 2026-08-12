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

function Player:Render(map)
    local pixelX = self.x * map.cellsize
    local pixelY = self.y * map.cellsize
    love.graphics.setColor(1, 0.5, 0.8)
    love.graphics.print("@", pixelX, pixelY, 0, 1, 1, 0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

function Player:SetPosition(x,y)
    self.x = x
    self.y = y
end

return Player