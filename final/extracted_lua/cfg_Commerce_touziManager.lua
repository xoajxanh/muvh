local cfg_Commerce_touziManager = {}

function cfg_Commerce_touziManager:GetName()
  return "cfg_Commerce_touziManager"
end

function cfg_Commerce_touziManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_touzi")
  end
  return self.dic
end

setmetatable(cfg_Commerce_touziManager, TableManagerBase)

function cfg_Commerce_touziManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_touziManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_touziManager
