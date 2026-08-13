local cfg_Activity_langhunMonsterManager = {}

function cfg_Activity_langhunMonsterManager:GetName()
  return "cfg_Activity_langhunMonsterManager"
end

function cfg_Activity_langhunMonsterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_langhunMonster")
  end
  return self.dic
end

setmetatable(cfg_Activity_langhunMonsterManager, TableManagerBase)

function cfg_Activity_langhunMonsterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_langhunMonsterManager
