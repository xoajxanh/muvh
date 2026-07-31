local cfg_Monster_monsterPotManager = {}

function cfg_Monster_monsterPotManager:GetName()
  return "cfg_Monster_monsterPotManager"
end

function cfg_Monster_monsterPotManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_monsterPot")
  end
  return self.dic
end

setmetatable(cfg_Monster_monsterPotManager, TableManagerBase)

function cfg_Monster_monsterPotManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_monsterPotManager
