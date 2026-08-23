local cfg_Team3v3_promptwordManager = {}

function cfg_Team3v3_promptwordManager:GetName()
  return "cfg_Team3v3_promptwordManager"
end

function cfg_Team3v3_promptwordManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Team3v3_promptword")
  end
  return self.dic
end

setmetatable(cfg_Team3v3_promptwordManager, TableManagerBase)

function cfg_Team3v3_promptwordManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Team3v3_promptwordManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Team3v3_promptwordManager
