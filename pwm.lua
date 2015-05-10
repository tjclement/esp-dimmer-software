pwmIsSetup = false
currentDuties = {1023,1023,1023,1023,1023,1023,1023,1023,
                 1023,1023,1023,1023,1023,1023,1023,1023}

function updatePwm (pin, newDuty)
    local step
    local currentDuty = currentDuties[pin] 

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

    currentDuties[pin] = newDuty
end
