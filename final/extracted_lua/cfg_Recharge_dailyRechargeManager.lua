local cfg_Recharge_dailyRechargeManager = {}

function cfg_Recharge_dailyRechargeManager:GetName()
  return "cfg_Recharge_dailyRechargeManager"
end

function cfg_Recharge_dailyRechargeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_dailyRecharge")
  end
  return self.dic
end

setmetatable(cfg_Recharge_dailyRechargeManager, TableManagerBase)

function cfg_Recharge_dailyRechargeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Recharge_dailyRechargeManager
