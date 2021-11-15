
local Bone = require 'Bone'


function love.load()

	local width, height = love.graphics.getDimensions()


	world = love.physics.newWorld( 0, 980, false )

	floor = getFloor( width, height )



end

function love.update(dt)

	world:update(dt)
	
end

function love.draw()

	drawFloor()


end



-- BONE
function getBone()

	local b = {}

	b.width = 50
	b.height = 10

	b.body = love.physics.newBody( world, 100, 100, 'dynamic' )
	b.shape = love.physics.newRectangleShape( b.width / 2, b.height / 2, b.width, b.height )
	b.fixture = love.physics.newFixture( b.body, b.shape )

	return b

end

function drawBone()
	love.graphics.setColor( 0.9, 0.9, 0.9 )
	love.graphics.rectangle('fill', bone.body:getX(), bone.body:getY(), bone.width, bone.height)

	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', bone.body:getX(), bone.body:getY(), 4, nil)
end





-- FLOOR
function getFloor(width, height)
	-- FLOOR
	local f = {}

	f.width = width
	f.height = height * 0.1

	f.body = love.physics.newBody( world, 0, height - f.height, 'static' )
	f.shape = love.physics.newRectangleShape(f.width / 2, f.height / 2, f.width, f.height )
	f.fixture = love.physics.newFixture( f.body, f.shape )

	return f

end

function drawFloor()
	love.graphics.setColor( 0.2, 0.7, 0.2 )
	love.graphics.rectangle('fill', floor.body:getX(), floor.body:getY(), floor.width, floor.height)
end


-- OBJECT
function getObject(x, y, width, height)
	local o = {}

	o.width = width
	o.height = height

	o.body = love.physics.newBody( world, x, y, 'dynamic' )
	o.shape = love.physics.newRectangleShape(o.width / 2, o.height / 2, o.width, o.height )
	o.fixture = love.physics.newFixture( o.body, o.shape )

	return o
end

function drawObject(o)



	love.graphics.setColor( 0.9, 0.4, 0.9 )
	love.graphics.rectangle('fill', o.body:getX() - o.width / 2, o.body:getY() - o.height / 2, o.width, bone.height)

	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', o.body:getX(), o.body:getY(), 4, nil)
end



function drawRectangle(x, y, width, height, angle, ox, oy)

	love.graphics.translate(x, y)

	love.graphics.rotate(angle)

	love.graphics.setColor( 0.9, 0.4, 0.9 )
	love.graphics.rectangle('fill', -ox, -oy, width, height)

	love.graphics.setColor( 0.8, 0.2, 0.2 )
	love.graphics.circle('fill', 0, 0, 4, nil)
	
end