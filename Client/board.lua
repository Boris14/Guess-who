math.randomseed( os.time() )
math.random(); math.random(); math.random()

require "torch"

function newBox(image)
	return{
		image = image,
		up = true,
		last = false, 
		now = false
	}
end	


success = love.window.setMode(1000, 900)

function loadImages(directory)
	local images = {}
	for file in paths.files(directory) do
		local c = file:sub(-4)
		if(c == ".png" or c == "jpeg" or c == ".jpg") then
			local directoryName = directory:sub(7)
			table.insert(images, directoryName .. file)
		end		
	end
	return images
end

--LeagueOfLegends/
--ClashRoyale/
--Landscapes/

function updateBoard()
	cursor_y = gapHeight
	cursor_x = gapWidth
end

function loadBoard(faces)
	boxes = {}
	font = nil
	font = love.graphics.newFont("/assets/Summit Attack.ttf", 32)
	--images = loadImages("Board/ClashRoyale/")
	avarageWidth = 0
	avarageHeight = 0
	for	i = 1, 25 do
		table.insert(boxes, newBox(faces[i]))
		avarageWidth = avarageWidth + boxes[i].image:getWidth()
		avarageHeight = avarageHeight + boxes[i].image:getHeight()
	end
	avarageWidth = avarageWidth / table.getn(faces)
	avarageHeight = avarageHeight / table.getn(faces)
	avarageArea = avarageWidth * avarageHeight
	
	--windowWidth = love.graphics.getWidth()
	windowWidth = 800
	--windowHeight = love.graphics.getHeight()
	windowHeight = 600
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
end

function drawBoard()
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

		if box.up then
				imageScalingX = imageWidth / box.image:getWidth()
				imageScalingY = imageHeight / box.image:getHeight()
				love.graphics.draw(box.image , cursor_x, cursor_y, 0, imageScalingX, imageScalingY)
		else 
			--love.graphics.rectangle("line", cursor_x, cursor_y, imageWidth, imageHeight) --placeholder
		end
	
		cursor_x = cursor_x + gapWidth + imageWidth	
	end

	love.graphics.setFont(font)	
	love.graphics.print("You are:", love.graphics.getWidth()*0.7, love.graphics.getHeight() * 0.9)	
	
	cursor_y = cursor_y + gapHeight + imageHeight	
	love.graphics.draw(myImage.image , love.graphics.getWidth()*0.7 + 100, love.graphics.getHeight() * 0.9 - 65, 0, myImageScalingX, myImageScalingY)
end
