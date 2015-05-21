local pwmDimmer = {}

local pwmIsSetup = false
pwmDimmer.currentDuties = {0, 0, 0, 0, 0, 0, 0, 0,
                           0, 0, 0, 0, 0, 0, 0, 0}

function pwmDimmer.fadeTo (pin, newDuty)
    local step
    local currentDuty = pwmDimmer.currentDuties[pin] 

    if not pin or not newDuty then
        return
    end

    if not pwmIsSetup then
        pwm.setup(pin, 1000, 1023)
        pwmIsSetup = true
    end
    
    if newDuty > currentDuty then step = 1 else step = -1 end
    
    for i=currentDuty, newDuty, step do
        pwm.setduty(pin, i)
        tmr.delay(1000)
    end

    pwmDimmer.currentDuties[pin] = newDuty
end

function pwmDimmer.setTo (pin, newDuty)
    local step
    local currentDuty = pwmDimmer.currentDuties[pin] 
    
    if not pin or not newDuty then
        return
    end

    if not pwmIsSetup then
        pwm.setup(pin, 1000, 1023)
        pwmIsSetup = true
    end

    pwm.setduty(pin, newDuty)

    pwmDimmer.currentDuties[pin] = newDuty
end

return pwmDimmer
