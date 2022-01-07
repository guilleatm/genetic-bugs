local Dna = {}


function Dna:new(x, y)

	local d = {}


	
	setmetatable(d, self)
	self.__index = self
	return d
end



function Dna:random(numDots)

	local length = (6 + numDots - 1) * numDots

	local dna = ""

	for i = 1, length do
		dna = dna .. tostring(math.random(0, 9))
	end

	return dna
	

end


function Dna:crossover(dna, dnb)


	local length = #dna

	local cutBottom = math.random( 0, length )

	local cutTop = math.random( cutBottom, length )

	local part = string.sub( dna, cutBottom, cutTop )

	return string.sub(dnb, 0, cutBottom - 1 ) .. part .. string.sub(dnb, cutTop + 1, length )

end

function Dna:mutate(dna, rate)

	if math.random( 0, 100 ) > rate then return	dna end


	local cut = math.random(1, #dna )

	return string.sub(dna, 1, cut - 1 ) .. tostring(math.random( 0, 9 )) .. string.sub(dna, cut + 1, #dna )


end


return Dna