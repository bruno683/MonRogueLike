local Intent = {}
Intent.__index = Intent

Intent.Move = function(actor, dx, dy)
    return {
        actor = actor,
        type = "move",
        dx = dx,
        dy = dy
    }


end

return Intent
