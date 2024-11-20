local PI = math.pi

---@class Vector
---@field x number x coordinate
---@field y number y coordinate
---@operator add(Vector): Vector
---@operator sub(Vector): Vector
---@operator mul(Vector|number): Vector|number
---@operator div(number): Vector
---@operator len:number
---@operator unm:Vector
local Vector = {}
Vector.__index = Vector

---check if the table is a vector
---@param t table
---@return boolean # true if the table is a vector
local function isvector(t)
	return getmetatable(t) == Vector
end

---create new vector
---@param x number x coordinate
---@param y number y coordinate
---@return Vector
local function new(x, y)
	local o = {x = x or 0, y = y or 0}
	assert(type(o.x) == "number" and type(o.y) == "number",
	 "wrong argument types: expected <number> and <number>")
	return setmetatable(o, Vector)
end

---create new unit vector from angle
---@param angle number as a fraction of a turn (2 * PI radians)
---@return Vector
local function fromangle(angle)
	-- angle in PICO-8 is expressed in fractions of 2 * PI
	local angle = angle * 2 * PI
	return new(math.cos(angle), -math.sin(angle))
end

---create a new random unit vector
---@return Vector
local function random()
	return fromangle(math.random())
end

---return a clone of the vector
---@param self Vector
---@return Vector
function Vector:clone()
	return new(self.x, self.y)
end

---check if two vectors are equal
---@param a Vector
---@param b Vector
---@return boolean # true if the vectors are equal
function Vector.iseq(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
	return a.x == b.x and a.y == b.y
end
Vector.__eq = Vector.iseq

---negate the vector
---@param a Vector
---@return Vector # opposite vector (-x, -y)
function Vector.__unm(a)
	assert(isvector(a), "wrong argument type: expected <Vector>")
	return new(-a.x, -a.y)
end

---return the sum of two vectors
---@param a Vector
---@param b Vector
---@return Vector
function Vector.add(a, b)

	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
	return new(a.x + b.x, a.y + b.y)
end
Vector.__add = Vector.add

---return the difference of two vectors
---@param a Vector
---@param b Vector
---@return Vector
function Vector.sub(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
	return new(a.x - b.x, a.y - b.y)
end
Vector.__sub = Vector.sub

---return the dot product of two vectors
---@param a Vector
---@param b Vector
---@return number
function Vector.dot(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
	return (a.x * b.x) + (a.y * b.y)
end

---return the product of scalar/vector or vector/vector multiplication
---@param a Vector | number
---@param b Vector | number
---@return Vector | number
function Vector.mult(a, b)
	if type(b) == "number" then
		return new(a.x * b, a.y * b)
	elseif type(a) == "number" then
		return new(b.x * a, b.y * a)
	else
		assert(isvector(a) and isvector(b),
		 "wrong argument types: expected <Vector> or <number>")
		return a:dot(b)
	end
end
Vector.__mul = Vector.mult

---return the result of dividing the vector by non-zero scalar
---@param a Vector
---@param b number # must be non-zero
---@return Vector
function Vector.div(a, b)
	assert(isvector(a) and type(b) == "number",
	 "wrong argument types: expected <Vector> and <number>")
	assert(b ~= 0, "invalid argument: <number> should be non-zero")
	return new(a.x / b, a.y / b)
end
Vector.__div = Vector.div

---return the squared magnitude of the vector
---@param a Vector
---@return number
function Vector.magsq(a)
	assert(isvector(a), "wrong argument type: expected <Vector>")
	return a:dot(a)
end

---return the magnitude of the vector
---@param a Vector
---@return number
function Vector.mag(a)
	assert(isvector(a), "wrong argument type: expected <Vector>")
	return math.sqrt(a:magsq())
end
Vector.__len = Vector.mag

---return the normalized vector
---@param a Vector
---@return Vector
function Vector.norm(a)
	assert(isvector(a), "wrong argument type: expected <Vector>")
	local mag = a:mag()
	if mag == 1 or mag == 0 then
		return a:clone()
	else
		return new(a.x / mag, a.y / mag)
	end
end

---return the angle heading of the vector
---@param a Vector
---@return number # angle as a fraction of a turn (2 * PI radians)
function Vector.heading(a)
	assert(isvector(a), "wrong argument type: expected <Vector>")
	-- this is what works for some reason
	-- really thought I'd have to invert the y arg to match PICO-8
	return math.atan(a.y, a.x) / (2 * PI) % 1
end

---return the distance between the vectors
---@param a Vector
---@param b Vector
---@return number
function Vector.dist(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
	local diff = Vector.sub(a, b)
	return diff:mag()
end

---return the angle between the vectors
---@param a Vector
---@param b Vector
---@return number # angle as a fraction of a turn (2 * PI radians)
function Vector.angle(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <Vector> and <Vector>")
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
-- better function name?

---return string representation of the vector
---@param self Vector
---@return string
function Vector:__tostring()
	return "(" .. self.x .. "," .. self.y .. ")"
end

---@class module
---@operator call: Vector
local module = {
	new = new,
	isvector = isvector,
	random = random,
	fromangle = fromangle,
	add = Vector.add,
	sub = Vector.sub,
	mult = Vector.mult,
	div = Vector.div,
	dot = Vector.dot,
	magsq = Vector.magsq,
	mag = Vector.mag,
	norm = Vector.norm,
	clone = Vector.clone,
	heading = Vector.heading,
	dist = Vector.dist,
	angle = Vector.angle,
}
return setmetatable(module, {
	---@overload fun(_: any, ...): Vector
	---@vararg number
	__call = function(_,...) return new(...) end
})
