local cfg_Commerce_RechargeoverviewManager = {}

function cfg_Commerce_RechargeoverviewManager:GetName()
  return "cfg_Commerce_RechargeoverviewManager"
end

function cfg_Commerce_RechargeoverviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Rechargeoverview")
  end
  return self.dic
end

setmetatable(cfg_Commerce_RechargeoverviewManager, TableManagerBase)

function cfg_Commerce_RechargeoverviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_RechargeoverviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_RechargeoverviewManager
