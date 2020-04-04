local enet = require "enet"
require "torch"

local host = enet.host_create()
local server = host:connect("localhost:5678")

--		funtion to send an image by its name by
--		breaking it down to pixels and sending
--		them as a string 
function sendImage(imageName)

	local imageData = love.image.newImageData(imageName)
	local pixels = imageData:getString()
	local imageWidth = imageData:getWidth()
	local imageHeight = imageData:getHeight()

	local event = host:service(1)
	server:send(tostring(imageWidth))
	local event = host:service(1)
	server:send(tostring(imageHeight)) 

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
	server:send("end")

end
--		end of sendImage(imageName)


--		function to send all the images from the Client/
--		directory using sendImage(imageName)
function sendAllImages()
	for file in paths.files("Client/") do
		is_image = false
		for i = #file,1,-1 do
			local a = file:sub(i,i)
			local b = file:sub(i-1,i-1)
			local c = file:sub(i-2,i-2)
			local d = file:sub(i-3,i-3)
			if(a == 'g' and b == 'n' and c == 'p' and d == '.') then
				is_image = true
				break
			else
				break
			end
		end

		if(is_image) then
			sendImage(file)
		end
	end

end
--		end of sendAllImages()

sendAllImages()

local event = host:service(1)	
server:send("it doesn't work without this send")

server:disconnect()
host:flush()

print"done"

