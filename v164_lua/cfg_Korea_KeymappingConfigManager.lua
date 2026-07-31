local cfg_Korea_KeymappingConfigManager = {}

function cfg_Korea_KeymappingConfigManager:GetName()
  return "cfg_Korea_KeymappingConfigManager"
end

function cfg_Korea_KeymappingConfigManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Korea_KeymappingConfig")
  end
  return self.dic
end

setmetatable(cfg_Korea_KeymappingConfigManager, TableManagerBase)

function cfg_Korea_KeymappingConfigManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Korea_KeymappingConfigManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Korea_KeymappingConfigManager
