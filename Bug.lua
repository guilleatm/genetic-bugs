local Bone = require 'Bone'

local Bug = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bug:new(numBones)
	local b = {}

	b.numBones = numBones


	setmetatable(b, self)
	self.__index = self
	return b

end




function Bug:generate(dna)

	local bones = {}

	local base = Bone:new(20, 0) -- length, angle

	table.insert(bones, base)

	for i = 2, self.numBones do

			local bone = Bone:new(30, 0)
			bone:attachBone(bones[i - 1])
			table.insert( bones, bone )
	end

	self.bones = bones

end

function Bug:update()
	
	for i = 1, self.numBones do
		self.bones[i]:update()
	end

end

function Bug:draw()

	for i = 1, self.numBones do
		self.bones[i]:draw()
	end

end


return Bug