local lu = require('luaunit')
local vector = require('vector')

TestCreate = {
  testCreateFromZeroAngle = function(self)
    local v = vector.fromangle(0)
    lu.assertEquals(v.x, 1)
    lu.assertEquals(v.y, 0)
    lu.assertTrue(vector.isvector(v))
  end,
  testCreateFromAngle = function(self)
    local v = vector.fromangle(0.375)
    lu.assertAlmostEquals(v.x, -0.7071, 0.0001)
    lu.assertAlmostEquals(v.y, 0.7071, 0.0001)
    lu.assertTrue(vector.isvector(v))
  end,
  testCreateError = function(self)
    -- edge case: code is probably idiot-proofed enough
    lu.assertErrorMsgContains("wrong argument types: expected <number> and <number>",
     vector.new, "obvious error")
  end,
}

TestIsVector = {
  testIsVector = function(self)
    local v = vector(1, 1)
    lu.assertTrue(vector.isvector(v))
  end,
  testIsNotVector = function(self)
    local v = {x = 1, y = 2}
    lu.assertFalse(vector.isvector(v))
  end,
}

TestVectorEqualOperation = {
  testEqual = function(self)
    local v1 = vector(1, 1)
    local v2 = vector(1, 1)
    lu.assertTrue(v1 == v2)
    lu.assertEquals(v1, v2)
  end,
  testNotEqual = function(self)
    local v1 = vector(1, 2)
    local v2 = vector(2, 1)
    lu.assertFalse(v1 == v2)
    lu.assertNotEquals(v1, v2)
  end,
  testEqualNonVectorTbl = function(self)
    local v = vector(1, 2)
    local t = {x = 1, y = 2}
    local iseq = function(a, b) --necessary to expose metamethod
      return a == b
    end
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     iseq, v, t)
  end,
}

TestVectorAddOperation = {
  testAdd = function(self)
    local v1 = vector(1, 2)
    local v2 = vector(2, -3)
    local sum = v1 + v2
    lu.assertEquals(sum, vector(3, -1))
  end,
  testAddZero = function(self)
    local v = vector(1, 2)
    local zero = vector() -- (0, 0)
    local sum = v + zero
    lu.assertEquals(sum, v)
  end,
  testAddNonVectorTbl = function(self)
    local v = vector(1, 1)
    local t = {x = 1, y = 2}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.add, v, t)
  end,
  testAddScalar = function(self)
    local v = vector(1, 1)
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.add, v, 2)
  end,
}

TestVectorSubOperation = {
  testSub = function(self)
    local v1 = vector(4, 2)
    local v2 = vector(2, -2)
    local diff = v1 - v2
    lu.assertEquals(diff, vector(2, 4))
  end,
  testSubZero = function(self)
    local v = vector(3, 2)
    local zero = vector() -- (0, 0)
    local diff = v - zero
    lu.assertEquals(diff, v)
  end,
  testSubNonVectorTbl = function(self)
    local v = vector(2, 2)
    local t = {x = 2, y = 1}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.add, v, t)
  end,
  testSubScalar = function(self)
    local v = vector(4, 2)
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.sub, v, 3)
  end,
}

TestDotProduct = {
  testDotProd = function(self)
    local v1 = vector(3, 3)
    local v2 = vector(-3, 3)
    local prod = v1:dot(v2)
    lu.assertIsNumber(prod)
    lu.assertEquals(prod, 0)
  end,
  testDotProdError = function(self)
    local v = vector(3, 3)
    local t = {x = -3, y = 3}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     v.dot, v, t)
  end,
}

TestVectorMultOperation = {
  -- same as dot product
  testMultVector = function(self)
    local v1 = vector(3, 3)
    local v2 = vector(-3, 3)
    local prod = v1 * v2
    lu.assertIsNumber(prod)
    lu.assertEquals(prod, 0)
  end,
  testMultZero = function(self)
    local zero = vector() -- (0, 0)
    local v = vector(2, 1)
    local prod = v * 0 --[[@as Vector]]
    lu.assertTrue(vector.isvector(prod))
    lu.assertEquals(prod, zero)
  end,
  testMultScalar = function(self)
    local v = vector(2, 1)
    local prod = 3 * v --[[@as Vector]]
    lu.assertTrue(vector.isvector(prod))
    lu.assertEquals(prod, vector(6, 3))
  end,
  testMultError = function(self)
    local v = vector(1, 2)
    local t = {x = -2, y = 1}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> or <number>",
     vector.mult, v, t)
  end,
}

TestVectorDivOperation = {
  testDiv = function(self)
    local v = vector(2, 4)
    local res = v / 2
    lu.assertEquals(res, vector(1, 2))
  end,
  testDivNonScalar = function(self)
    local v1 = vector(2, 4)
    local v2 = vector(1, 2)
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <number>",
     vector.div, v1, v2)
  end,
  testDivZero = function(self)
    local v = vector(3, 3)
    lu.assertErrorMsgContains("invalid argument: <number> should be non-zero",
     vector.div, v, 0)
  end,
}

TestMagnitude = {
  testMagSq = function(self)
    local v = vector(3, 4)
    local magsq = v:magsq()
    lu.assertEquals(magsq, 25)
  end,
  testMag = function(self)
    local v = vector(-3, -4)
    local mag = v:mag()
    lu.assertEquals(mag, 5)
  end,
  testMagZeroVector = function(self)
    local zero = vector() -- (0, 0)
    local mag = zero:mag()
    lu.assertEquals(mag, 0)
  end,
  testMagUnitVector = function(self)
    local unit = vector(0, -1)
    local mag = unit:mag()
    lu.assertEquals(mag, 1)
  end,
  testLenOperator = function(self)
    local v = vector(-5, 12)
    lu.assertEquals(#v, 13)
  end,
  testMagError = function(self)
    local t = {x = 2, y = 4}
    lu.assertErrorMsgContains("wrong argument type: expected <Vector>",
     vector.mag, t)
  end,
}

TestNormaliseFunction = {
  testNormZeroVector = function(self)
    local zero = vector() -- (0, 0)
    local norm = zero:norm()
    lu.assertEquals(norm, zero)
  end,
  testNormUnitVector = function(self)
    local unit = vector(1, 0)
    local norm = unit:norm()
    lu.assertEquals(norm, unit)
  end,
  testNormVector = function(self)
    local v = vector(3, 4)
    local norm = v:norm()
    lu.assertEquals(norm, vector(0.6, 0.8))
  end,
  testNormError = function(self)
    local t = {x = 2, y = 4}
    lu.assertErrorMsgContains("wrong argument type: expected <Vector>",
     vector.norm, t)
  end,
}

TestHeading = {
  testStandardBasisXVector = function(self)
    local x = vector(1, 0)
    local heading = x:heading()
    lu.assertEquals(heading, 0)
  end,
  testStandardBasisYVector = function(self)
    local y = vector(0, 1)
    local heading = y:heading()
    lu.assertEquals(heading, 0.25)
  end,
  testNegativeStandardXVector = function(self)
    local x = vector(-1, 0)
    local heading = x:heading()
    lu.assertEquals(heading, 0.5)
  end,
  testNegativeStandardYVector = function(self)
    local y = vector(0, -1)
    local heading = y:heading()
    lu.assertEquals(heading, 0.75)
  end,
  testVectorCreatedFromAngle = function(self)
    local angle = 0.875
    local v = vector.fromangle(angle)
    local heading = v:heading()
    lu.assertEquals(heading, angle)
  end,
  testVectorCreatedFromRandomAngle = function(self)
    local angle = math.random()
    local v = vector.fromangle(angle)
    local heading = v:heading()
    -- floating point >:(
    lu.assertAlmostEquals(heading, angle, 0.000000000001)
  end,
  testHeadingError = function(self)
    local t = {x = -1, y = -1}
    lu.assertErrorMsgContains("wrong argument type: expected <Vector>",
     vector.heading, t)
  end,
}

TestDistFunction = {
  testDist = function(self)
    local v1 = vector(5, 2)
    local v2 = vector(2, -2)
    local dist = v1:dist(v2)
    lu.assertEquals(dist, 5)
  end,
  testDistError = function(self)
    local v = vector(2, 2)
    local t = {x = 1, y = 2}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.dist, v, t)
  end,
}

TestAngleFunction = {
  testAngle = function(self)
    local v1 = vector(3, -3)
    local v2 = vector(0, 2)
    local angle = v1:angle(v2)
    lu.assertEquals(angle, 0.375)
  end,
  testAngleBetweenIdenticalVectors = function(self)
    local v = vector(-3, -4)
    local angle = v:angle(v)
    lu.assertEquals(angle, 0)
  end,
  testAngleError = function(self)
    local v = vector(-3, 4)
    local t = {x = 0, y = -3}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <Vector>",
     vector.angle, v, t)
  end,
}

TestLimit = {
  testLimit = function(self)
    local v = vector(0, -4)
    local lim = v:limit(3)
    lu.assertEquals(lim, vector(0, -3))
  end,
  testLimitError = function(self)
    local t = {x = -5, y = 12}
    lu.assertErrorMsgContains("wrong argument types: expected <Vector> and <number>",
     vector.limit, t, 3)
  end,
}

os.exit(lu.LuaUnit.run())
