local cfg_Recharge_directRepayManager = {}

function cfg_Recharge_directRepayManager:GetName()
  return "cfg_Recharge_directRepayManager"
end

function cfg_Recharge_directRepayManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_directRepay")
  end
  return self.dic
end

setmetatable(cfg_Recharge_directRepayManager, TableManagerBase)

function cfg_Recharge_directRepayManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Recharge_directRepayManager
