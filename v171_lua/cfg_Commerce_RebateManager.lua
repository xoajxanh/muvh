local cfg_Commerce_RebateManager = {}

function cfg_Commerce_RebateManager:GetName()
  return "cfg_Commerce_RebateManager"
end

function cfg_Commerce_RebateManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Rebate")
  end
  return self.dic
end

setmetatable(cfg_Commerce_RebateManager, TableManagerBase)

function cfg_Commerce_RebateManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_RebateManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_RebateManager
