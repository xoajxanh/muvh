local cfg_Korea_systemConfigManager = {}

function cfg_Korea_systemConfigManager:GetName()
  return "cfg_Korea_systemConfigManager"
end

function cfg_Korea_systemConfigManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Korea_systemConfig")
  end
  return self.dic
end

setmetatable(cfg_Korea_systemConfigManager, TableManagerBase)

function cfg_Korea_systemConfigManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Korea_systemConfigManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Korea_systemConfigManager
