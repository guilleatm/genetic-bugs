local Bone = require 'Bone'
local Dot = require 'Dot'

local Bug = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bug:new(numDots)
	local b = {}

	b.numDots = numDots

	b.bones = {}

	b.dots = {}

	b.dnaPerBone = 6 + numDots - 1



	setmetatable(b, self)
	self.__index = self
	return b

end


function Bug:getDotPosition(i)

	local index = (i - 1) * self.dnaPerBone

	local x = tonumber(string.sub( self.dna, index + 1, index + 3 ))
	local y = tonumber(string.sub( self.dna, index + 4, index + 6 ))


	return x, y

end

function Bug:getConnection(dot, i)
	local index = (dot - 1) * self.dnaPerBone

	return tonumber(string.sub( self.dna, index + 6 + i, index + 6 + i ))
end


function Bug:generate(dna)

	self.dna = "10010024002001003500200200400010020000003000000000"


	-- CREATE DOTS
	local dots = {}
	local dotJoints = {}
	local boneJoints = {}

	for i = 1, self.numDots do -- DNA

		local x, y = self:getDotPosition(i)
		local dot = Dot:new(x, y)
		dots[i] = dot

		dotJoints[i] = {}
		boneJoints[i] = {}
	end

	--JOIN DOTS
	for i, e in ipairs(dots) do

		--local numConnections = math.random(1, #dots / 2 )
		local numConnections = self.numDots - 1


		for j = 1, numConnections do
			--local conn = math.random(1, #dots)
			local conn = self:getConnection(i, j)


			if conn ~= i and conn ~= 0 and conn <= self.numDots then
				table.insert(dotJoints[i], conn)
				--table.insert( dotJo, [pos,] value )
			end
		end
	end

	-- CREATE BONES
	
	for baseDotInx, connections in ipairs(dotJoints) do

		for _, dotIndx in ipairs(connections) do

			local bone = Bone:new2(dots[baseDotInx], dots[dotIndx])
		
			table.insert( boneJoints[baseDotInx], bone )
			table.insert( self.bones, bone )
		end

	end

	-- JOIN BONES
	self.joints = {}
	for i, e in ipairs(boneJoints) do

		for b = 2, #e do
			e[1]:joint2(e[b], dots[i])
			table.insert( self.joints, dots[i] )

			e[1].jointed = true
			e[b].jointed = true

			print("joint: ", e[1], e[b])
		end

	end

	self.dots = dots

end

function Bug:generateOld(dna)

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
	
	for i, bone in ipairs(self.bones) do
		bone:update()
	end

end

function Bug:draw()

	for i, bone in ipairs(self.bones) do
		bone:draw()
	end

	for i, dot in ipairs(self.dots) do
		dot:draw()
	end

	for i, dot in ipairs(self.joints) do
		dot:drawJoint()
	end

end


return Bug