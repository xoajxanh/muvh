local cfg_Count_countManager = {}

function cfg_Count_countManager:GetName()
  return "cfg_Count_countManager"
end

function cfg_Count_countManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Count_count")
  end
  return self.dic
end

setmetatable(cfg_Count_countManager, TableManagerBase)

function cfg_Count_countManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Count_countManager
