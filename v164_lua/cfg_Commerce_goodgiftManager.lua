local cfg_Commerce_goodgiftManager = {}

function cfg_Commerce_goodgiftManager:GetName()
  return "cfg_Commerce_goodgiftManager"
end

function cfg_Commerce_goodgiftManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_goodgift")
  end
  return self.dic
end

setmetatable(cfg_Commerce_goodgiftManager, TableManagerBase)

function cfg_Commerce_goodgiftManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_goodgiftManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_goodgiftManager
