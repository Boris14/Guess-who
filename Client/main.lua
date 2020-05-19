local enet = require "enet"
require "torch"
require "board"
require "client"



function love.keypressed(k)
	if k == 'escape' then
		server:disconnect()
		host:flush()
		love.event.quit()	
	elseif (k == 'g') then
		sendGuess("yo mama", host, server)
	end
end


function love.load()
	joinGame()
	hasBoard = false
	faces = loadFaces("Client/ClashRoyale/")
	loadBoard(faces)
	hasBoard = true
	sendAllImages("Client/ClashRoyale/")

	local event = host:service(20)	
	server:send("control")

end

function love.update()
	if(hasBoard) then
		updateBoard()
	end
end

function love.draw()
	if(hasBoard) then
		drawBoard()
	end
end


