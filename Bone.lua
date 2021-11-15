local Bone = {}

function Bone:new(lenght)
	local b = {}

	b.width = lenght
	b.height = 10

	b.ox = b.width / 2
	b.oy = b.height / 2

	b.body = love.physics.newBody( world, 100, 100, 'dynamic' )
	b.shape = love.physics.newRectangleShape( 0, 0, b.width, b.height )
	b.fixture = love.physics.newFixture( b.body, b.shape )

	setmetatable(b, self)
	self.__index = self
	return b
end


function Bone:draw()


	love.graphics.translate(self.body:getX(), self.body:getY())

	love.graphics.rotate(self.body:getAngle())

	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle('fill', -self.ox, -self.oy, self.width, self.height)

	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', 0, 0, 3, nil)

	love.graphics.translate(-self.body:getX(), -self.body:getY())
end

return Bone