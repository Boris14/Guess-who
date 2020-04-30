local enet = require "enet"
require "server"
require "board"
require "menu"
require "client"

local Faces = {}
local myFace = nil
local loading = false

function love.keypressed(k)
	if not (openGameMenu or openMenu) and playerJoined then
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
	openGameMenu = false	
	gameEnd = nil
	command = nil
	commandValue = nil
	buttons = createMenu()
	hasBoard = false
	openMenu = true
	directory = nil
	gotGuess = false
	guess = nil
	playerJoined = nil
	finished = false
end

function love.update(dt)
	if(gameEnd == 1) then
		sendMessage("i won")
	elseif(gameEnd == 0) then
		sendMessage("i lost")
	end
	if(commandValue and not finished) then
		openMenu = false
		if(commandValue == "create" or isHost) then	
			if not isHost then				
				isHost = true
				createGame()
			end
			if not openGameMenu then
				buttons = createGameMenu()
			end	
			openGameMenu = true
			if commandValue ~= "create" then
				openGameMenu = false
				directory = "Game/" .. commandValue .. "/"
			end
			if(directory and not playerJoined) then
				loading = true
				playerJoined = checkInput()
			end
			if(playerJoined) then
				linkToPlayer("localhost:6789")
				loading = false
				Faces = loadFaces(directory)
				myFace = loadBoard(Faces)
				hasBoard = true 
				sendAllImages(directory)
				finished = true
			end
		elseif(commandValue == "join" or isClient) then
			if not isClient then
				isClient = true
				joinGame()
				linkToPlayer("localhost:5678")
			end
			if not playerJoined then
				playerJoined = checkInput()
			else
				while true do
					newData = recieveImage()
					if(newData) then
						table.insert(Faces, newData)
					else
						break
					end
				end
				myFace = loadBoard(Faces)
				hasBoard = true
				finished = true
			end
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
	if(openMenu or openGameMenu) then
		command = drawMenu(buttons)
		--print(command)
		if(command) then
			commandValue = command
			command = nil
		end
	end
	if(hasBoard and not gameEnd) then
		drawBoard()
	end
	if(loading) then
		love.graphics.clear()	
		love.graphics.print("Waiting for other players...", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
	end
	if(gameEnd == 1) then
		love.graphics.clear()	
		love.graphics.print("You Win!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
	elseif(gameEnd == 0) then
		love.graphics.clear()	
		love.graphics.print("You Lose!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
	end
end


