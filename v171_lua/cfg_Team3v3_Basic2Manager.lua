local cfg_Team3v3_Basic2Manager = {}

function cfg_Team3v3_Basic2Manager:GetName()
  return "cfg_Team3v3_Basic2Manager"
end

function cfg_Team3v3_Basic2Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Team3v3_Basic2")
  end
  return self.dic
end

setmetatable(cfg_Team3v3_Basic2Manager, TableManagerBase)

function cfg_Team3v3_Basic2Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Team3v3_Basic2Manager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Team3v3_Basic2Manager
