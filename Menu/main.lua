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

local buttons = {}
local font = nil

function love.load()
	font = love.graphics.newFont("assets/Summit Attack.ttf", 32)

	table.insert(buttons, newButton(
				"Create Game",
				 function()  --placeholder
				  print("Creating game") --placeholder
			end))
	table.insert(buttons, newButton(
				"Join Game",
				 function()
				  print("Joining game") --placeholder
			end))
	table.insert(buttons, newButton(
				"Settings",
				 function()
				  print("Opening Settings") --placeholder
			end))
	table.insert(buttons, newButton(
				"Exit",
				 function()
				  love.event.quit(0)
			end))							
end

function love.update(dt)
end

function love.draw()
	local window_width = love.graphics.getWidth()
	local window_height = love.graphics.getHeight()
	local button_width = window_width * 0.40
	local margin = 16 --margin beetween each button
	local total_height = (BUTTON_HEIGHT + margin) * #buttons --total height of all buttons
	local cursor_y = 0 --the place of the next button


	for i, button in ipairs(buttons) do
		button.last = button.now

		local bx = (window_width * 0.5) - (button_width * 0.5)
		local by = (window_height * 0.5) - (total_height * 0.5) + cursor_y

		local color = {61, 61, 61} --button color

		local mx, my = love.mouse.getPosition()

		local hot = mx > bx and mx < bx + button_width and
					my > by and my < by + BUTTON_HEIGHT

		if hot then
			color = {122, 122, 122}	--if the button is being hovered over, make it brighter
		end

		button.now = love.mouse.isDown("l") 
		if button.now and not button.last and hot then
			button.fn()
		end
						
		love.graphics.setColor(unpack(color))

		love.graphics.rectangle(
			"fill",
			bx,
			by,
			button_width,
			BUTTON_HEIGHT
		)

		love.graphics.setColor(255,255,255) --text color
		love.graphics.setFont(font)
		local text_width = font:getWidth(button.text)
		local text_height = font:getHeight(button.text)

		love.graphics.print(
			button.text,
			(window_width * 0.5) - text_width * 0.5,
			by + text_height * 0.1
			)

		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
	end	
end

