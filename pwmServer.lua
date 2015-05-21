local pwmDimmer = require("pwmDimmer")

local pwmServer = {} 
local pin = 7 -- NodeMCU pin 7, ESP GPIO 13

local function onRequest (connection, request)
    for name, handler in pairs(pwmServer.requestHandlers) do
        handler(connection, request)
    end
end

local function sendHttpResponse(connection, data)
    connection:send("HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/html; charset=ISO-8859-4\r\nContent-Length: " .. data:len() .. "r\n\r\n" .. data)
end

function pwmServer.start ()
    srv=net.createServer(net.TCP, 30) 
    srv:listen(80,function(conn) 
        conn:on("receive", onRequest) 
    end)
    pwmDimmer.fadeTo(7, 1023)
end

-- Legacy support emulating HLK-RM04 module behaviour
local function legacyRM04Support (connection, request)
    local match = string.match(request, "gpio2=(??[0-9]?.?[0-9]*)")

    -- RM04 relay modules use inverted on/off states
    -- so if state is 1 we need to turn off, if state
    -- is 0 we need to turn on
    if match == nil then
        return
    elseif match == "1" then
        pwmDimmer.fadeTo(pin, 0)
        connection:send("ok")
    elseif match == "0" then
        pwmDimmer.fadeTo(pin, 1023)
        connection:send("ok")
    elseif match == "?" or match == "%3" then
        local state
        if pwmDimmer.currentDuties[pin] > 0 then
            state = 0
        else
            state = 1
        end
        sendHttpResponse(connection, "at+gpio2=? " .. state)
    end

    connection:close()
end

pwmServer.requestHandlers = {
    legacyRM04Support
}

return pwmServer
