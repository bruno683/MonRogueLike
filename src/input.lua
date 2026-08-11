local Input = {}
Input.keys = {}   



function Input:keypressed(key)
    self.keys[key] = true
end

function Input:keyreleased(key)
    self.keys[key] = false      

end

function Input:isKeyPressed(key)
    return self.keys[key] or false
end 

function Input:update(dt)
   
end


return Input