local cfg_Commerce_lianxuManager = {}

function cfg_Commerce_lianxuManager:GetName()
  return "cfg_Commerce_lianxuManager"
end

function cfg_Commerce_lianxuManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_lianxu")
  end
  return self.dic
end

setmetatable(cfg_Commerce_lianxuManager, TableManagerBase)

function cfg_Commerce_lianxuManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_lianxuManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_lianxuManager
