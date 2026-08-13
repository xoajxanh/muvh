local cfg_Commerce_RechargeManager = {}

function cfg_Commerce_RechargeManager:GetName()
  return "cfg_Commerce_RechargeManager"
end

function cfg_Commerce_RechargeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Recharge")
  end
  return self.dic
end

setmetatable(cfg_Commerce_RechargeManager, TableManagerBase)

function cfg_Commerce_RechargeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_RechargeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_RechargeManager
