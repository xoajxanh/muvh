local cfg_Audio_monsterManager = {}

function cfg_Audio_monsterManager:GetName()
  return "cfg_Audio_monsterManager"
end

function cfg_Audio_monsterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Audio_monster")
  end
  return self.dic
end

setmetatable(cfg_Audio_monsterManager, TableManagerBase)

function cfg_Audio_monsterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Audio_monsterManager
