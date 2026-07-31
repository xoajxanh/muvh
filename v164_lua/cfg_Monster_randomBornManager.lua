local cfg_Monster_randomBornManager = {}

function cfg_Monster_randomBornManager:GetName()
  return "cfg_Monster_randomBornManager"
end

function cfg_Monster_randomBornManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_randomBorn")
  end
  return self.dic
end

setmetatable(cfg_Monster_randomBornManager, TableManagerBase)

function cfg_Monster_randomBornManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_randomBornManager
