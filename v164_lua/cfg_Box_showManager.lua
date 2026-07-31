local cfg_Box_showManager = {}

function cfg_Box_showManager:GetName()
  return "cfg_Box_showManager"
end

function cfg_Box_showManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Box_show")
  end
  return self.dic
end

setmetatable(cfg_Box_showManager, TableManagerBase)

function cfg_Box_showManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Box_showManager
