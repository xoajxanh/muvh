local cfg_Monster_dropItemManager = {}

function cfg_Monster_dropItemManager:GetName()
  return "cfg_Monster_dropItemManager"
end

function cfg_Monster_dropItemManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_dropItem")
  end
  return self.dic
end

setmetatable(cfg_Monster_dropItemManager, TableManagerBase)

function cfg_Monster_dropItemManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_dropItemManager
