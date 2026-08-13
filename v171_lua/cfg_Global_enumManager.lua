local cfg_Global_enumManager = {}

function cfg_Global_enumManager:GetName()
  return "cfg_Global_enumManager"
end

function cfg_Global_enumManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Global_enum")
  end
  return self.dic
end

setmetatable(cfg_Global_enumManager, TableManagerBase)

function cfg_Global_enumManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Global_enumManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Global_enumManager
