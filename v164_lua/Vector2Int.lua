local rawget = _ENV.rawget
local setmetatable = _ENV.setmetatable
Vector2Int = {}
local _getter = {}
local unity_Vector2Int = CS.UnityEngine.Vector2Int

function Vector2Int.__index(t, k)
  local var = rawget(Vector2Int, k)
  if var ~= nil then
    return var
  end
  var = rawget(_getter, k)
  if var ~= nil then
    return var(t)
  end
  return rawget(unity_Vector2Int, k)
end

function Vector2Int.__call(t, x, y)
  return setmetatable({
    x = x or 0,
    y = y or 0
  }, Vector2Int)
end

function Vector2Int.New(x, y)
  return setmetatable({
    x = x or 0,
    y = y or 0
  }, Vector2Int)
end

function Vector2Int:Set(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vector2Int:Get(v)
  return v.x, v.y
end

function Vector2Int:Clone()
  return setmetatable({
    x = self.x,
    y = self.y
  }, Vector2Int)
end

function Vector2Int.Magnitude(v)
  return Mathf.Sqrt(v.x * v.x + v.y * v.y)
end

function Vector2Int.SqrMagnitude(v)
  return v.x * v.x + v.y * v.y
end

function Vector2Int.DistancePow(a, b)
  return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)
end

function Vector2Int.__div(va, d)
  return setmetatable({
    x = Mathf.Floor(va.x / d),
    y = Mathf.Floor(va.y / d)
  }, Vector2Int)
end

function Vector2Int.__mul(a, d)
  if type(d) == "number" then
    return setmetatable({
      x = a.x * d,
      y = a.y * d
    }, Vector2Int)
  else
    return setmetatable({
      x = a * d.x,
      y = a * d.y
    }, Vector2Int)
  end
end

function Vector2Int.__add(a, b)
  return setmetatable({
    x = a.x + b.x,
    y = a.y + b.y
  }, Vector2Int)
end

function Vector2Int.__sub(a, b)
  return setmetatable({
    x = a.x - b.x,
    y = a.y - b.y
  }, Vector2Int)
end

function Vector2Int.__unm(v)
  return setmetatable({
    x = -v.x,
    y = -v.y
  }, Vector2Int)
end

function Vector2Int.__eq(a, b)
  local ax = a.x or 0
  local ay = a.y or 0
  local bx = b.x or 0
  local by = b.y or 0
  return (ax - bx) ^ 2 + (ay - by) ^ 2 < 9.999999E-11
end

function Vector2Int:__tostring()
  return "[" .. self.x .. "," .. self.y .. "]"
end

_getter.magnitude = Vector2Int.Magnitude
_getter.sqrMagnitude = Vector2Int.SqrMagnitude
Vector2Int.unity_vector2 = CS.UnityEngine.Vector2Int
CS.UnityEngine.Vector2Int = Vector2Int
setmetatable(Vector2Int, Vector2Int)
