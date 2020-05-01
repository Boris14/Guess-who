BUTTON_HEIGHT = 64

local
function newButton(text, fn)
	return{
		text = text,
		fn = fn,
		now = false,
		last = false
	}
end	

local font = nil
	

function createMenu()
	local buttons = {}
	font = love.graphics.newFont("assets/Summit Attack.ttf", 32)

	table.insert(buttons, newButton(
				"Create Game",
				 function()  
				  return "create" 
			end))
	table.insert(buttons, newButton(
				"Join Game",
				 function()
				  return "join" 
			end))
	table.insert(buttons, newButton(
				"Settings",
				 function()
				  return "settings" 
			end))
	table.insert(buttons, newButton(
				"Exit",
				 function()
				  love.event.quit(0)
			end))					
	window_width = love.graphics.getWidth()
	window_height = love.graphics.getHeight()
	button_width = window_width * 0.40
	margin = 16 --margin beetween each button	
	total_height = (BUTTON_HEIGHT + margin) * #buttons --total height of all buttons
	return buttons
end

function createFolderMenu()
	buttons = {}
	font = love.graphics.newFont("assets/Summit Attack.ttf", 32)
	local folders = loadFolders("Game/")
	for i, folder in  ipairs(folders) do
		table.insert(buttons, newButton(
				folder,
				 function()  
				  return folder
			end))
	end					
	window_width = love.graphics.getWidth()
	window_height = love.graphics.getHeight()
	button_width = window_width * 0.40
	margin = 16 --margin beetween each button	
	total_height = (BUTTON_HEIGHT + margin) * #buttons --total height of all buttons
	return buttons
end

function drawMenu(buttons)
	local command = nil
	--love.graphics.setBackgroundColor()
	cursor_y = 0 --the place of the next button

	for i, button in ipairs(buttons) do
		button.last = button.now

		local bx = (window_width * 0.5) - (button_width * 0.5)
		local by = (window_height * 0.5) - (total_height * 0.5) + cursor_y

		local color = {61/255, 61/255, 61/255} --button color

		local mx, my = love.mouse.getPosition()

		local hot = mx > bx and mx < bx + button_width and
					my > by and my < by + BUTTON_HEIGHT

		if hot then
			color = {122/255, 122/255, 122/255}	--if the button is being hovered over, make it brighter
		end
	
		button.now = love.mouse.isDown(1) 
		if button.now and not button.last and hot then
			command = button.fn()
			--print(command)
		else
			--command = nil
		end
		love.graphics.push()
		love.graphics.setColor(unpack(color))

		love.graphics.rectangle(
			"fill",
			bx,
			by,
			button_width,
			BUTTON_HEIGHT
		)

		love.graphics.setColor(1,1,1) --text color
		love.graphics.setFont(font)
		love.graphics.pop()
		local text_width = font:getWidth(button.text)
		local text_height = font:getHeight(button.text)

		love.graphics.print(
			button.text,
			(window_width * 0.5) - text_width * 0.5,
			by + text_height * 0.1
			)

		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
		love.graphics.setColor(1,1,1)
	end
	return command
end
