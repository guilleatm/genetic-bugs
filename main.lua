
local Bone = require 'Bone'

local bones = {}
local floor



function love.load()

	local width, height = love.graphics.getDimensions()

	-- CREATE WORLD
	world = love.physics.newWorld( 0, 980, false )
	floor = getFloor( width, height )


	-- CREATE BONES
	local numBones = 10
	for i = 1, numBones do
		table.insert( bones, Bone:new(100) )
	end



end

function love.update(dt)

	world:update(dt)
	
end

function love.draw()

	drawFloor()


	-- DRAW BONES
	for i, bone in ipairs( bones ) do
		bone:draw()
	end


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