local cfg_Commerce_overviewManager = {}

function cfg_Commerce_overviewManager:GetName()
  return "cfg_Commerce_overviewManager"
end

function cfg_Commerce_overviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_overview")
  end
  return self.dic
end

setmetatable(cfg_Commerce_overviewManager, TableManagerBase)

function cfg_Commerce_overviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_overviewManager:GetCommerceTabByGroup(_group)
  for index, value in pairs(self:GetDic()) do
    if value.group == _group then
      return value
    end
  end
  return nil
end

function cfg_Commerce_overviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_overviewManager
