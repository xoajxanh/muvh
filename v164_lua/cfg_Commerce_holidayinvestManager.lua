local cfg_Commerce_holidayinvestManager = {}

function cfg_Commerce_holidayinvestManager:GetName()
  return "cfg_Commerce_holidayinvestManager"
end

function cfg_Commerce_holidayinvestManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_holidayinvest")
  end
  return self.dic
end

setmetatable(cfg_Commerce_holidayinvestManager, TableManagerBase)

function cfg_Commerce_holidayinvestManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_holidayinvestManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_holidayinvestManager
