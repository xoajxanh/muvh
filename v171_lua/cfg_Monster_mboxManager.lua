local cfg_Monster_mboxManager = {}

function cfg_Monster_mboxManager:GetName()
  return "cfg_Monster_mboxManager"
end

function cfg_Monster_mboxManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_mbox")
  end
  return self.dic
end

setmetatable(cfg_Monster_mboxManager, TableManagerBase)

function cfg_Monster_mboxManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_mboxManager
