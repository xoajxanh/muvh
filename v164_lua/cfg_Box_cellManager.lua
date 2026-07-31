local cfg_Box_cellManager = {}

function cfg_Box_cellManager:GetName()
  return "cfg_Box_cellManager"
end

function cfg_Box_cellManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Box_cell")
  end
  return self.dic
end

setmetatable(cfg_Box_cellManager, TableManagerBase)

function cfg_Box_cellManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Box_cellManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Box_cellManager
