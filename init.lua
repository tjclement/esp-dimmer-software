autoWifi  = require("autoWifi")
pwmServer = require("pwmServer")
updateServer = require("updateServer")

autoWifi.setup("MyHomeSSID", "MyPassword", {ip="192.168.0.230", netmask="255.255.255.0", gateway="192.168.0.1"})
pwmServer.start()
updateServer.start()
