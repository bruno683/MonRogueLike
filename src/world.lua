local Map = require("/src/map")
local Level = require("/src/level")
local Camera = require("/libs/camera")
local Entity = require("/src/entity")
local Ia = require("/src/ia")
local Intent = require("/src/intent_system")



local World = {}

local linePoints = {}


-- constructeur

function World:Load()
    local blue = {0,0,1}
    local red = {1,0,0}
    local green = {0,1,0}
    -- loading instances
    self.camera = Camera()
    self.entities = {}
    -- entities instanciations
    -- player
    self.player = Entity:New(20,14, "@", 50, blue)
    self.player.isPlayer = true
    self.player.faction  = "player"
    table.insert(self.entities, self.player)
    -- npc1
    self.npc1 = Entity:New(10, 14, "npc1", 25, red)
    self.npc1.faction = "bandits"
    table.insert(self.entities, self.npc1)
    --npc2
    self.npc2 = Entity:New(10, 22,"npc2", 50, green)
    self.npc2.faction = "neutral"
    table.insert(self.entities, self.npc2)
    -- map loading
    self.map = Map:New(Level.grid,41,25,32)
    -- initialisation du tour
    self.turn = 0

    self.relations = {
        player = {
            player = 100,
            bandits = -100,
            neutral = 0
        },
        neutral = {
            player = 0,
            bandits = 0,
            neutral = 100
        }, 
        bandits = {
            player = -100,
            bandits = 100,
            neutral = 0
        }
    }

    
        
end




-- méthodes publiques


function World:Update(dt)
    -- gestion de la caméra pour suivre le joueur
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
    for i =  #self.entities, 1, -1 do 
        local entity = self.entities[i]
        if entity.isDead  then 
            table.remove(self.entities, i)
        end
    end

    
end

function World:Draw()
    self.camera:attach()
    self.map:Render()
    for _, entity in ipairs(self.entities) do 
        entity:Render(self.map)
    end
    love.graphics.setColor(1,1,1)
    
    self.camera:detach()
    love.graphics.setColor(0,0,1)
    love.graphics.print("Tour: " .. self.turn, 10, 10)  
    love.graphics.setColor(1,1,1)
    --line of sight
end

function World:BresenhamPoints(x0, y0, x1, y1)
    local points = {}
    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)
    local sx = x0 < x1 and 1 or -1
    local sy = y0 < y1 and 1 or -1
    local err = dx - dy
    
    while true do
        table.insert(points, {x = x0, y = y0})
        if x0 == x1 and y0 == y1 then break end
        local e2 = 2 * err
        if e2 > -dy then
            err = err - dy
            x0 = x0 + sx
        end
        if e2 < dx then
            err = err + dx
            y0 = y0 + sy
        end
    end
    
    return points
end

function World:HasLineOfSight(actor, target) 
    local points = self:BresenhamPoints(actor.x, actor.y, target.x, target.y)
    for i = 2, #points -1 do 
        local p = points[i]
        if not self.map:IsTransparent(p.x, p.y) then 
            return false
        end
    end
    return true
end

function World:GetFactionRelation(actor, target) 
  
    local actorFaction = actor.faction
    local targetFaction = target.faction
    if self.relations[actorFaction] and self.relations[actorFaction][targetFaction] then 
        return self.relations[actorFaction][targetFaction]
    end
    return 0 -- si aucune correspondance n'éxiste

end

function World:GetEntityAt(x,y)
    for _, entity in ipairs(self.entities) do 
        if entity.x == x and entity.y == y then
            return entity
        end
    end

    return nil
end



function World:GetHostileTarget(actor) 
    for _, target in ipairs(self.entities) do 
        if target ~= actor and not target.isDead 
        and self:GetFactionRelation(actor, target) == -100 and self:HasLineOfSight(actor, target) then 
            return target
        end
    end
end

function World:Attack(actor, target) 

    local distance = Ia:GetEntityDistance(actor, target)

    if target.isDead then 
        return false
    end

    if distance ~= 1 then 
        return false
    end
    
    target.hp = target.hp - 5

    print(actor.name.." attaque "..target.name)
    print("hp restant de "..target.name.." : "..target.hp)

    if target.hp <= 0 then 
        target.isDead = true 
        print(target.name.." est mort!")
    end
    return true
   
end


function World:HandleEntityCollision(actor,target)
        if target and not target.isDead and self:GetFactionRelation(actor, target) == -100 then 
            return self:Attack(actor, target)
        end
        return false
end



function World:MoveEntity(entity, dx, dy)
    -- Déplace l'entité d'une case si la position cible est praticable.
    
        local nextX = entity.x + dx
        local nextY = entity.y + dy
        
        if self.map:IsWalkable(nextX, nextY) and not self:GetEntityAt(nextX, nextY) then  
            entity:SetPosition(nextX, nextY)
            return true     
        end
        local target = self:GetEntityAt(nextX, nextY)
        if target then
            return self:HandleEntityCollision(entity, target)
        end
            return false
end


function World:ResolveIntent(actor, intention)
    if intention.type == "move" then 
        return self:MoveEntity(actor, intention.dx, intention.dy)
    elseif intention.type == "attack" then
        return self:Attack(actor, intention.target)
    end
    return false
end

function World:AdvanceTurn()  
    self.turn = self.turn  + 1
    for _, actor in ipairs(self.entities) do 
        if not actor.isPlayer and not actor.isDead then 
            local target = self:GetHostileTarget(actor)
            
            if target  then 
                local distance = Ia:GetEntityDistance(actor, target)
                
                if distance == 1 then 
                    local intention = Ia:GetIntent(actor, target)
                    self:ResolveIntent(actor, intention)
                else
                    local intention = Ia:MoveToEntity(actor, target)
                    
                    if intention then 
                        self:ResolveIntent(actor, intention)              
                    else 
                        local randomIntent = Ia:GetRandomMove()
                        self:ResolveIntent(actor, randomIntent)
                    end
                end
            else
                local intent = Ia:GetRandomMove()
                self:ResolveIntent(actor, intent)
            end
           
        end
    end
    
end


return World