local pwmDimmer = {}

pwmDimmer.targetDuties = {}
pwmDimmer.currentDuties = {}

function pwmDimmer.fadeTo (pin, newDuty)
    local currentDuty = pwmDimmer.currentDuties[pin] 

    if not pin or not newDuty then
        return
    end

    if currentDuty == nil then
        pwm.setup(pin, 200, 0)
        currentDuty = 0
        pwmDimmer.currentDuties[pin] = currentDuty
    end

    pwmDimmer.targetDuties[pin] = newDuty
    
    tmr.alarm(5, 1, 1, function()
        local step
        local target = pwmDimmer.targetDuties[pin]
        local currentDuty = pwmDimmer.currentDuties[pin]

        if target == currentDuty then
            tmr.stop(5)
            return
        end

        if target > currentDuty then step = 1 else step = -1 end

        pwmDimmer.currentDuties[pin] = pwmDimmer.currentDuties[pin] + step

        pwm.setduty(pin, pwmDimmer.currentDuties[pin])
    end)
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
