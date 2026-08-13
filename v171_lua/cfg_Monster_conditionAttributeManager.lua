local cfg_Monster_conditionAttributeManager = {}

function cfg_Monster_conditionAttributeManager:GetName()
  return "cfg_Monster_conditionAttributeManager"
end

function cfg_Monster_conditionAttributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_conditionAttribute")
  end
  return self.dic
end

setmetatable(cfg_Monster_conditionAttributeManager, TableManagerBase)

function cfg_Monster_conditionAttributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_conditionAttributeManager
