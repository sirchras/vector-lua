local sqrt = math.sqrt

local vector = {}
vector.__index = vector

local function isvector(t)
	return getmetatable(t) == vector
end

local function new(x, y)
	local o = {x = x or 0, y = y or 0}
	assert(type(o.x) == "number" and type(o.y) == "number",
	 "wrong argument types: expected <number> and <number>")
	return setmetatable(o, vector)
end

function vector:clone()
	return new(self.x, self.y)
end

function vector.iseq(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return a.x == b.x and a.y == b.y
end
vector.__eq = vector.iseq

function vector.__unm(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return new(-a.x, -a.y)
end

function vector.add(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return new(a.x + b.x, a.y + b.y)
end
vector.__add = vector.add

function vector.sub(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return new(a.x - b.x, a.y - b.y)
end
vector.__sub = vector.sub

function vector.dot(a, b)
	assert(isvector(a) and isvector(b),
	 "wrong argument types: expected <vector> and <vector>")
	return (a.x * b.x) + (a.y * b.y)
end

function vector.mult(a ,b)
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

function vector.div(a, b)
	assert(isvector(a) and type(b) == "number",
	 "wrong argument types: expected <vector> and <number>")
	assert(b ~= 0, "invalid argument: <number> should be non-zero")
	return new(a.x / b, a.y / b)
end
vector.__div = vector.div

function vector.magsq(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return a:dot(a)
end

function vector.mag(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	return sqrt(a:magsq())
end
vector.__len = vector.mag

function vector.norm(a)
	assert(isvector(a), "wrong argument type: expected <vector>")
	local mag = a:mag()
	if mag <= 1 then
		return a:clone()
	else
		return new(a.x / mag, a.y / mag)
	end
end

function vector:__tostring()
	return "(" .. self.x .. "," .. self.y .. ")"
end

local module = {
	new = new,
	add = vector.add,
	sub = vector.sub,
	mult = vector.mult,
	div = vector.div,
	dot = vector.dot,
	magsq = vector.magsq,
	mag = vector.mag,
	norm = vector.norm,
	clone = vector.clone,
	isvector = isvector
}
return setmetatable(module, {
	__call = function(_,...) return new(...) end
})
