
local socket = require "socket"
local address, port = "localhost", 12345
udp = socket.udp()
udp:setpeername(address, port)
udp:settimeout(0)

function love.draw()
	love.graphics.draw(image)
end

function love.update()
	udp:send("Firefox_wallpaper.png")
	image = love.graphics.newImage("Firefox_wallpaper.png")
	--data = udp:receive()
end

