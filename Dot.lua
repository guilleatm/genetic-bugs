local Dot = {}

local MAX_WIDTH = 100
local MAX_HEIGHT = 100

local HEIGHT_OFFSET = 200
local WIDTH_OFFSET = 100

local SCALE_FACTOR = 0.15


function Dot:new(x, y)

	local d = {}

	local _height  = love.graphics.getHeight()

	d.x = x * SCALE_FACTOR  + WIDTH_OFFSET
	d.y = _height - y * SCALE_FACTOR - HEIGHT_OFFSET

	
	setmetatable(d, self)
	self.__index = self
	return d
end

function Dot:draw()

	love.graphics.setColor(1, 0, 1)
	love.graphics.circle('fill', self.x, self.y, 2, nil)

end

function Dot:drawJoint()

	love.graphics.setColor(1, 0.2, 0.4)
	love.graphics.circle('fill', self.x, self.y, 4, nil)

end


function Dot:angle(other)

	local angle = math.atan2 ( self.y - other.y, other.x - self.x)

	--local c = 180 / math.pi

	return angle

end

return Dot