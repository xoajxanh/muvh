local cfg_union_eventManager = {}

function cfg_union_eventManager:GetName()
  return "cfg_union_eventManager"
end

function cfg_union_eventManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_event")
  end
  return self.dic
end

setmetatable(cfg_union_eventManager, TableManagerBase)

function cfg_union_eventManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_eventManager
