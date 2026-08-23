local cfg_Map_goldenMonsterSeekManager = {}

function cfg_Map_goldenMonsterSeekManager:GetName()
  return "cfg_Map_goldenMonsterSeekManager"
end

function cfg_Map_goldenMonsterSeekManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_goldenMonsterSeek")
  end
  return self.dic
end

setmetatable(cfg_Map_goldenMonsterSeekManager, TableManagerBase)

function cfg_Map_goldenMonsterSeekManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Map_goldenMonsterSeekManager
