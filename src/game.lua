local Game = {}

function Game:load()
    map = require ("/src/map")
    --level = require ("/src/level")
    player = require ("/src/player")
    camera = require ("/libs/camera")
    level = require ("/src/level")

    cam = camera()
    gPlayer = player:New( 256,256 ,64)
    level1 = level.grid
    gMap = map:New(level1,41,25)

end

function Game:update(dt)
    cam:lookAt(gPlayer.x, gPlayer.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local mapWidth = gMap.width * gMap.cellsize
    local mapHeight = gMap.height * gMap.cellsize

    --Left and right boundaries
    if cam.x < w/2 then
        cam.x = w/2
    elseif cam.x > mapWidth - w/2 then
        cam.x = mapWidth - w/2
    end

    --Top and bottom boundaries
    if cam.y < h/2 then
        cam.y = h/2
    elseif cam.y > mapHeight - h/2 then
        cam.y = mapHeight - h/2
    end

end 

function Game:draw()
    cam:attach()
    gMap:Render()
    gPlayer:Render()
    cam:detach()
end

function Game:keypressed(key)
    if key == "escape" then
        love.event.quit() 
    end
    if key == "z" then
        gPlayer:Move(gMap, 0, -1)
    elseif key == "s" then
        gPlayer:Move(gMap, 0, 1)
    elseif key == "q" then
        gPlayer:Move(gMap, -1, 0)
    elseif key == "d" then
        gPlayer:Move(gMap, 1, 0)
    end
end
return Game