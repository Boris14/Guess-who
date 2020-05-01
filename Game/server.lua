local enet = require "enet"

function createGame()
	local adress = math.random(1000, 9999)
	host = enet.host_create("localhost:" .. tostring(adress))
	host:channel_limit(2)
	return adress
end

function linkToPlayer(adress)
	server = host:connect("localhost:" .. tostring(adress))
	sendMessage(host:get_socket_address())
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
				if(event.data == "end") then
					break
				elseif(imageWidth == 0) then
					imageWidth = tonumber(event.data)
				elseif(imageHeight == 0) then
					imageHeight = tonumber(event.data)
				elseif(event.data ~= "next") then
					pixels = pixels .. event.data
				else
					local newImageData = love.image.newImageData(imageWidth, imageHeight, "rgba8", pixels)
					image = love.graphics.newImage( newImageData )					
					break
				end
			elseif event.type == "connect" then
				--print("Connect:", event.peer)
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

function checkInput()
	local event = nil
	if(host) then
		event = host:service(1)
	end
	if event then
		if event.type == "receive" then
			if(event.data ~= "control") then
				do return event.data end
			end	
		end
	end
	return nil
end
