math.randomseed( os.time() )
math.random(); math.random(); math.random()

require "torch"

function newBox(image, imageId)
	return{
		image = image,
		imageId = imageId,
		up = true,
		last = false, 
		now = false
	}
end	


background = love.graphics.newImage("assets/background.png")
love.window.setMode(0, 0)
monitor_width = love.graphics.getWidth()
monitor_height = love.graphics.getHeight()
love.window.setMode(monitor_width * 0.5, monitor_height * 0.8)


function loadImages(directory)
	local images = {}
	for file in paths.files(directory) do
		local c = file:sub(-4)
		if(c == ".png" or c == "jpeg" or c == ".jpg") then
			table.insert(images, file)
		elseif(file ~= ".." and file ~= ".") then
			do return false end
		end		
	end
	return images
end


function loadFolders(directory)
	local folders = {}
	local isFile = false
	for file in paths.files(directory) do
		isFile = false
		for i = 1, #file do
			local a = file:sub(i,i)
			if(a == '.') then
				isFile = true
			end
		end
		if(file == "assets") then
			isFile = true
		end	
		if not isFile then
			if loadImages(directory .. file) then
				table.insert(folders, file)
			end
		end
	end
	return folders
end

function updateBoard()
	cursor_y = gapHeight
	cursor_x = gapWidth
end


function loadBoard(faces)
	boxes = {}
	font = nil
	font = love.graphics.newFont("/assets/Summit Attack.ttf", 32)
	avarageWidth = 0
	avarageHeight = 0
	for	i = 1, table.getn(faces) do
		table.insert(boxes, newBox(faces[i], i))
		avarageWidth = avarageWidth + boxes[i].image:getWidth()
		avarageHeight = avarageHeight + boxes[i].image:getHeight()
	end
	avarageWidth = avarageWidth / table.getn(faces)
	avarageHeight = avarageHeight / table.getn(faces)
	avarageArea = avarageWidth * avarageHeight
	
	windowWidth = love.graphics.getWidth() * 0.85
	windowHeight = love.graphics.getHeight() * 0.85
	gapWidth = love.graphics.getWidth() * 0.02
	imageArea = windowWidth * 0.176 * windowHeight * 0.9 * 0.16
	scalingFactor = math.sqrt(imageArea / avarageArea)
	if (avarageWidth * scalingFactor > windowWidth * 0.176) then
		imageWidth = windowWidth * 0.176
	elseif(avarageWidth * scalingFactor < 80) then
		imageWidth = 80
	else
		imageWidth = avarageWidth * scalingFactor
	end
	imageHeight = imageArea / imageWidth
	gapHeight = love.graphics.getWidth() * 0.02
	myImage = boxes[math.random(#boxes)]
	myImageScalingX = imageWidth / myImage.image:getWidth()
	myImageScalingY = imageHeight / myImage.image:getHeight()
	flippedImage = love.graphics.newImage("/assets/images.png")
	return myImage.imageId
end

function drawBoard()
	 for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
	for i, box in ipairs(boxes) do
		box.last = box.now

		if (i-1)%5 == 0 and (i-1) > 0 then
			cursor_x = gapWidth
			cursor_y = cursor_y + gapHeight + imageHeight
		end	

		local mx, my = love.mouse.getPosition()
		local hot = mx > cursor_x and mx < cursor_x + imageWidth and
		my > cursor_y and my < cursor_y + imageHeight
 
		box.now = love.mouse.isDown(1)
		if box.now and not box.last and hot then
			if box.up then
				box.up = false
			else box.up = true
			end	
		end

		if hot then
			right_image = box.image
			print(box.image)
		else
			right_image = "none"
			print("none")
		end	

		if right_image ~= "none" then
			love.graphics.draw(right_image)
		end		

		if love.keyboard.isDown('g') and hot then
			sendMessage(box.imageId)
		end

		if box.up then
			imageScalingX = imageWidth / box.image:getWidth()
			imageScalingY = imageHeight / box.image:getHeight()
			love.graphics.draw(box.image , cursor_x, cursor_y, 0, imageScalingX, imageScalingY)
		else 
			imageScalingX = imageWidth / flippedImage:getWidth()
			imageScalingY = imageHeight / flippedImage:getHeight()
			love.graphics.draw(flippedImage, cursor_x, cursor_y, 0, imageScalingX, imageScalingY) --placeholder
		end
	
		cursor_x = cursor_x + gapWidth + imageWidth	
	end

	love.graphics.setFont(font)	
	love.graphics.print("You are:", love.graphics.getWidth()*0.7, love.graphics.getHeight() * 0.9)	
	
	cursor_y = cursor_y + gapHeight + imageHeight
	love.graphics.draw(myImage.image , love.graphics.getWidth()*0.7 + 100, love.graphics.getHeight() * 0.9 - 65, 0, myImageScalingX, myImageScalingY)
end


