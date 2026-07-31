local cfg_Guard_cultureManager = {}

function cfg_Guard_cultureManager:GetName()
  return "cfg_Guard_cultureManager"
end

function cfg_Guard_cultureManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Guard_culture")
  end
  return self.dic
end

setmetatable(cfg_Guard_cultureManager, TableManagerBase)

function cfg_Guard_cultureManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Guard_cultureManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Guard_cultureManager
