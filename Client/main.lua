local enet = require "enet"

local host = enet.host_create()
local server = host:connect("localhost:5678")

imageData = love.image.newImageData("fff.png")
pixels = imageData:getString()

print(string.len(pixels))
local buff = ""
for i = 1, #pixels do
    local c = pixels:sub(i,i)
	buff = buff .. c
	if(string.len(buff) > 9000 or i == #pixels) then
		local event = host:service(1)		
		server:send(buff)
		buff = ""
	end
end
local event = host:service(1)	
server:send("test")

server:disconnect()
host:flush()

print"done"

