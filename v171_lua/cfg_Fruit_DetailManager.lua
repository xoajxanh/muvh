local cfg_Fruit_DetailManager = {}

function cfg_Fruit_DetailManager:GetName()
  return "cfg_Fruit_DetailManager"
end

function cfg_Fruit_DetailManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Fruit_Detail")
  end
  return self.dic
end

setmetatable(cfg_Fruit_DetailManager, TableManagerBase)

function cfg_Fruit_DetailManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Fruit_DetailManager
