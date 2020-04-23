local enet = require "enet"
require "server"
require "board"
require "menu"
require "client"


newFaces = {}
loading = 1

function love.keypressed(k)
	if (isClient) then
		if (k == 'escape') then
			server:disconnect()
			host:flush()
			love.event.quit()	
		elseif (k == 'g') then
			sendGuess("yo mama")
		end
	else 
		if (k == 'escape') then
			love.event.quit()
		end
	end
end

function love.load()
	command = nil
	commandValue = nil
	createMenu()
	hasBoard = false
	openMenu = true
end

function love.update(dt)
	if(commandValue) then
		openMenu = false
		if(loading == 1) then
			loading = true
		end
		if(commandValue == "create" and not loading) then
			createGame()
			while true do
				newData = recieveImage()
				if(newData) then
					table.insert(newFaces, newData)
				else
					break
				end
			end
			loadBoard(newFaces)
			hasBoard = true
			isHost = true
			commandValue = nil
		elseif(commandValue == "join" and not loading) then
			joinGame()
			faces = loadFaces("Game/ClashRoyale/")
			loadBoard(faces)
			hasBoard = true 
			sendAllImages("Game/ClashRoyale/")
			local event = host:service(20)	
			server:send("control")	
			hasBoard = true
			isClient = true
			commandValue = nil	
		end
	end
	if(hasBoard) then
		updateBoard()	
	end
	if(isHost) then
		checkInput()
	end
end

function love.draw()
	if(openMenu) then
		command = drawMenu(command)
		if(command) then
			commandValue = command
			command = nil
		end
	end
	if(hasBoard) then
		drawBoard()
	end
	if(loading and loading ~=1) then
		love.graphics.clear()	
		love.graphics.print("Waiting for other players...", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
		loading = false
	end
end


