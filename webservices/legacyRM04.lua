local pwmDimmer = require("pwmDimmer")
local sendHttpResponse = require("sendHttpResponse")

local pin = 7

-- Legacy support emulating HLK-RM04 module behaviour
local function legacyRM04(connection, request)
    local match = string.match(request, "gpio2=(??[0-9]?.?[0-9]*)")

    -- RM04 relay modules use inverted on/off states
    -- so if state is 1 we need to turn off, if state
    -- is 0 we need to turn on
    if match == nil then
        return false
    elseif match == "1" then
        pwmDimmer.fadeTo(pin, 0)
        sendHttpResponse(connection, "Ok")
    elseif match == "0" then
        pwmDimmer.fadeTo(pin, 1023)
        sendHttpResponse(connection, "Ok")
    elseif match == "?" or match == "%3" then
        local state
        if pwmDimmer.getDuty(pin) > 0 then
            state = 0
        else
            state = 1
        end
        sendHttpResponse(connection, "at+gpio2=? " .. state)
    end

    return true
end

return legacyRM04