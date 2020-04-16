image = love.graphics.newImage("cat.png")
faces = 15


function love.draw()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.push()
	for i = 1, faces do
		love.graphics.draw(image, 40, 10, 0, 0.5)
		if(i % 5 == 0) then
			love.graphics.pop()
			love.graphics.translate(0, 150)
			if(i < 15) then
				love.graphics.push()
			end
		else
			love.graphics.translate(150, 0)		
		end
	end

end 
