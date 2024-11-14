sqrt=math.sqrt

class={}
function class:new(o)
	local o=o or {}
	setmetatable(o,self)
	self.__index=self
	return o
end

_vector=class:new{
	x=0,
	y=0,
}
function _vector.add(self,v)
	return _vector:new{
		x=self.x+v.x,
		y=self.y+v.y
	}
end
function _vector.sub(self,v)
	return _vector:new{
		x=self.x-v.x,
		y=self.y-v.y
	}
end
function _vector.mult(self,s)
	assert(type(s)=="number")
	return _vector:new{
		x=self.x*s,
		y=self.y*s
	}
end
function _vector.div(self,s)
	assert(type(s)=="number")
	assert(s!=0)
	return _vector:new{
		x=self.x/s,
		y=self.y/s
	}
end
function _vector.magsq(self)
	return (self.x*self.x)+(self.y*self.y)
end
function _vector.mag(self)
	return sqrt(self:magsq())
end