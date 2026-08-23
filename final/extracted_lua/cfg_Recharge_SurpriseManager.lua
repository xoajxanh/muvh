local cfg_Recharge_SurpriseManager = {}

function cfg_Recharge_SurpriseManager:GetName()
  return "cfg_Recharge_SurpriseManager"
end

function cfg_Recharge_SurpriseManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_Surprise")
  end
  return self.dic
end

setmetatable(cfg_Recharge_SurpriseManager, TableManagerBase)

function cfg_Recharge_SurpriseManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Recharge_SurpriseManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Recharge_SurpriseManager
