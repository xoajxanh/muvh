local cfg_Function_disableManager = {}

function cfg_Function_disableManager:GetName()
  return "cfg_Function_disableManager"
end

function cfg_Function_disableManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Function_disable")
  end
  return self.dic
end

setmetatable(cfg_Function_disableManager, TableManagerBase)

function cfg_Function_disableManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Function_disableManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Function_disableManager
