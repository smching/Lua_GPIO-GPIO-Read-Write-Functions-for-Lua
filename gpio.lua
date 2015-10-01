#!/usr/bin/lua
-- GPIO read/write functions for Lua
-- By http://ediy.com.my


----- Global variables
INPUT = 1
OUTPUT = 0
HIGH = 1
LOW = 0
GPIO = {20, 19, 18, 22, 21}

----- Overwites existing file or creates a new file
function writeToFile (filename, data)
	local file=io.open(filename, 'w')
	file:write(data)
	file:close()	
end


----- Reads data from file & returns the string
function readFromFile (filename)
	local file=io.open(filename, 'r')
	local data = file:read(1)
	file:close()	
	return data
end


----- Check if a file exists, returns true if file exists
function file_exists(name)
	local fileHandle = io.open(name,"r")
	if fileHandle ~= nil then io.close(fileHandle) 
		return true 
	else 
		return false 
	end
end


----- Pauses the program for the amount of time (in seconds)
function delay(second)
	os.execute("sleep " .. tonumber(second))
end


----- Configures the specified pin to behave either as an input or an output
function pinMode(pin, mode)
	local gpio_path = '/sys/class/gpio/'
	local gpio_direction = gpio_path..'gpio'..pin..'/direction'
	local gpio_export = gpio_path..'export'

	if not file_exists(gpio_direction) then
		writeToFile(gpio_export,pin) --making GPIO available in Linux
	end

	if mode==INPUT then
  	  writeToFile(gpio_direction, 'in') --configure io as input
	else
	  writeToFile(gpio_direction, 'out') --configure io as output
	end
end


----- Write a HIGH or a LOW value to a pin
function digitalWrite(pin, value)
	writeToFile('/sys/class/gpio/gpio'..pin..'/value', value)
end


------ Reads the value from a specified pin, either HIGH or LOW.
function digitalRead(pin)
	value = readFromFile('/sys/class/gpio/gpio'..pin..'/value')
	return value
end
