local Ia = {}

local directions = {
        {dx =  1, dy = 0},
        {dx = -1, dy = 0},
        {dx =  0, dy = 1},
        {dx =  0, dy =-1}
    }

function Ia:GetEntityDistance(actor, target)
    return math.abs(actor.x - target.x) + math.abs(actor.y - target.y)
end

function Ia:GetIntent(actor, target)
    if target then
        local distance = self:GetEntityDistance(actor, target)
        if distance == 1 then

            return {
                type = "attack",
                target = target
            }
            
        end
        local intention = self:MoveToEntity(actor, target)

        if intention then 
            print(actor.name.." se lance à la poursuite de "..target.name)
            return intention
        end
    end

    if not target 
    and actor.lastknownTargetX 
    and actor.lastknownTargetY then

      
        if actor.x == actor.lastknownTargetX 
            and actor.y == actor.lastknownTargetY then
            
            actor.lastknownTargetX = nil
            actor.lastknownTargetY = nil
        else
            print(actor.name.." cherche ".." à "
            ..actor.lastknownTargetX.." et "..actor.lastknownTargetY )
            return self:MoveToLastKnownTargetPosition(actor)
        end


    end

    return self:GetRandomMove()
end

function Ia:MoveToLastKnownTargetPosition(actor)
    local dx = 0
    local dy = 0
        
    if actor.x > actor.lastknownTargetX then 
        dx = -1
    end
    if actor.x < actor.lastknownTargetX then 
        dx = 1
    end
    if dx == 0 then 
        if actor.y > actor.lastknownTargetY then 
            dy = -1
        elseif actor.y < actor.lastknownTargetY then 
            dy = 1
        end
    end
    return {
        type = "move",
            dx = dx,
            dy = dy
        }
end

function Ia:MoveToEntity(actor,target)
    if Ia:GetEntityDistance(actor,target) <= 5 then 
        local dx = 0
        local dy = 0
        
        if actor.x > target.x then 
            dx = -1
        end
        if actor.x < target.x then 
            dx = 1
        end
        if dx == 0 then 
            if actor.y > target.y then 
                dy = -1
            elseif actor.y < target.y then 
                dy = 1
            end
        end
        return {
            type = "move",
                dx = dx,
                dy = dy
            }
    end
    return nil
    
end
    
    

function Ia:GetRandomMove()

    local directions = directions[math.random(#directions)]

    return {
        type = "move",
        dx = directions.dx,
        dy = directions.dy
    }

end

return Ia