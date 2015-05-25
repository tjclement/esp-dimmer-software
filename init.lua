autoWifi  = require("autoWifi")
autoWifi.setup("MyHomeSSID", "MyPassword", {ip="192.168.0.230", netmask="255.255.255.0", gateway="192.168.0.1"})

updateServer = require("updateServer")
updateServer.start()

pwmServer = require("pwmServer")
pwmServer.start()
