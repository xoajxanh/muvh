local cfg_Team3v3_BasicManager = {}

function cfg_Team3v3_BasicManager:GetName()
  return "cfg_Team3v3_BasicManager"
end

function cfg_Team3v3_BasicManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Team3v3_Basic")
  end
  return self.dic
end

setmetatable(cfg_Team3v3_BasicManager, TableManagerBase)

function cfg_Team3v3_BasicManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Team3v3_BasicManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Team3v3_BasicManager
