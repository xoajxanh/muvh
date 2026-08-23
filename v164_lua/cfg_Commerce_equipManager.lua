local cfg_Commerce_equipManager = {}

function cfg_Commerce_equipManager:GetName()
  return "cfg_Commerce_equipManager"
end

function cfg_Commerce_equipManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_equip")
  end
  return self.dic
end

setmetatable(cfg_Commerce_equipManager, TableManagerBase)

function cfg_Commerce_equipManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_equipManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_equipManager
