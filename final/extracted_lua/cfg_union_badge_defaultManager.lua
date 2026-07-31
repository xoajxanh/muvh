local cfg_union_badge_defaultManager = {}

function cfg_union_badge_defaultManager:GetName()
  return "cfg_union_badge_defaultManager"
end

function cfg_union_badge_defaultManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_badge_default")
  end
  return self.dic
end

setmetatable(cfg_union_badge_defaultManager, TableManagerBase)

function cfg_union_badge_defaultManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_badge_defaultManager
