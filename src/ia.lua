local Ia = {}

local directions = {
        {dx =  1, dy = 0},
        {dx = -1, dy = 0},
        {dx =  0, dy = 1},
        {dx =  0, dy =-1}
    }


    function Ia:GetRandomMove()
        return directions[math.random(#directions)]
    end

return Ia