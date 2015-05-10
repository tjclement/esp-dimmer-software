function sendHttpResponse(connection, data)
    connection:send("HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/html; charset=ISO-8859-4\r\nContent-Length: " .. data:len() .. "r\n\r\n" .. data)
end

-- Legacy support emulating HLK-RM04 module behaviour
function legacyRM04Support (connection, request)
    local pin = 4
    local match = string.match(request, "gpio2=(??[0-9]?.?[0-9]*)")

    -- RM04 relay modules use inverted on/off states
    -- so if state is 1 we need to turn off, if state
    -- is 0 we need to turn on
    if match == nil then
        return
    elseif match == "1" then
        updatePwm(pin, 0)
        connection:send("ok")
    elseif match == "0" then
        updatePwm(pin, 1023)
        connection:send("ok")
    elseif match == "?" or match == "%3" then
        local state
        if currentDuties[pin] > 0 then
            state = 0
        else
            state = 1
        end
        sendHttpResponse(connection, "at+gpio2=? " .. state)
    end

    connection:close()
end
    
requestHandlers = {
    legacyRM04Support
}

function startPwmServer ()
    srv=net.createServer(net.TCP) 
    srv:listen(80,function(conn) 
        conn:on("receive", onRequest) 
    end)
end

function onRequest (connection, request)
    print("Got request: " .. request)
    for name, handler in pairs(requestHandlers) do
        handler(connection, request)
    end
end
