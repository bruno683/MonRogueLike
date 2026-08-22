local Map = require("/src/map")
local Level = require("/src/level")
local Camera = require("/libs/camera")
local Entity = require("/src/entity")
local Ia = require("/src/ia")



local World = {}


-- constructeur

function World:Load()
    -- loading instances
    self.camera = Camera()
    self.entities = {}
    -- entities instanciations
    -- player
    self.player = Entity:New(20,14, "@", 50)
    self.player.isPlayer = true
    self.player.faction  = "player"
    table.insert(self.entities, self.player)
    -- npc1
    self.npc1 = Entity:New(10, 14, "npc1", 25)
    self.npc1.faction = "bandits"
    table.insert(self.entities, self.npc1)
    --npc2
    self.npc2 = Entity:New(10, 22,"npc2", 50)
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
    
    self.camera:detach()
    love.graphics.setColor(0,0,1)
    love.graphics.print("Tour: " .. self.turn, 10, 10)  
    love.graphics.setColor(1,1,1)
end
--[[
function World:GetEntityDistance(actor, target) 
    return math.abs(actor.x - target .x) + math.abs(actor.y - target.y)
end
]]


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
        and self:GetFactionRelation(actor, target) == -100 then 
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


function World:AdvanceTurn()  

    self.turn = self.turn  + 1
    for _, actor in ipairs(self.entities) do 
        if not actor.isPlayer and not actor.isDead then 
            local target = self:GetHostileTarget(actor)
            
            if target  then 
                local distance = Ia:GetEntityDistance(actor, target)
                if distance == 1 then 
                    self:Attack(actor, target)
                else 
                    local move = Ia:MoveToEntity(actor, target)
                    if move then 
                        self:MoveEntity(actor, move.dx, move.dy)               
                    end
                end
            else 
                local move = Ia:GetRandomMove()
                self:MoveEntity(actor, move.dx, move.dy)
            end

        end
    end
    
end


return World