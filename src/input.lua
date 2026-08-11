local Input = {}
Input.keys = {}   
--Input.padButtons = {}
--Input.padAxes = {}


function Input:keypressed(key)
    self.keys[key] = true
end

function Input:keyreleased(key)
    self.keys[key] = false      

end
--[[
function Input:gamepadpressed(joystick, button)
    self.padButtons[button] = true
end


function Input:gamepadreleased(joystick, button)
    self.padButtons[button] = false
end

function Input:gamepadaxis(joystick, axis, value)
    self.padAxes[axis] = value
end
function Input:isPadButtonPressed(button)
    return self.padButtons[button] or false
end
function Input:getPadAxis(axis)
    return self.padAxes[axis] or 0
end ]]

function Input:isKeyPressed(key)
    return self.keys[key] or false
end 

function Input:reset()
    self.keys = {}
    --self.padButtons = {}
    --self.padAxes = {}
end 
function Input:update(dt)
   
end


return Input