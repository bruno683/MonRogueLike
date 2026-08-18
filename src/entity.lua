local Entity = {}


--constructor
function Entity:New(x, y, name, hp)
    local this = {  
        x = x,
        y = y,
        name = name,
        hp = hp,
        isDead = false,
        isPlayer = false,
        interactionType = "neutral"
    }
    self.__index = self
    setmetatable(this, self)
    return this
end

function Entity:Render(map)
    local pixelX = self.x * map.cellsize
    local pixelY = self.y * map.cellsize
    love.graphics.setColor(1, 0.5, 0.8)
    love.graphics.print(self.name, pixelX, pixelY, 0, 1, 1, 0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

function Entity:SetPosition(x, y)
    self.x = x
    self.y = y
end 

function Entity:GetPosition()
    return self.x, self.y
end 



return Entity   