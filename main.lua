
--5383551578837263929420509003536591838980299206051753835515788372739294205090035365918389802992060517
local Bug = require 'Bug'
local Dna = require 'Dna'
local bones = {}
local joints = {}
local floor

local NUM_DOTS = 5
local NUM_BUGS = 40
local MUTATION_RATE = 0.1

local TIME_PER_GEN = 10

local bugs = {}

local gen = 0

local timer = TIME_PER_GEN


function love.load()

	local width, height = love.graphics.getDimensions()

	-- CREATE WORLD
	world = love.physics.newWorld( 0, 980, false )
	floor = getFloor( width * 200, height )
	local wall = getWall (width, height)
	--floor = getFloor( 0, 0 )

	math.randomseed(os.time(nil))



	for i = 1, 2 * NUM_BUGS do

		local dna = Dna:random(NUM_DOTS)

		local bug = Bug:new(NUM_DOTS)
		bug:generate(dna)

		table.insert( bugs, bug )
	end



	-- local dna = Dna:random(NUM_DOTS)


	-- bug = Bug:new(NUM_DOTS)
	-- bug:generate(dna)


	-- local anchor = love.physics.newBody(world, 200, 200, "static")
	-- local jointX, jointY = bug.bones[1]:getJointPosition(1)
	-- local joint = love.physics.newRevoluteJoint(anchor, bug.bones[1].body, jointX, jointY, false)
	


end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.quit(0)
	end

	
	if love.keyboard.isDown('space') then
		local l = world:getBodies()
		print(#l)
		--world:update(dt * 2)
	else
		world:update(dt)
	end

	--bug:update()
	-- plate:update()
	-- plate2:update()
	-- plate3:update()

	for i, bug in ipairs(bugs) do
		bug:update(dt)
	end

	timer = timer - dt
	
end

function love.draw()

	drawFloor()


	for i, bug in ipairs(bugs) do
		bug:draw()
	end


	
	if timer <= 0 then
		nextGen()
		timer = TIME_PER_GEN
	end


	love.graphics.print("fps: ".. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("gen: ".. tostring(gen), 10, 30)
	love.graphics.print("population: ".. tostring(#bugs), 10, 50)

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

function getWall(width, height)
	-- WALL
	local f = {}

	f.width = 1
	f.height = height

	f.body = love.physics.newBody( world, -1, 0, 'static' )
	f.shape = love.physics.newRectangleShape(f.width / 2, f.height / 2, f.width, f.height )
	f.fixture = love.physics.newFixture( f.body, f.shape )

	f.fixture:setRestitution(0.8)
	f.fixture:setFilterData( 1, 65535, 1 )

	return f

end

function drawFloor()
	love.graphics.setColor( 0.2, 0.7, 0.2 )
	love.graphics.rectangle('fill', floor.body:getX(), floor.body:getY(), floor.width, floor.height)
end

function nextGen()




	local sortfunction = function (a, b) return a:getPunctuation() > b:getPunctuation() end

	table.sort( bugs, sortfunction )


	if gen == 40 then
		print("\nGEN 40 REACHED\n")
		print("Max punctuation: " .. bugs[1]:getPunctuation())
		print("Dna: " .. bugs[1].dna)
		print()
	end



	-- for i, e in ipairs(bugs) do
	-- 	print(e:getPunctuation())
	-- end

	local MUTATION = 0.3
	local CROSSOVER = 0.6
	--local TRIPLE_CROSSOVER = 0.7
	local RANDOM = 0.1




	local dnas = {}

	print("gen " .. gen .. " dna: " .. bugs[1].dna)

	table.insert( dnas, bugs[1].dna )
	--table.insert( dnas, bugs[2].dna )

	local mutate = function (dna)
		return Dna:mutate(dna, 1)
	end

	local crossover = function (dna, dnb)
		local r = Dna:crossover(dna, dnb, CROSSOVER)
		return Dna:mutate(r, MUTATION_RATE)
	end

	local random = function ()
		return Dna:random(NUM_DOTS)
	end

	for i = 1, math.floor(MUTATION * #bugs) do
		apply(dnas, mutate, dnas[i])
	end

	for i = 1, math.floor(CROSSOVER * #bugs) do
		apply(dnas, crossover, dnas[i], dnas[i + 1])
	end

		for i = 1, math.floor(RANDOM * #bugs) do
		apply(dnas, random)
	end

	

	--print(#dnas)
	--clean()
	world:destroy()
	--world:release()
	world = love.physics.newWorld(0, 980, true)

	local width, height = love.graphics.getDimensions()

	floor = getFloor( width * 200, height )
	local wall = getWall (width, height)

	bugs = {}


	for i = 1, math.min(NUM_BUGS, #dnas) do

		local dna = dnas[i]

		local bug = Bug:new(NUM_DOTS)
		bug:generate(dna)


		if i == 1 then
			bug.winner = true
		end
		table.insert( bugs, bug )
	end

	if #dnas < NUM_BUGS then
		print("insert extra random bug")
		for i = 1, NUM_BUGS - #dnas do
			local dna = Dna:random()
			table.insert( dnas, dna )
		end
	end

	gen = gen + 1

end

function clean()
	for i, bug in ipairs(bugs) do
		for _, bone in ipairs(bug.bones) do
			bone.fixture:destroy()

			bone.fixture:release()
			bone.shape:release()
			bone.body:release()
		end

		bug = nil

	end

	bugs = nil


	collectgarbage("collect")
	print("mem: " .. collectgarbage("count"))
	print()
end

function test()
	local t = {}
	local dna = "69002363369258259049862450949898593314686544601189"
	local dnb = "62346328959283472935928729317592879582357275218575"

	table.insert( t, dna )
	for i = 1, 1000 do
		
		table.insert( t, Dna:crossover(dna, dnb) )

	end


	local l = #t[1]
	for i, v in ipairs(t) do
		if #v ~= l then
			print("ERROR")
		end
	end
end

function exist(dna, dnas)
	for i, d in ipairs(dnas) do
		if d == dna then
			return true
		end
	end

	return false
end

function apply(dnas, f, dna, dnb)

	local r = f(dna, dnb, dnc)

	while exist(r, dnas) do
		r = f(dna, dnb, dnc)
	end

	table.insert(dnas, r)

end

-- table.sort( tablename, sortfunction )

-- local t = {1, 2, 3, 4, 5};

-- table.sort(t, function(a, b) return a < b end);
