local cfg_Camp_memberManager = {}

function cfg_Camp_memberManager:GetName()
  return "cfg_Camp_memberManager"
end

function cfg_Camp_memberManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Camp_member")
  end
  return self.dic
end

setmetatable(cfg_Camp_memberManager, TableManagerBase)

function cfg_Camp_memberManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Camp_memberManager
