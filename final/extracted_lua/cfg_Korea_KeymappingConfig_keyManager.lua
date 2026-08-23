local cfg_Korea_KeymappingConfig_keyManager = {}

function cfg_Korea_KeymappingConfig_keyManager:GetName()
  return "cfg_Korea_KeymappingConfig_keyManager"
end

function cfg_Korea_KeymappingConfig_keyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Korea_KeymappingConfig_key")
  end
  return self.dic
end

setmetatable(cfg_Korea_KeymappingConfig_keyManager, TableManagerBase)

function cfg_Korea_KeymappingConfig_keyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Korea_KeymappingConfig_keyManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Korea_KeymappingConfig_keyManager
