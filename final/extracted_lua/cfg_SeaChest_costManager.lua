local cfg_SeaChest_costManager = {}

function cfg_SeaChest_costManager:GetName()
  return "cfg_SeaChest_costManager"
end

function cfg_SeaChest_costManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_SeaChest_cost")
  end
  return self.dic
end

setmetatable(cfg_SeaChest_costManager, TableManagerBase)

function cfg_SeaChest_costManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_SeaChest_costManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_SeaChest_costManager
