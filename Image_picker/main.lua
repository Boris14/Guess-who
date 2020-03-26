require 'torch'


for f in paths.files("Image_picker/") do
    is_image = false
	for i = #f,1,-1 do
    	local a = f:sub(i,i)
		local b = f:sub(i-1,i-1)
		local c = f:sub(i-2,i-2)
		local d = f:sub(i-3,i-3)
		if(a == 'g' and b == 'n' and c == 'p' and d == '.') then
			is_image = true
			break
		else
			break
		end
	end

	if(is_image) then
		print(f)
	end
end



