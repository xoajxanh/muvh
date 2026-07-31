local cfg_Level_reincarnationManager = {}

function cfg_Level_reincarnationManager:GetName()
  return "cfg_Level_reincarnationManager"
end

function cfg_Level_reincarnationManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Level_reincarnation")
  end
  return self.dic
end

setmetatable(cfg_Level_reincarnationManager, TableManagerBase)

function cfg_Level_reincarnationManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Level_reincarnationManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Level_reincarnationManager
