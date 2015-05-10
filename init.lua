dofile("wifi.lua")
dofile("pwm.lua")
dofile("pwmServer.lua")

setupWifi("MyHomeSSID", "MyHomePassword")
startPwmServer()

print("works")
