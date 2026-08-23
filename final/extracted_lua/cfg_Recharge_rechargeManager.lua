local cfg_Recharge_rechargeManager = {}

function cfg_Recharge_rechargeManager:GetName()
  return "cfg_Recharge_rechargeManager"
end

function cfg_Recharge_rechargeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_recharge")
  end
  return self.dic
end

setmetatable(cfg_Recharge_rechargeManager, TableManagerBase)

function cfg_Recharge_rechargeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Recharge_rechargeManager:GetTabListByType(id, key)
  return self:BaseGetTabListByType(id, key)
end

return cfg_Recharge_rechargeManager
