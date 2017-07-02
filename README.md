# esp-dimmer-software
Custom software for a super tiny WiFi LED dimmer module based on the ESP8266

After flashing the initial firmware via serial connection, its possible to upload new scripts via wifi. 
Follow these instructions to change the WiFi AP:

1. Power Up!
   The device will create a local AP when it can't connect to the configured wifi.

2. Checkout git sources: 
```
$ git clone https://github.com/tjclement/esp-dimmer-software.git
```
3. Download upload script to esp-dimmer-software directory and make it executable!
```
$ wget https://github.com/tjclement/esp-common/raw/255d30d573bb580cbd031145aebf4949e363261f/sendfile.py
$ chmod +x sendfile.py
```
4. Connect to wifi called "ESP-xx:xx:xx:xx" with the default password "MyPassword". DHCP needs to be enabled!

6. Open wifiSettings.lua with a text editor and enter your wifi credentials and network configuration - Save!

7. Run sendfile.py to upload the file
```
$ ./sendfile.py 192.168.4.1 wifiSettings.lua
```
