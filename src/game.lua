-- chargement des modules
local Map = require ("/src/map")
local Player = require ("/src/player")
local Camera = require ("/libs/camera")
local Level = require ("/src/level")

local Game = {}


function Game:load()
    
    -- chargement des instances
    self.camera = Camera()
    self.player = Player:New(4,4)
    
    self.map = Map:New(Level.grid,41,25,32)
end

function Game:update(dt)
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

function Game:draw()
    self.camera:attach()
    self.map:Render()
    self.player:Render(self.map)
    self.camera:detach()
end

function Game:keypressed(key)
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
return Game