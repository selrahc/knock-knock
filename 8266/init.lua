WIFI_SSID = ""
WIFI_PASSWORD = ""
WIFI_SIGNAL_MODE = wifi.PHYMODE_N

wifi.setmode(wifi.STATION)
wifi.setphymode(WIFI_SIGNAL_MODE)
wifi.sta.config(WIFI_SSID, WIFI_PASSWORD)
-- wifi.sta.autoconnect(1)
wifi.sta.connect()
-- tmr.delay(2000000) -- wait 1,000,000 us = 1 second
-- print(wifi.sta.status()) -- 5 means connection is completed
-- print(wifi.sta.getip())
-- print(wifi.getmode())
-- print(wifi.getphymode())
-- print(wifi.getchannel())
-- print(wifi.sta.getmac())

-- print ap list
function listap(t)
      for k,v in pairs(t) do
        print(k.." : "..v)
      end
end
wifi.sta.getap(listap)

i = 0
-- TIMER_MODE_AUTO = 1
tmr.alarm(1, 5000, 1, function()
    if (wifi.sta.status() ~= 5 and i < 10) then
       print("IP unavaiable, Waiting..."..i)
       i = i + 1
       -- wifi.sta.autoconnect(1)
    else
       if (wifi.sta.status() == 5) then
          tmr.stop(1)
          print("ESP8266 mode is: " .. wifi.getmode())
          print("The module MAC address is: " .. wifi.ap.getmac())
          print("Config done, IP is " .. wifi.sta.getip())

            -- select IO - GPIO0
            pin = 3
            gpio.mode(pin, gpio.OUTPUT)
            gpio.write(pin, gpio.HIGH)

            -- web server (API + GPIO control)
            sv = net.createServer(net.TCP, 30)
            sv:listen(8888, function(c)
                c:on("receive", function(conn, payload)
                    print(payload)
                    
                    if (string.find(payload, "POST /sesame/open") ~= nil) then
                        openSesame()
                    end        
            
                    conn:send("HTTP/1.1 200 OK\n\n")
                    conn:close()
                end)
            end)
       else
          print("Status: "..wifi.sta.status())
          i = 0
       end
    end
end)

function openSesame()
    gpio.mode(pin, gpio.INPUT)
    print(gpio.read(pin))
    
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)
    tmr.delay(1000000)
    gpio.write(pin, gpio.HIGH)
end
