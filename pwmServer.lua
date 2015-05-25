local pwmDimmer = require("pwmDimmer")
local webServer = require("webServer")
local pwmService = require("pwmService")
local legacyRM04 = require("legacyRM04")

local pwmServer = {}
local pin = 7 -- NodeMCU pin 7, ESP GPIO 13


local function onRequest(connection, request)

    -- We call the handlers manually instead of neatly in a for loop,
    -- in order to save RAM. Creating tables is expensive.
    if pwmService(connection, request) then
        connection:close()
        return
    end
    if legacyRM04(connection, request) then
        connection:close()
        return
    end
    if webServer(connection, request) then
        connection:close()
        return
    end
    connection:close()
end

function pwmServer.start()
    local srv = net.createServer(net.TCP, 30)
    srv:listen(80, function(conn)
        conn:on("receive", onRequest)
    end)
    pwmDimmer.fadeTo(pin, 1023)
end

return pwmServer
