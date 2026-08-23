local cfg_Commerce_sevengiftManager = {}

function cfg_Commerce_sevengiftManager:GetName()
  return "cfg_Commerce_sevengiftManager"
end

function cfg_Commerce_sevengiftManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_sevengift")
  end
  return self.dic
end

setmetatable(cfg_Commerce_sevengiftManager, TableManagerBase)

function cfg_Commerce_sevengiftManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_sevengiftManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_sevengiftManager
