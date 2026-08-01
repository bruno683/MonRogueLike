local Player = require("/src/player")
local Map = require("/src/map")
local Level = require("/src/level")
local Camera = require("/libs/camera")




local World = {}

-- constructeur

function World:Load()
    -- chargement des instances
    self.camera = Camera()
    self.player = Player:New(4,4)
    
    self.map = Map:New(Level.grid,41,25,32)
end

-- méthodes publiques


function World:Update(dt)

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
    self.camera:detach()
end


function World:Keypressed(key)
    if key == "escape" then
        love.event.quit() 
    end
    if key == "z" then
        self.player:Move(self.map, 0, -1)
    elseif key == "s" then
        self.player:Move(self.map, 0, 1)
    elseif key == "q" then
        self.player:Move(self.map, -1, 0)
    elseif key == "d" then
        self.player:Move(self.map, 1, 0)
    end
end


function World:ProcessIntent(intent)
    if intent.type == "move" then
        intent.actor:Move(self.map, intent.dx, intent.dy)
    end
end



return World