local Bone = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bone:new(lenght, angle)

	angle = angle or 0

	local b = {}

	b.width = lenght
	b.height = 10

	b.ox = b.width * 0.5
	b.oy = b.height * 0.5

	b.body = love.physics.newBody( world, love.math.random() * 0, 100, 'dynamic' )
	b.body:setAngle(angle)
	b.shape = love.physics.newRectangleShape( 0, 0, b.width, b.height )
	b.fixture = love.physics.newFixture( b.body, b.shape )

	b.fixture:setRestitution(0.4)

	b.jointDistance = b.width * 0.45



	setmetatable(b, self)
	self.__index = self
	return b
end

function Bone:new2(dotA, dotB)

	local dx = dotB.x - dotA.x
	local dy = dotB.y - dotA.y

	local h = math.sqrt(dx^2 + dy^2)
	--local angle = math.atan(c2 / c1)
	


	local angle = dotA:angle(dotB)

	local x, y = dotA.x + dx / 2 , dotA.y + dy / 2 


	local b = {}

	b.width = h
	b.height = 10

	b.ox = b.width * 0.5
	b.oy = b.height * 0.5

	b.body = love.physics.newBody( world, x, y, 'dynamic' )
	b.body:setAngle(-angle)
	-- #T PRUEBA
	b.body:setMass(0.1)
	b.shape = love.physics.newRectangleShape( 0, 0, b.width, b.height )
	b.fixture = love.physics.newFixture( b.body, b.shape )

	b.fixture:setRestitution(0)
	b.fixture:setFriction(1)

	b.jointDistance = b.width * 0.5

	b.fixture:setFilterData( 1, 65535, -1 )

	b.jointed = false





	setmetatable(b, self)
	self.__index = self
	return b

end

function Bone:joint2(other, dot)

	local otherX, otherY = dot.x, dot.y

	local x, y = self.body:getPosition()

	local angle = self.body:getAngle()

	x = otherX + math.cos( angle ) * self.jointDistance
	y = otherY + math.sin( angle ) * self.jointDistance

	--self.body:setPosition(x, y)

	self.joint = love.physics.newRevoluteJoint(other.body, self.body, dot.x, dot.y, false)
end


function Bone:update()

	self:setJointPosition()
end

function Bone:draw(winner)

	local x, y = self.body:getPosition()
	local angle = self.body:getAngle()

	-- BONE
	love.graphics.setColor(0.3, 0.9, 0.8)
	if winner then
		love.graphics.setColor(1, 1, 0)
	end
	love.graphics.draw(pixel, x, y, angle, self.width, self.height, self.ox / self.width, self.oy / self.height, nil, nil)

	-- AABB
	love.graphics.setColor(0.2, 0.2, 0.8)
	local topLeftX, topLeftY, bottomRightX, bottomRightY = self.shape:computeAABB( x, y, self.body:getAngle(), 1 )
	love.graphics.polygon('line', topLeftX, topLeftY, bottomRightX, topLeftY, bottomRightX, bottomRightY, topLeftX, bottomRightY)

	-- CENTER
	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', x , y, 3, nil)

	-- JOINT A
	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', self.jointAx, self.jointAy, 3, nil)

	-- JOINT B
	love.graphics.setColor( 0, 0.5, 0 )
	love.graphics.circle('fill', self.jointBx, self.jointBy, 3, nil)


end

function Bone:getJointPosition(joint)

	if self.jointAx == nil then
		self:setJointPosition()
	end


	if joint == 2 then
		return self.jointBx, self.jointBy
	end

	return self.jointAx, self.jointAy
end


function Bone:setJointPosition()
	local angle = self.body:getAngle()
	local x, y = self.body:getPosition()


	self.jointAx = x - math.cos( angle ) * self.jointDistance
	self.jointAy = y - math.sin( angle ) * self.jointDistance

	self.jointBx = x + math.cos( angle ) * self.jointDistance
	self.jointBy = y + math.sin( angle ) * self.jointDistance


end

function Bone:attachBone(other)
	local otherX, otherY = other:getJointPosition(2)

	local x, y = self.body:getPosition()

	local angle = self.body:getAngle()

	x = otherX + math.cos( angle ) * self.jointDistance
	y = otherY + math.sin( angle ) * self.jointDistance

	self.body:setPosition(x, y)

	self.joint = love.physics.newRevoluteJoint(self.body, other.body, otherX, otherY, false)
end


return Bone