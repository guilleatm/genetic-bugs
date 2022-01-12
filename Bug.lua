local Bone = require 'Bone'
local Dot = require 'Dot'

local TIMER = 0.1
local IMPULSE = 60

local MAX_ANGULAR_VEL = 10

local Bug = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bug:new(numDots)
	local b = {}

	b.numDots = numDots

	b.bones = {}

	b.dots = {}

	b.dnaPerBone = 6 + numDots - 1

	b.timer = 1



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

	self.dna = dna

	--self.dna = "10010024002001003500200200400010020000003000000000"
	--self.dna = "40327850982713495872190857290134859012875923485705"


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
			table.insert( boneJoints[dotIndx], bone )
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

		end

	end


	self.legs = {}

	for i, bone in ipairs(self.bones) do
		if #bone.body:getJoints() < 2 then
			-- #T PRUEBA
			bone.body:setMass(1)
			table.insert( self.legs, bone )
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

function Bug:update(dt)

	self.timer = self.timer - dt
	if self.timer <= 0 then
		self.timer = TIMER

		for i, leg in ipairs(self.legs) do
		local _impulse = IMPULSE * leg.width
			leg.body:applyAngularImpulse(_impulse)
		
		
			if leg.body:getAngularVelocity() > MAX_ANGULAR_VEL then
				leg.body:setAngularVelocity(MAX_ANGULAR_VEL)
			end
		end
		
	end


	
	for i, bone in ipairs(self.bones) do
		bone:update()
	end

end

function Bug:draw()

	for i, bone in ipairs(self.bones) do
		bone:draw(self.winner)
	end

	local punctuation = self:getPunctuation()


	local char = "|"
	love.graphics.setColor(1, 1, 1)
	if self.winner then
		love.graphics.setColor(1, 1, 0)
		char = "w"
	end
	love.graphics.print( char, punctuation, 50)


	-- for i, dot in ipairs(self.dots) do
	-- 	dot:draw()
	-- end

	-- for i, dot in ipairs(self.joints) do
	-- 	dot:drawJoint()
	-- end

	-- for i, center in ipairs(self.centers) do
	-- 	center:draw()
	-- end

end

-- FITNESS FUNCTION
function Bug:getPunctuation()

	-- MEAN

	local sum = 0
	for i, bone in ipairs(self.bones) do
	local mean = (bone.jointAx + bone.jointBx) / 2
		sum = sum + mean
	end

	return sum / #self.bones


	-- MIN

	-- local min = 100000
	-- for i, bone in ipairs(self.bones) do

	-- 	min = math.min( bone.jointAx, bone.jointBx, min)

	-- end

	-- return min


	-- MEAN DISTORSIONED

	-- local sum, count = 0, 0
	-- for i, bone in ipairs(self.bones) do
	-- 	sum = sum + bone.jointAx + bone.jointBx
	-- 	count = count + 1
	-- end

	-- return sum / count

	-- MEAN + POTENTIAL BONES

	-- local sum = 0
	-- for i, bone in ipairs(self.bones) do
	-- local mean = (bone.jointAx + bone.jointBx) / 2
	-- 	sum = sum + mean
	-- end

	-- return (7 * sum / #self.bones) * 0.2
end

return Bug