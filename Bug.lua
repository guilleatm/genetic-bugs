local Bug = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local pixel = love.graphics.newImage("pixel.jpg")

function Bug:new()
	local b = {}

	b.numBones = 3



	setmetatable(b, self)
	self.__index = self
	return b
end


function Bug:update()


end

function Bug:draw()

	-- local x, y = self.body:getPosition()
	-- local angle = self.body:getAngle()

	-- -- BONE
	-- love.graphics.setColor(0.8, 0.8, 0.8)
	-- love.graphics.draw(pixel, x, y, angle, self.width, self.height, self.ox / self.width, self.oy / self.height, nil, nil)

	-- -- AABB
	-- love.graphics.setColor(0.2, 0.2, 0.8)
	-- local topLeftX, topLeftY, bottomRightX, bottomRightY = self.shape:computeAABB( x, y, self.body:getAngle(), 1 )
	-- love.graphics.polygon('line', topLeftX, topLeftY, bottomRightX, topLeftY, bottomRightX, bottomRightY, topLeftX, bottomRightY)

	-- -- CENTER
	-- love.graphics.setColor( 0.8, 0.2, 0.2 )
	-- love.graphics.circle('fill', x , y, 3, nil)

	-- -- JOINT A
	-- love.graphics.setColor( 0.8, 0.2, 0.2 )
	-- love.graphics.circle('fill', self.jointAx, self.jointAy, 3, nil)

	-- -- JOINT B
	-- love.graphics.setColor( 0, 0.5, 0 )
	-- love.graphics.circle('fill', self.jointBx, self.jointBy, 3, nil)


end


return Bug