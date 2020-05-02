local enet = require "enet"


function joinGame(adress)
	local myAdress = math.random(1000, 9999)
	host = enet.host_create("localhost:" .. tostring(myAdress))
	server = host:connect("localhost:" .. adress)
	sendMessage(myAdress)
end


function sendImage(imageName)

	local imageData = love.image.newImageData(imageName)
	local pixels = imageData:getString()
	local imageWidth = imageData:getWidth()
	local imageHeight = imageData:getHeight()

	local event = host:service(30)
	server:send(tostring(imageWidth))
	local event = host:service(30)
	server:send(tostring(imageHeight)) 

	local pixelsLeft = pixels:len()
	local buff = ""
	for i = 0, #pixels, 8000 do
		local c = ""
		if(pixelsLeft <= 8000) then
			c = pixels:sub(i+1)
			pixelsLeft = 0
		else		
			c = pixels:sub(i+1,i + 8000)
			pixelsLeft = pixelsLeft - 8000
		end
		buff = buff .. c
		if(string.len(buff) >= 9000 or i == #pixels or pixelsLeft == 0) then			
			local event = host:service(2)		
			server:send(buff)
			buff = ""
			if(pixelsLeft == 0) then
				break
			end
		end
	end

	local event = host:service(20)	
	server:send("next")

end

--		function to send all the images from the Client/
--		directory using sendImage(imageName)
function sendAllImages(directory)
	for file in paths.files(directory) do
		isImage = false
		local c = file:sub(-4)
		if(c == ".png" or c == "jpeg" or c == ".jpg") then
			isImage = true
		end
		for i = 1, #directory do
			local a = directory:sub(i,i)
			if(a == '/') then
				limiter = i + 1
				break
			end
		end

		if(isImage) then
			local directoryName = directory:sub(limiter)
			sendImage(directoryName .. file, host, server)
		end
	end
	local event = host:service(20)	
	server:send("end")
end
--		end of sendAllImages()

function sendMessage(msg)
	local event = host:service(20)	
	server:send(msg)
end

function loadFaces(directory)
	faces = {}
	for file in paths.files(directory) do
		isImage = false
		local c = file:sub(-4)
		if(c == ".png" or c == "jpeg" or c == ".jpg") then
			isImage = true
		end
		for i = 1, #directory do
			local a = directory:sub(i,i)
			if(a == '/') then
				limiter = i + 1
				break
			end
		end
		if(isImage) then
			local directoryName = directory:sub(limiter)
			local newFace = love.graphics.newImage(directoryName .. file)
			table.insert(faces, newFace)
		end
	end
	return faces
end
