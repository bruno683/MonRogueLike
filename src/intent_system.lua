local Intent = {}
--Intent.current = {}


Intent.directions = {
    move_up = {type = "move", dx= 0, dy = -1},
    move_left = {type = "move", dx= -1, dy = 0},
    move_down = {type = "move", dx= 0, dy = 1},
    move_right = {type = "move", dx= 1, dy = 0},
    wait = {type = "wait"},
    pick_up = {type = "pickup"}
}

--Intent.attack = {type = "attack", target = nil}

function Intent:FromKey(key)
    if key == "up" or key == "z" then
        return self.directions.move_up
    elseif key == "left" or key == "q"then
        return self.directions.move_left
    elseif key == "down" or key == "s" then
        return self.directions.move_down
    elseif key == "right" or key == "d" then
        return self.directions.move_right
    elseif key == "space" then
        return self.directions.wait
    elseif key == "f" then 
        return self.directions.pick_up
    end
    return nil
end

return Intent 