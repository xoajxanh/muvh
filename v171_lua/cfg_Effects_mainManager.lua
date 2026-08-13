local cfg_Effects_mainManager = {}

function cfg_Effects_mainManager:GetName()
  return "cfg_Effects_mainManager"
end

function cfg_Effects_mainManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Effects_main")
  end
  return self.dic
end

setmetatable(cfg_Effects_mainManager, TableManagerBase)

function cfg_Effects_mainManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Effects_mainManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Effects_mainManager:SetEffectTipActive(id, effectActive)
  if type(id) ~= "number" then
    return
  end
  local effectMainTbl = self:TryGetValue(id)
  if effectMainTbl == nil then
    return
  end
  local tipEffectParam = {}
  tipEffectParam.name = effectMainTbl.name
  if effectMainTbl.effectTime > 0 then
    tipEffectParam.effectTime = effectMainTbl.effectTime * 0.001
  end
  if effectActive ~= nil then
    tipEffectParam.effectActive = effectActive
  end
  TipUtility.ShowTipEffect(tipEffectParam)
end

return cfg_Effects_mainManager
