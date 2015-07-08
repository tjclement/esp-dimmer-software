local pwmDimmer = require("pwmDimmer")
local sendHttpResponse = require("sendHttpResponse")

local pin = 7

-- Legacy support emulating HLK-RM04 module behaviour
local function legacyRM04(connection, request)
    print(request)
    local match = string.match(request, "gpio2=(%d)")

    -- RM04 relay modules use inverted on/off states
    -- so if state is 1 we need to turn off, if state
    -- is 0 we need to turn on
    if match == "1" then
        print "Found match for 1"
        pwmDimmer.fadeTo(pin, 0)
        sendHttpResponse(connection, "Ok")
        return true
    elseif match == "0" then
        print "Found match for 0"
        pwmDimmer.fadeTo(pin, 1023)
        sendHttpResponse(connection, "Ok")
        return true
    end

    match = string.match(request, "gpio2=(...)%s")
    if match == "?" or match == "%3" then
        print "Found match for getDuty"
        local state
        if pwmDimmer.getDuty(pin) > 0 then
            state = 0
        else
            state = 1
        end
        sendHttpResponse(connection, "at+gpio2=? " .. state)
        return true
    end

    return false
end

return legacyRM04