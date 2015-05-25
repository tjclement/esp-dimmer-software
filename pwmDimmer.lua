local pwmDimmer = {}

pwmDimmer.currentDuties = {}

function pwmDimmer.fadeTo (pin, newDuty)
    local step
    local currentDuty = pwmDimmer.currentDuties[pin] 

    if not pin or not newDuty then
        return
    end

    if currentDuty == nil then
        pwm.setup(pin, 1000, 0)
        currentDuty = 0
    end
    
    if newDuty > currentDuty then step = 1 else step = -1 end
    
    for i=currentDuty, newDuty, step do
        pwm.setduty(pin, i)
        tmr.delay(1000)
        tmr.wdclr() -- Prevent watchdog system restarts
    end

    pwmDimmer.currentDuties[pin] = newDuty
end

function pwmDimmer.setTo (pin, newDuty)
    if not pin or not newDuty then
        return
    end

    if pwmDimmer.currentDuties[pin] ~= nil then
        pwm.setup(pin, 1000, 1023)
    end

    pwm.setduty(pin, newDuty)

    pwmDimmer.currentDuties[pin] = newDuty
end

function pwmDimmer.getDuty (pin)
    if pwmDimmer.currentDuties[pin] ~= nil then
        return pwmDimmer.currentDuties[pin]
    else
        return 0
    end
end

return pwmDimmer
