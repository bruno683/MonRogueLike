local Entity = {}

--constructor
function Entity:New(x, y, name, hp, color)
    

    local this = {  
        x = x,
        y = y,
        name = name,
        hp = hp,
        isDead = false,
        isPlayer = false,
        faction = "neutral",
        color = color,
        lastknownTargetX = nil,
        lastknownTargetY = nil,
        inventory = {}
    }
    self.__index = self
    setmetatable(this, self)
    return this
end

function Entity:Render(map)
    local pixelX = self.x * map.cellsize
    local pixelY = self.y * map.cellsize
    love.graphics.setColor(self.color)
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