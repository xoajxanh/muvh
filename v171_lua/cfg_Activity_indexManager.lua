local cfg_Activity_indexManager = {}

function cfg_Activity_indexManager:GetName()
  return "cfg_Activity_indexManager"
end

function cfg_Activity_indexManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_index")
  end
  return self.dic
end

setmetatable(cfg_Activity_indexManager, TableManagerBase)

function cfg_Activity_indexManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_indexManager
