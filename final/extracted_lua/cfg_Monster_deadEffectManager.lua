local cfg_Monster_deadEffectManager = {}

function cfg_Monster_deadEffectManager:GetName()
  return "cfg_Monster_deadEffectManager"
end

function cfg_Monster_deadEffectManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_deadEffect")
  end
  return self.dic
end

setmetatable(cfg_Monster_deadEffectManager, TableManagerBase)

function cfg_Monster_deadEffectManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_deadEffectManager
