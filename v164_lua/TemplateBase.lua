local TemplateBase = {}
TemplateBase.chunkName = nil
TemplateBase.__index = TemplateBase
TemplateBase.__gc = luaTemplateManager.OnTemplateGetGCed
TemplateBase.go = nil
TemplateBase.__UnityFunctionExist = false
TemplateBase.__RunBaseCountDic = {}

function TemplateBase:UIControl()
  if self.m_UIControl == nil then
    self.m_UIControl = UIControl(self.go.transform)
  end
  return self.m_UIControl
end

function TemplateBase:GetControl(path)
  return UIControl(self.go.transform, path)
end

TemplateBase.Init = nil
TemplateBase.Start = nil
TemplateBase.OnEnable = nil
TemplateBase.OnDisable = nil
TemplateBase.OnDestroy = nil
TemplateBase.OnDestruct = nil

function TemplateBase:RunBaseFunction(functionName, ...)
  if self ~= nil and functionName ~= nil then
    if table.containsKey(TemplateBase.__RunBaseCountDic, self) == false then
      TemplateBase.__RunBaseCountDic[self] = {}
    end
    if table.containsKey(TemplateBase.__RunBaseCountDic[self], functionName) == false then
      TemplateBase.__RunBaseCountDic[self][functionName] = 1
    else
      TemplateBase.__RunBaseCountDic[self][functionName] = TemplateBase.__RunBaseCountDic[self][functionName] + 1
    end
    local baseMetaTable = getmetatable(self)
    for i = 1, TemplateBase.__RunBaseCountDic[self][functionName] do
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
    TemplateBase.__RunBaseCountDic[self][functionName] = TemplateBase.__RunBaseCountDic[self][functionName] - 1
    if TemplateBase.__RunBaseCountDic[self][functionName] == 0 then
      TemplateBase.__RunBaseCountDic[self][functionName] = nil
      if table.isNullOrEmpty(TemplateBase.__RunBaseCountDic[self]) then
        TemplateBase.__RunBaseCountDic[self] = nil
      end
    end
    if result ~= nil then
      return table.unpack(result)
    end
  end
end

function TemplateBase:Refresh(data, ui)
end

return TemplateBase
