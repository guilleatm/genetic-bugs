local Bone = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bone:new(lenght)
	local b = {}

	b.width = lenght
	b.height = 10

	b.ox = b.width * 0.5
	b.oy = b.height * 0.5

	b.body = love.physics.newBody( world, 200, 200, 'dynamic' )
	b.shape = love.physics.newRectangleShape( 0, 0, b.width, b.height )
	b.fixture = love.physics.newFixture( b.body, b.shape )

	b.fixture:setRestitution(0)

	b.jointDistance = b.width * 0.45



	setmetatable(b, self)
	self.__index = self
	return b
end


function Bone:update()

	self:setJointPosition()
end

function Bone:draw()

	local x, y = self.body:getPosition()
	local angle = self.body:getAngle()

	-- BONE
	love.graphics.setColor(0.8, 0.8, 0.8)
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