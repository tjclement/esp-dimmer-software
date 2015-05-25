local pwmDimmer = require("pwmDimmer")
local sendHttpResponse = require("sendHttpResponse")

local pin = 7

-- Service to set or fade the pwm duty (brightness), and fetch its state.
local function pwmService(connection, request)
    print "entering pwm service"
    local match = request:match("setTo=(%d*)")
    if match then
        print ("found setTo match: " .. match)
        pwmDimmer.setTo(pin, tonumber(match))
        sendHttpResponse(connection, "Ok")
        return true
    end

    match = request:match("fadeTo=(%d*)")
    if match then
        print ("found fadeTo match: " .. match)
        pwmDimmer.fadeTo(pin, tonumber(match))
        sendHttpResponse(connection, "Ok")
        return true
    end

    match = request:match("getPwmDuty")
    if match then
        print "found getPwmDuty match"
        sendHttpResponse(connection, "" .. pwmDimmer.getDuty(pin))
        return true
    end

    return false
end

return pwmService