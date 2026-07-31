local cfg_union_memberManager = {}

function cfg_union_memberManager:GetName()
  return "cfg_union_memberManager"
end

function cfg_union_memberManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_member")
  end
  return self.dic
end

setmetatable(cfg_union_memberManager, TableManagerBase)

function cfg_union_memberManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_memberManager
