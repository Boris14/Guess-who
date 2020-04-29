local enet = require "enet"
require "server"
require "board"
require "menu"
require "client"

local newFaces = {}
local myFace = nil
local loading = 1

function love.keypressed(k)
	if (isClient) then
		if (k == 'escape') then
			server:disconnect()
			host:flush()
			love.event.quit()	
		end
	else 
		if (k == 'escape') then
			love.event.quit()
		end
	end
end

function love.load()
	gameEnd = nil
	command = nil
	commandValue = nil
	createMenu()
	hasBoard = false
	openMenu = true
	directory = "Game/ClashRoyale/"
	gotGuess = false
	guess = nil
end

function love.update(dt)
	if(gameEnd == 1) then
		sendMessage("i won")
	elseif(gameEnd == 0) then
		sendMessage("i lost")
	end
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
			myFace = loadBoard(newFaces)
			hasBoard = true
			isHost = true
			commandValue = nil
		elseif(commandValue == "join" and not loading) then
			joinGame()
			faces = loadFaces(directory)
			myFace = loadBoard(faces)
			hasBoard = true 
			sendAllImages(directory)
			local event = host:service(20)	
			server:send("control")	
			hasBoard = true
			isClient = true
			commandValue = nil	
		end
	end
	if(hasBoard and not gameEnd) then
		updateBoard()	
		if not gotGuess then
			guess = checkInput()
		end
		if guess and not gotGuess then
			gotGuess = true
			if(guess == "i lost") then
				gameEnd = 1
			elseif (guess == "i won") then
				gameEnd = 0
			elseif(tonumber(guess) == myFace) then
				gameEnd = 0
			else
				gameEnd = 1		
			end
		end
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
	if(hasBoard and not gameEnd) then
		drawBoard()
	end
	if(loading and loading ~=1) then
		love.graphics.clear()	
		love.graphics.print("Waiting for other players...", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
		loading = false
	end
	if(gameEnd == 1) then
		love.graphics.clear()	
		love.graphics.print("You Win!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
	elseif(gameEnd == 0) then
		love.graphics.clear()	
		love.graphics.print("You Lost!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
	end
end


