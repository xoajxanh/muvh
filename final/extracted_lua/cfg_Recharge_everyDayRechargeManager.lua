local cfg_Recharge_everyDayRechargeManager = {}

function cfg_Recharge_everyDayRechargeManager:GetName()
  return "cfg_Recharge_everyDayRechargeManager"
end

function cfg_Recharge_everyDayRechargeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_everyDayRecharge")
  end
  return self.dic
end

setmetatable(cfg_Recharge_everyDayRechargeManager, TableManagerBase)

function cfg_Recharge_everyDayRechargeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Recharge_everyDayRechargeManager
