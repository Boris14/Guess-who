local enet = require "enet"

local host = enet.host_create"localhost:5678"


newImages = {}

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function love.draw()
	for i = 1, #newImages do
		love.graphics.draw(newImages[i])
		--sleep(2)
	end
end


--		function to recieve an image sent by sendImage(imageName)
--		and returning it or returning nil if no image is sent 
function recieveImage()
	local pixels = ""
	local imageWidth = 0
	local imageHeight = 0
	local image = nil
	while true do
		local event = host:service(1)
		if event then
			if event.type == "receive" then
				if(imageWidth == 0) then
					imageWidth = tonumber(event.data)
				elseif(imageHeight == 0) then
					imageHeight = tonumber(event.data)
				elseif(event.data ~= "end") then
					pixels = pixels .. event.data
				else
					local newImageData = love.image.newImageData(imageWidth, imageHeight, "rgba8", pixels)
					image = love.graphics.newImage( newImageData )					
					break
				end
			elseif event.type == "connect" then
				print("Connect:", event.peer)
				host:broadcast("new client connected")
			else
				print("Got event", event.type, event.peer)
				if (event.type == "disconnect") then
					break
				end
			end
		end
	end
	return image 
end
--		end of recieveImage()

while true do
	newData = recieveImage()
	if(newData) then
		table.insert(newImages, newData)
	else
		break
	end
end


