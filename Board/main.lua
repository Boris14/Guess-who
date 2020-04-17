local
function newBox(image)
	return{
		image = image,
		up = true,
		last = false, 
		now = false
	}
end	

local boxes = {}
local font = nil

function love.load()
	font = love.graphics.newFont("/assets/Summit Attack.ttf", 32)
	for i = 0, 24 do
		table.insert(boxes, newBox("1.jpeg"))
	end
end

function love.update(dt)
end

function love.draw()
	local window_width = love.graphics.getWidth()
	local window_height = love.graphics.getHeight()
	local image_width = window_width*0.176
	local gap_width = window_width * 0.02
	local image_height = (window_height * 0.9) * 0.16
	local gap_height = window_width * 0.02	
	local cursor_y = gap_height
	local cursor_x = gap_width

	for i, box in ipairs(boxes) do
		box.last = box.now

		if (i-1)%5 == 0 and (i-1) > 0 then
			cursor_x = gap_width
			cursor_y = cursor_y + gap_height + image_height
		end	

		local mx, my = love.mouse.getPosition()
		local hot = mx > cursor_x and mx < cursor_x + image_width and
		my > cursor_y and my < cursor_y + image_height

		box.now = love.mouse.isDown("l") 
		if box.now and not box.last and hot then
			if box.up then
				box.up = false
			else box.up = true
			end	
		end


		if box.up then
			    local image = love.graphics.newImage(box.image)
				love.graphics.draw(image , cursor_x, cursor_y, 0, 0.6, 0.4)
		else 
			love.graphics.rectangle("line", cursor_x, cursor_y, image_width, image_height) --placeholder
		end

		cursor_x = cursor_x + gap_width + image_width	
	end
	love.graphics.setFont(font)	
	love.graphics.print("You are:", window_width*0.7, window_height * 0.9)	
	random = boxes[math.random(#boxes)]
	image = love.graphics.newImage(random.image)
	cursor_y = cursor_y + gap_height + image_height	
	love.graphics.draw(image , window_width*0.83, cursor_y, 0, 0.4, 0.3)	
end		

