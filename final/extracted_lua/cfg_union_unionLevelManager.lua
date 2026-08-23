local cfg_union_unionLevelManager = {}

function cfg_union_unionLevelManager:GetName()
  return "cfg_union_unionLevelManager"
end

function cfg_union_unionLevelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_unionLevel")
  end
  return self.dic
end

setmetatable(cfg_union_unionLevelManager, TableManagerBase)

function cfg_union_unionLevelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_unionLevelManager
