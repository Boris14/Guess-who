local enet = require "enet"
local utf8 = require("utf8")
require "server"
require "board"
require "menu"
require "client"

local Faces = {}
local myFace = nil
local loading = false
local gameCode = ""
local openCodeInput = false
local gameCodeError = false
local errorTimer = 1
local joinTimer = 3

function love.keypressed(k)
	if gameEnd then
		gameEnd = nil
		commandValue = nil
		finished = false
		openMenu = true
		buttons = createMenu()
		hasBoard = false
		isClient = nil
		isHost = nil
		playerJoined = nil
		joinedGame = false
		adress = nil
		guess = nil
		gotGuess = false
		directory = nil
		gameCode = ""
		Faces = {}
		myFace = nil
	else 
		if not (openFolderMenu or openMenu) and playerJoined and k == 'escape' then
			server:disconnect()
			host:flush()
			love.event.quit()	
		elseif (k == 'escape') then
			love.event.quit()
		elseif k == "backspace" and openCodeInput then
		    local byteoffset = utf8.offset(gameCode, -1)
	 
		    if byteoffset then
		        gameCode = string.sub(gameCode, 1, byteoffset - 1)
		    end
		elseif k == "return" and openCodeInput then
			if string.len(gameCode) ~= 4 or tonumber(gameCode) == nil then
				gameCodeError = true
			else
				openCodeInput = false 
			end   
		end
	end
end

function love.textinput(t)
	if openCodeInput then
    	gameCode = gameCode .. t
	end
end

function love.load()
	love.keyboard.setKeyRepeat(true)
	openFolderMenu = false	
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
	joinedGame = false
	finished = false
	adress = nil
	messageTime = 0
	waitTime = 0
	waitTimeExceeded = false
end

function love.update(dt)
	if gameCodeError or waitTimeExceeded then
		messageTime = messageTime + dt
		if(messageTime >= errorTimer) then
			gameCodeError = false
			waitTimeExceeded = false
			messageTime = 0
		end
	end
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
			end
			if not openFolderMenu and not directory then
				buttons = createFolderMenu()
				openFolderMenu = true			
			end	
			if commandValue ~= "create" then
				openFolderMenu = false
				directory = "Game/" .. commandValue .. "/"
				adress = createGame()
				commandValue = "create"
			end
			if(directory and not playerJoined) then
				loading = true
				playerJoined = checkInput()
			end
			if playerJoined and not loading then
				linkToPlayer(playerJoined)
				Faces = loadFaces(directory)
				myFace = loadBoard(Faces)
				hasBoard = true
				sendAllImages(directory)
				finished = true
			end
		elseif(commandValue == "join" or isClient) then
			if not isClient then
				isClient = true
				openCodeInput = true
			end
			if not openCodeInput and not joinedGame then
				joinGame(gameCode)
				joinedGame = true
			end
			if not playerJoined and not openCodeInput then
				waitTime = waitTime + dt
				playerJoined = checkInput()
				if waitTime >= joinTimer then
					waitTime = 0
					openCodeInput = true
					gameCode = ""
					waitTimeExceeded = true
					joinedGame = false
				end
			elseif playerJoined then
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
	if openCodeInput then
		love.graphics.clear()
		love.graphics.print("Write game code here:", 300, 200)
		if gameCode then
			love.graphics.printf(gameCode, 300, 300, love.graphics.getWidth())
		end
		if gameCodeError or waitTimeExceeded then
			love.graphics.printf("Not a valid game code.", 300, 400, love.graphics.getWidth())
		end
	end
	if(openMenu or openFolderMenu) then
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
		if playerJoined then
			love.graphics.printf("A player has joined!", 400, 500, love.graphics.getWidth())
			loading = false
		end
		love.graphics.print("The game code is:", love.graphics.getWidth()/3, love.graphics.getHeight()/3)
		love.graphics.printf(adress, 400, 400, love.graphics.getWidth())
	end
	if(gameEnd == 1) then
		love.graphics.clear()	
		love.graphics.print("You Win!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
		love.graphics.print("Press any button to continue...", love.graphics.getWidth() * 0.6, love.graphics.getHeight() * 0.9)
	elseif(gameEnd == 0) then
		love.graphics.clear()	
		love.graphics.print("You Lose!", love.graphics.getWidth()/3, love.graphics.getHeight()/2)
		love.graphics.print("Press any button to continue...", love.graphics.getWidth() * 0.6, love.graphics.getHeight() * 0.9)
	end
end


