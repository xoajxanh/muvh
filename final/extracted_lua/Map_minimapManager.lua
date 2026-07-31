local Map_minimapManager = {}

function Map_minimapManager:GetName()
  return "Map_minimapManager"
end

function Map_minimapManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Map_minimap")
  end
  return self.dic
end

setmetatable(Map_minimapManager, TableManagerBase)

function Map_minimapManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return Map_minimapManager
