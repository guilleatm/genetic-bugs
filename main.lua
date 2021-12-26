
local Bug = require 'Bug'
local bones = {}
local joints = {}
local floor



function love.load()

	local width, height = love.graphics.getDimensions()

	-- CREATE WORLD
	world = love.physics.newWorld( 0, 980, false )
	floor = getFloor( width * 200, height )
	--floor = getFloor( 0, 0 )

	math.randomseed(os.time(nil))


	-- CREATE BONES
	-- local numBones = 10
	-- for i = 1, numBones do
	-- 	table.insert( bones, Bone:new(100) )
	-- end

	-- for i = 1, numBones - 1, 2 do
	-- 	local joint = love.physics.newRevoluteJoint(bones[i].body, bones[i + 1].body, 0, 0, false)
		
	-- 	table.insert( joints, joint )
	-- end



	-- local NUM_BUGS = 10

	-- for i = 1, NUM_BUGS do
	-- 	local bug = Bug:new
		
		
	-- end



	-- plate = Bone:new(100)
	-- plate2 = Bone:new(60, 2)
	-- plate3 = Bone:new(50, -1)
	--plate.body:applyAngularImpulse(100000)

	-- a = {}
	-- a.body = love.physics.newBody(world, 200, 200, "static")





	--b = love.physics.newBody(world, 190, 100, "dynamic")



	-- local jointX, jointY = plate:getJointPosition(1)
	-- local joint = love.physics.newRevoluteJoint(plate.body, a.body, jointX, jointY, false)

	-- jointX, jointY = plate2:getJointPosition(2)
	-- local joint2 = love.physics.newRevoluteJoint(plate2.body, plate.body, jointX, jointY, false)
	

	-- plate2:attachBone(plate)
	-- plate3:attachBone(plate2)


	bug = Bug:new(5)
	bug:generate()


	local anchor = love.physics.newBody(world, 200, 200, "static")
	local jointX, jointY = bug.bones[1]:getJointPosition(1)
	local joint = love.physics.newRevoluteJoint(anchor, bug.bones[1].body, jointX, jointY, false)
	


end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.quit(0)
	end

	
	if love.keyboard.isDown('space') then
		world:update(dt)

		
	end
	bug:update()
	-- plate:update()
	-- plate2:update()
	-- plate3:update()
	
end

function love.draw()

	drawFloor()


	-- -- DRAW BONES
	-- for i, bone in ipairs( bones ) do
	-- 	bone:draw()
	-- end

	-- plate:draw()
	-- plate2:draw()
	-- plate3:draw()


	bug:draw()


	love.graphics.print("fps: ".. tostring(love.timer.getFPS()), 10, 10)

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

	f.fixture:setRestitution(0)
	f.fixture:setFilterData( 1, 65535, 1 )

	return f

end

function drawFloor()
	love.graphics.setColor( 0.2, 0.7, 0.2 )
	love.graphics.rectangle('fill', floor.body:getX(), floor.body:getY(), floor.width, floor.height)
end
