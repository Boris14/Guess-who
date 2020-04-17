image = love.graphics.newImage("cat.png")
faces = 1
rowsDistance = faces / 5

function love.load()
	timer = 0
	timerLimit = 1
end

function love.update(dt)
	timer = timer + dt
	if(faces < 25) then
		if(timer >= timerLimit) then
			timer = timer - timerLimit
			faces = faces + 1
			if(faces % 5 == 1) then
				rowsDistance = (faces + 4) / 5
			end
		end	
	end

end

function love.draw()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.push()
	for i = 1, faces do
		love.graphics.draw(image, 40, 0, 0, 0.5)
		if(i % 5 == 0) then
			love.graphics.pop()
			if(i < faces) then
				love.graphics.translate(0, 400/rowsDistance)
			end
			love.graphics.push()
		else
			love.graphics.translate(150, 0)		
		end
	end
	love.graphics.origin()
	love.graphics.translate(280, 380)
	love.graphics.draw(image)
	love.graphics.pop()
end 
