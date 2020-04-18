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

	local event = host:service(30)
	server:send(tostring(imageWidth))
	local event = host:service(30)
	server:send(tostring(imageHeight)) 

	local pixelsLeft = pixels:len()
	local buff = ""
	for i = 0, #pixels, 8000 do
		local c = ""
		if(pixelsLeft <= 8000) then
			c = pixels:sub(i+1)
			pixelsLeft = 0
		else		
			c = pixels:sub(i+1,i + 8000)
			pixelsLeft = pixelsLeft - 8000
		end
		buff = buff .. c
		if(string.len(buff) >= 9000 or i == #pixels or pixelsLeft == 0) then			
			local event = host:service(2)		
			server:send(buff)
			buff = ""
			if(pixelsLeft == 0) then
				break
			end
		end
	end

	local event = host:service(20)	
	server:send("end")

end
--		end of sendImage(imageName)


--		function to send all the images from the Client/
--		directory using sendImage(imageName)
function sendAllImages()
	for file in paths.files("Client/") do
		is_image = false
		local c = file:sub(-4)
		if(c == ".png" or c == "jpeg" or c == ".jpg") then
			isImage = true
		end

		if(isImage) then
			sendImage(file)
		end
	end

end
--		end of sendAllImages()

sendAllImages()

local event = host:service(20)	
server:send("it doesn't work without this send")

server:disconnect()
host:flush()

print"done"

