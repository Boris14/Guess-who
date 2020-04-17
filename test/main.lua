image = love.graphics.newImage("cat.png")
faces = 20


function love.draw()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.push()
	for i = 1, faces do
		love.graphics.draw(image, 40, 10, 0, 0.5)
		if(i % 5 == 0) then
			love.graphics.pop()
			if(i < faces) then
				love.graphics.translate(0, 100)
			else
				love.graphics.translate(0, 75)
			end
			love.graphics.push()
		else
			love.graphics.translate(150, 0)		
		end
	end
	love.graphics.translate(235, 0)
	love.graphics.draw(image, 40, 10)
	love.graphics.pop()
end 
