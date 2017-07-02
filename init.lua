wifiSettings = require("wifiSettings")

autoWifi  = require("autoWifi")
autoWifi.setup(wifiSettings.ssid, wifiSettings.key, {ip=wifiSettings.ip, netmask=wifiSettings.netmask, gateway=wifiSettings.gateway})

updateServer = require("updateServer")
updateServer.start()

pwmServer = require("pwmServer")
pwmServer.start()
