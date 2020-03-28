local enet = require "enet"

local host = enet.host_create"localhost:5678"

pixels = ""
while true do
	local event = host:service(1)
	if event then 
		if event.type == "receive" then
			--print("Got message: ",  event.data, event.peer)
			--event.peer:send("howdy back at ya")
			pixels = pixels .. event.data
		elseif event.type == "connect" then
			print("Connect:", event.peer)
			host:broadcast("new client connected")
		else
			print("Got event", event.type, event.peer)
			if (event.type == "disconnect") then
				print(string.len(pixels))
				newImageData = love.image.newImageData(300, 300, "rgba8", pixels)
				image = love.graphics.newImage( newImageData )
				break
			end
		end

	end
end

function love.draw()
	if(image) then
		love.graphics.draw(image)
	end
end
