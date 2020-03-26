local socket = require('socket')
udp = socket.udp()
udp:setsockname('*', 12345)
udp:settimeout(0)

local new_image = ""

function love.draw()
	if(new_image ~= "") then
		love.graphics.draw(new_image)
	end
end

function love.update()
	data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		local image = data
		new_image = love.graphics.newImage(data)
	end
end


