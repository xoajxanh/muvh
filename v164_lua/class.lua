function class(base)
  local c = {}
  
  local m = {}
  
  function m.__call(t, ...)
    local o = {}
    setmetatable(o, t)
    if o.ctor then
      o:ctor(...)
    end
    return o
  end
  
  c.__base = base
  if base then
    c.base = base
    m.__index = base
  end
  
  function c.__index(t, k)
    local v = c[k]
    if v then
      return v
    end
    local getters = c.__getters
    if getters == 0 then
      return nil
    end
    local getter = getters[k]
    return getter and getter(t) or nil
  end
  
  setmetatable(c, m)
  setgetters(c, nil)
  return c
end

local tempGetters = {}

function setgetters(cls, getters)
  local base = cls.__base
  if base and base.__getters ~= 0 then
    for k, v in pairs(base.__getters) do
      tempGetters[k] = v
    end
  end
  if getters then
    for k, v in pairs(getters) do
      tempGetters[k] = v
    end
  end
  if next(tempGetters) then
    cls.__getters = tempGetters
    tempGetters = {}
  else
    cls.__getters = 0
  end
end
