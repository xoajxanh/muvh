local cfg_union_badgeManager = {}

function cfg_union_badgeManager:GetName()
  return "cfg_union_badgeManager"
end

function cfg_union_badgeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_badge")
  end
  return self.dic
end

setmetatable(cfg_union_badgeManager, TableManagerBase)

function cfg_union_badgeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_badgeManager
