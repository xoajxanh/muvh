local LuaObject = {}
LuaObject.__className = nil
LuaObject.go = nil
LuaObject.__index = LuaObject
LuaObject.__RunBaseCountDic = {}
LuaObject.__gc = luaClassManager.OnTableDestroyed

function LuaObject:New(...)
  return self:NewWithGO(nil, ...)
end

function LuaObject:NewWithGO(go, ...)
  local tbl = {}
  setmetatable(tbl, self)
  tbl.__DynamicObj = true
  tbl.go = go
  tbl:Init(...)
  return tbl
end

function LuaObject:RegistEvent(type, func, data, priority)
  if not type then
    print("event not exist")
    return
  end
  if not self.eventContainer then
    self.eventContainer = EventContainer(EventManager)
  end
  self.eventContainer:Regist(type, func, data, priority)
end

function LuaObject:UnRegistEvent(type, func, data)
  if not type then
    return
  end
  if self.eventContainer then
    self.eventContainer:UnRegist(type, func, data)
  end
end

function LuaObject:UnRegistAllEvents()
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
end

function LuaObject:RunBaseFunction(functionName, ...)
  if self ~= nil and functionName ~= nil then
    if table.containsKey(LuaObject.__RunBaseCountDic, self) == false then
      LuaObject.__RunBaseCountDic[self] = {}
    end
    if table.containsKey(LuaObject.__RunBaseCountDic[self], functionName) == false then
      LuaObject.__RunBaseCountDic[self][functionName] = 1
    else
      LuaObject.__RunBaseCountDic[self][functionName] = LuaObject.__RunBaseCountDic[self][functionName] + 1
    end
    local baseMetaTable = self.__DynamicObj and getmetatable(self) or self
    for i = 1, LuaObject.__RunBaseCountDic[self][functionName] do
      if baseMetaTable ~= nil then
        baseMetaTable = getmetatable(baseMetaTable)
      else
        break
      end
    end
    local result
    if baseMetaTable ~= nil and baseMetaTable[functionName] ~= nil then
      if table.IsTruelyContainsKey(baseMetaTable, functionName) then
        result = {
          baseMetaTable[functionName](self, ...)
        }
      else
        result = {
          self:RunBaseFunction(functionName, ...)
        }
      end
    end
    LuaObject.__RunBaseCountDic[self][functionName] = LuaObject.__RunBaseCountDic[self][functionName] - 1
    if LuaObject.__RunBaseCountDic[self][functionName] == 0 then
      LuaObject.__RunBaseCountDic[self][functionName] = nil
      if table.isNullOrEmpty(LuaObject.__RunBaseCountDic[self]) then
        LuaObject.__RunBaseCountDic[self] = nil
      end
    end
    if result ~= nil then
      return table.unpack(result)
    end
  end
end

function LuaObject:Init(...)
end

function LuaObject:OnDestruct()
  for i, v in pairs(self) do
    local luaObject = self[i]
    if type(luaObject) == "table" and luaObject.OnDestruct ~= nil and not luaObject.isClean then
      luaObject.isClean = true
      luaObject:OnDestruct()
    end
    self:UnRegistAllEvents()
    if i ~= "isClean" then
      self[i] = nil
    end
  end
end

return LuaObject
