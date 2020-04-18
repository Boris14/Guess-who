function newBox(image)
	return{
		image = love.graphics.newImage(image),
		up = true,
		last = false, 
		now = false
	}
end	

local boxes = {}
local font = nil
imageData1 = love.image.newImageData( "1.jpeg" )
imageData2 = love.image.newImageData( "1.jpeg" )
print(imageData1 == imageData2)

function love.load()
	font = love.graphics.newFont("/assets/Summit Attack.ttf", 32)
	for i = 0, 24 do
		if(love.math.random(1,2) == 1) then
			table.insert(boxes, newBox("1.jpeg"))
		elseif(love.math.random(1,2) == 1) then
			table.insert(boxes, newBox("2.jpg"))
		else
			table.insert(boxes, newBox("3.png"))
		end
	end
	window_width = love.graphics.getWidth()
	window_height = love.graphics.getHeight()
	image_width = window_width*0.176
	gap_width = window_width * 0.02
	image_height = (window_height * 0.9) * 0.16
	gap_height = window_width * 0.02
	myImage = boxes[math.random(#boxes)]
	myImageScalingX = image_width / myImage.image:getWidth()
	myImageScalingY = image_height / myImage.image:getHeight()
end

function love.update(dt)	
	cursor_y = gap_height
	cursor_x = gap_width
	

end

function love.draw()

	for i, box in ipairs(boxes) do
		box.last = box.now

		if (i-1)%5 == 0 and (i-1) > 0 then
			cursor_x = gap_width
			cursor_y = cursor_y + gap_height + image_height
		end	

		local mx, my = love.mouse.getPosition()
		local hot = mx > cursor_x and mx < cursor_x + image_width and
		my > cursor_y and my < cursor_y + image_height
 
		box.now = love.mouse.isDown(1)
		if box.now and not box.last and hot then
			if box.up then
				box.up = false
			else box.up = true
			end	
		end

		if box.up then
				imageScalingX = image_width / box.image:getWidth()
				imageScalingY = image_height / box.image:getHeight()
				love.graphics.draw(box.image , cursor_x, cursor_y, 0, imageScalingX, imageScalingY)
		else 
			love.graphics.rectangle("line", cursor_x, cursor_y, image_width, image_height) --placeholder
		end
	
		cursor_x = cursor_x + gap_width + image_width	
	end

	love.graphics.setFont(font)	
	love.graphics.print("You are:", window_width*0.7, window_height * 0.9)	
	
	cursor_y = cursor_y + gap_height + image_height	
	love.graphics.draw(myImage.image , window_width*0.83, cursor_y, 0, myImageScalingX, myImageScalingY)	
end		

