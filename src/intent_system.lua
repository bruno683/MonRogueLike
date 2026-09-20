local Intent = {}
--Intent.current = {}


Intent.directions = {
    move_up = {type = "move", dx= 0, dy = -1},
    move_left = {type = "move", dx= -1, dy = 0},
    move_down = {type = "move", dx= 0, dy = 1},
    move_right = {type = "move", dx= 1, dy = 0},
    
}

Intent.actions = {
    wait = {type = "wait"},
    pick_up = {type = "pickup"},
    open = {type = "open"}
}

Intent.pendingAction = nil

--Intent.attack = {type = "attack", target = nil}

function Intent:FromKey(key)
    print("TOUCHE :", key)
    print("PENDING AVANT :", self.pendingAction)
    if key == "o"  then 
        self.pendingAction = "open"
        print("OPEN ARME :", self.pendingAction)
        return nil
    end

    if key == "up" or key == "z" then
        if self.pendingAction == "open" then 
            local direction = self.directions.move_up
            local intention = {    
                        type = self.actions.open.type,
                        dx = direction.dx,
                        dy = direction.dy
                    }
            self.pendingAction = nil
            return intention
        end
        return self.directions.move_up
    elseif key == "left" or key == "q"then
        return self.directions.move_left
    elseif key == "down" or key == "s" then
        return self.directions.move_down
    elseif key == "right" or key == "d" then
        if self.pendingAction == "open" then 
            return self.directions.move_right
        end
        return self.directions.move_right
    elseif key == "space" then
        return self.actions.wait
    elseif key == "f" then 
        return self.actions.pick_up
    
    end
    return nil
end

return Intent 