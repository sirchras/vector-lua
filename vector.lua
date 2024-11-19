local PI = math.pi

-- vector class
---@class vector
---@field x number x coordinate
---@field y number y coordinate
---@operator add(vector): vector
--@field dot fun(a:vector,b:vector):number
local vector = {}
vector.__index = vector

-- check if obj is a vector
local function isvector(t)
	return getmetatable(t) == vector
end

-- create new vector
local function new(x, y)
	local o = {x = x or 0, y = y or 0}
	assert(type(o.x) == "number" and type(o.y) == "number",
	 "wrong argument types: expected <number> and <number>")
	return setmetatable(o, vector)
end

-- create new unit vector from angle (in tau)
local function fromangle(angle)
	-- angle in PICO-8 is expressed in fractions of 2 * PI
	local angle = angle * 2 * PI
	return new(math.cos(angle), -math.sin(angle))
end

-- create a new random unit vector
local function random()
	return fromangle(math.random())
end

-- return a clone of the vector
function vector:clone()
	return new(self.x, self.y)
end

-- check if two vectors are equal
function vector.iseq(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return a.x == b.x and a.y == b.y
end
vector.__eq = vector.iseq

-- negate a vector (x,y) -> (-x,-y)
function vector.__unm(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return new(-a.x, -a.y)
end

-- return the sum of two vectors
function vector.add(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return new(a.x + b.x, a.y + b.y)
end
vector.__add = vector.add

-- return the difference of two vectors
function vector.sub(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return new(a.x - b.x, a.y - b.y)
end
vector.__sub = vector.sub

---return the dot product of two vectors
---@param a vector
---@param b vector
---@return number
function vector.dot(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return (a.x * b.x) + (a.y * b.y)
end

---return the product of scalar/vector or vector/vector multiplication
---@param a vector | number
---@param b vector | number
---@return vector | number
function vector.mult(a, b)
	if type(b) == "number" then
		return new(a.x * b, a.y * b)
	elseif type(a) == "number" then
		return new(b.x * a, b.y * a)
	else
		assert(isvector(a) and isvector(b),
		 "wrong argument types: expected <vector> or <number>")
		return a:dot(b)
	end
end
vector.__mul = vector.mult

-- return the result of dividing the vector by non-zero scalar
function vector.div(a, b)
	assert(isvector(a) and type(b) == "number",
	 "wrong argument types: expected <vector> and <number>")
	assert(b ~= 0, "invalid argument: <number> should be non-zero")
	return new(a.x / b, a.y / b)
end
vector.__div = vector.div

---return the squared magnitude of the vector
---@param a vector
---@return number
function vector.magsq(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return a:dot(a)
end

---return the magnitude of the vector
---@param a vector
---@return number
function vector.mag(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return math.sqrt(a:magsq())
end
vector.__len = vector.mag

-- return a norm of the vector
function vector.norm(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	local mag = a:mag()
	if mag == 1 or mag == 0 then
		return a:clone()
	else
		return new(a.x / mag, a.y / mag)
	end
end

-- return the angle heading of the vector (in tau)
function vector.heading(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	-- this is what works for some reason
	-- really thought I'd have to invert the y arg to match PICO-8
	return math.atan(a.y, a.x) / (2 * PI) % 1
end


---return the distance between the vectors
---@param a vector
---@param b vector
---@return number
function vector.dist(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	local diff = vector.sub(a, b)
	return diff:mag()
end

-- todo: better function name?
-- return the angle between the vectors
function vector.angle(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	local a, b = a:norm(), b:norm()
	if a:iseq(b) then
		return 0.0
	end
	-- floating point / nan headaches ;-;
	return math.acos(a:dot(b)) / (2 * PI)
end
-- todo:
-- could use math.modf to try handle small fractional differences
-- could also just math.abs the difference in vector headings

-- return string representation of the vector
function vector:__tostring()
	return "(" .. self.x .. "," .. self.y .. ")"
end

-- create the module
local module = {
	new = new,
	isvector = isvector,
	random = random,
	fromangle = fromangle,
	add = vector.add,
	sub = vector.sub,
	mult = vector.mult,
	div = vector.div,
	dot = vector.dot,
	magsq = vector.magsq,
	mag = vector.mag,
	norm = vector.norm,
	clone = vector.clone,
	heading = vector.heading,
	dist = vector.dist,
	angle = vector.angle,
}
return setmetatable(module, {
	__call = function(_,...) return new(...) end
})
